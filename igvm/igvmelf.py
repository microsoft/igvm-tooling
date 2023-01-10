import argparse
import logging
import subprocess

from ctypes import sizeof
from typing import List

import igvm.elf as elflib

from igvm.bootcstruct import *
from igvm.acpi import ACPI, ACPI_RSDP_ADDR
from igvm.igvmbase import IGVMBaseGenerator
from igvm.igvmfile import PGSIZE, ALIGN
from igvm.vmstate import ARCH
boot_params = struct_boot_params
setup_header = struct_setup_header


class IGVMELFGenerator(IGVMBaseGenerator):

    BOOT_STACK_SIZE = 0x1000
    def __init__(self, **kwargs):
        # Parse BzImage header
        IGVMBaseGenerator.__init__(self, **kwargs)
        self.extra_validated_ram: List = []
        self._start = kwargs["start_addr"]

        acpi_dir = kwargs["acpi_dir"] if "acpi_dir" in kwargs else None
        self.acpidata: ACPI = ACPI(acpi_dir)

        self.elf = elflib.ELFObj(self.infile)
        self.cmdline = bytes(kwargs["append"] if "append" in kwargs else None, 'ascii') + bytes([0])

        in_path = self.infile.name
        bin_path = in_path + ".binary"
        subprocess.check_output(["objcopy", in_path, "-O", "binary", bin_path])
        with open(bin_path, "rb") as f:
            self._kernel: bytes = f.read()

        vmpl2_file: argparse.FileType = kwargs["vmpl2_kernel"] if "vmpl2_kernel" in kwargs else None
        self.pgtable_level: int = kwargs["pgtable_level"] if "pgtable_level" in kwargs else 2
        self._vmpl2_kernel: bytearray = bytearray(
            vmpl2_file.read()) if vmpl2_file else bytearray()
        # Create a setup_header for 32-bit

    @property
    def _vmpl2_header(self) -> setup_header:
        if not self._vmpl2_kernel:
            return None
        header = setup_header.from_buffer(self._vmpl2_kernel, 0x1f1)
        assert header.header.to_bytes(
            4, 'little') == b'HdrS', 'invalid setup_header'
        assert header.pref_address > 3 * 1024 * 1024, 'loading base cannot be below 3MB'
        assert header.xloadflags & 1, '64-bit entrypoint does not exist'
        assert header.pref_address % PGSIZE == 0
        assert header.init_size % PGSIZE == 0
        return header

    def setup_before_code(self):
        # [0-0xa0000] is reserved for BIOS
        # [0xe0000 - 0x200000] is for ACPI related data
        # load ACPI pages
        acpi_tables = self.acpidata
        sorted_gpa = sorted(acpi_tables.acpi.keys())
        # RAM for bios/bootloader
        self.state.seek(0xa0000)
        self.state.memory.allocate(acpi_tables.end_addr - 0xa0000)
        for gpa in sorted_gpa:
            self.state.memory.write(gpa, acpi_tables.acpi[gpa])
        self.state.seek(acpi_tables.end_addr)
        return sorted_gpa[0]

    def load_code(self):
        # Setup pgtable and boot stack after vmsa page but before code.
        boot_stack_addr = self.state.memory.allocate(self.BOOT_STACK_SIZE, 16)
        self.state.vmsa.rsp = boot_stack_addr + self.BOOT_STACK_SIZE

        self.cmdline_addr = self.state.memory.allocate(len(self.cmdline))
        self.state.memory.write(self.cmdline_addr, self.cmdline)

        self.state.setup_paging(paging_level = self.pgtable_level)

        addr = self.state.memory.allocate(0)
        self.extra_validated_ram.append((boot_stack_addr, addr - boot_stack_addr))
        # setup code
        self._start = ALIGN(addr, PGSIZE)
        self.state.seek(self._start)
        self.state.memory.allocate(len(self._kernel), PGSIZE)
        self.state.memory.write(self._start, self._kernel)
        entry_offset = self.elf.elf.header.e_entry - \
            self.elf.elf.get_section_by_name(".text").header.sh_addr
        self.extra_validated_ram.append((self._start, len(self._kernel)))
        return self._start + entry_offset

    def load_vmpl2_kernel(self, vmpl2_addr: int):
        self.state.seek(vmpl2_addr)
        self.state.memory.allocate(len(self._vmpl2_kernel), PGSIZE)
        self.state.memory.write(vmpl2_addr, self._vmpl2_kernel)
        self.extra_validated_ram.append((vmpl2_addr, len(self._vmpl2_kernel)))

    def setup_after_code(self, kernel_entry: int):
        # Skip all sections
        text_start = self.elf.elf.get_section_by_name(".text").header.sh_addr
        monitor_end = ALIGN(self.state.memory.allocate(0), PGSIZE)
        max_addr = 0
        for s in self.elf.elf.iter_sections():
            max_addr = max(max_addr, s.header.sh_addr + s.header.sh_size)
        monitor_end = max(monitor_end, ALIGN(max_addr - text_start + kernel_entry, PGSIZE))
        self.state.seek(monitor_end)

        # Setup other input data to security monitor
        addr = self.state.memory.allocate(0)
        self.state.setup_gdt()
        monitor_params_addr = self.state.memory.allocate(
            sizeof(struct_monitor_params))
        boot_params_addr = self.state.memory.allocate(
            sizeof(struct_boot_params))
        end = self.state.memory.allocate(0)
        self.extra_validated_ram.append((addr, end-addr))
        vmpl2_kernel_addr = 0x3d00000
        self.state.vmsa.rip = kernel_entry
        self.state.vmsa.rsi = monitor_params_addr
        # Load VMPL2 kernel
        self.load_vmpl2_kernel(vmpl2_kernel_addr)

        # Define VMPL2 kernel's boot parameter
        params = struct_boot_params.from_buffer(
            self.state.memory, boot_params_addr)
        if self._vmpl2_header:
            params.hdr = self._vmpl2_header
        params.hdr.cmd_line_ptr = self.cmdline_addr
        params.hdr.cmdline_size = len(self.cmdline)
        params.acpi_rsdp_addr = ACPI_RSDP_ADDR
        params.e820_entries = self._setup_e820_opt(params.e820_table)
        del params  # kill reference to re-allow allocation

        # Define VMPL0 monitor's boot parameter
        monitor_params = struct_monitor_params.from_buffer(
            self.state.memory, monitor_params_addr)
        monitor_params.cpuid_page = self.cpuid_page
        monitor_params.secret_page = self.secrets_page
        # TODO: Change to self.param_page + sizeof(IGVM_VHS_MEMORY_MAP_ENTRY)
        monitor_params.hv_param_page = self.param_page
        monitor_params.vmpl2_start = vmpl2_kernel_addr
        monitor_params.vmpl2_kernel_size = len(self._vmpl2_kernel)
        monitor_params.vmpl2_boot_param = boot_params_addr
        del monitor_params

    def _setup_e820_opt(self, e820_table):
        e820_table[0].addr = 0
        e820_table[0].size = 0
        e820_table[0].type = E820_TYPE_RAM
        e820_table[1].addr = 0xa0000
        e820_table[1].size = 0x100000 - 0xa0000
        e820_table[1].type = E820_TYPE_RESERVED
        e820_table[2].addr = 0x100000
        e820_table[2].size = self.acpidata.end_addr - 0x100000
        e820_table[2].type = E820_TYPE_ACPI
        e820_table[3].addr = self.SNP_CPUID_PAGE_ADDR
        e820_table[3].size = 4 * PGSIZE
        e820_table[3].type = E820_TYPE_RESERVED
        count = 4
        for addr, size in self.extra_validated_ram:
            e820_table[count].addr = addr
            e820_table[count].size = size
            e820_table[count].type = E820_TYPE_RESERVED
            count += 1
        for i in range(count):
            logging.debug("%x %x"%(e820_table[i].addr, e820_table[i].addr + e820_table[i].size))

        return count
