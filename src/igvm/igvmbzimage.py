import logging
from typing import List, Tuple

import igvm.elf as elflib

from ctypes import sizeof
from igvm.acpi import ACPI, ACPI_RSDP_ADDR
from igvm.bootcstruct import *
from igvm.igvmbase import IGVMBaseGenerator
from igvm.igvmfile import PGSIZE, ALIGN
from igvm.vmstate import ARCH

boot_params = struct_boot_params
setup_header = struct_setup_header

""" Memory Layout
|------|-------|**----|*---|***---|*******0-------0|****----|
  BIOS  RESVD  ACPI   VMSA  cpuids   vmlinux      boot_params
                            secrets               command
                            params                ramdisk
*: data imported and measured 
0: memory required used before long mode

HV should launch_update some empty pages since
    * startup_32 uses boot_stack(unrelocated) and pgtable(relocated)
    * pvalidate must run after jumping to long mode (startup_64)
See more details in arch/x86/boot/compressed/head_64.S
  |<-----------vmlinux.bin-------->|
A:|*********|*******|**************|------|0000|-------|--------------|
 start_32  start_64  compressed   heap  stack pgtable _end
  |<-------------------------------init_size ------------------------>|

B:|-------------|---------------------------------------------|0000000|
                |<-----------vmlinux.bin-------->|          pgtable  _end

startup_32 accesses boot_stack based on the original layout A;
startup_32 sets up pgtable using future layout B.
"""


class IGVMLinuxGenerator(IGVMBaseGenerator):
    BOOT_HEAP_SIZE = 0x10000
    BOOT_STACK_SIZE = 0x4000
    BOOT_PGT_SIZE = 0x6000
    TOP_PGT_SIZE = 0x1000
    INIT_PGTABLE_SIZE = TOP_PGT_SIZE + BOOT_PGT_SIZE
    USED_BSS_NAMES = ("boot_stack",)
    USED_REL_BSS_NAMES = ("pgtable",)

    def __init__(self, **kwargs):
        # Parse BzImage header
        IGVMBaseGenerator.__init__(self, **kwargs)
        self._extra_validated_ram: List = []
        self._use_pvalidate_opt: bool = kwargs["pvalidate_opt"]
        self._kernel: bytearray = bytearray(self.infile.read())
        self.cmdline: bytes = bytes(kwargs["append"], 'ascii')

        symbol_file = kwargs["symbol_elf"]
        self._elf: elflib.ELFObj = elflib.ELFObj(
            symbol_file) if symbol_file else None

        acpi_dir = kwargs["acpi_dir"] if "acpi_dir" in kwargs else None
        self.acpidata: ACPI = ACPI(acpi_dir)
        rdinit = kwargs["rdinit"] if "rdinit" in kwargs else None
        self.ramdisk: bytearray = bytearray(
            rdinit.read()) if rdinit else bytearray()

    @property
    def _header(self) -> setup_header:
        header = setup_header.from_buffer(self._kernel, 0x1f1)
        assert header.header.to_bytes(
            4, 'little') == b'HdrS', 'invalid setup_header'
        assert header.pref_address > 3 * 1024 * 1024, 'loading base cannot be below 3MB'
        assert header.xloadflags & 1, '64-bit entrypoint does not exist'
        assert header.pref_address % PGSIZE == 0
        assert header.init_size % PGSIZE == 0
        return header

    @property
    def kernel_needed_mem(self) -> int:
        return self._header.init_size

    @property
    def vmlinux_bin(self) -> bytes:
        # Skip real-mode setup code
        vmlinux_bin_start = (self._header.setup_sects + 1) * 512
        return self._kernel[vmlinux_bin_start:]

    @property
    def vmlinux_size(self) -> int:
        return ALIGN(len(self.vmlinux_bin), PGSIZE)

    def _extra_mem_by_default(self) -> List[elflib.Symbol]:
        extra_mem = []
        extra_mem.append(
            elflib.Symbol(
                self.vmlinux_size + self.BOOT_HEAP_SIZE, self.BOOT_STACK_SIZE))
        extra_mem.append(elflib.Symbol(
            self.kernel_needed_mem - self.INIT_PGTABLE_SIZE,
            self.INIT_PGTABLE_SIZE))
        return extra_mem

    def _extra_mem_by_elf(self, elf: elflib.ELFObj) -> List[elflib.Symbol]:
        extra_mem = []
        end = elf.get_symbol("_end").addr
        for name in self.USED_BSS_NAMES:
            extra_mem.append(elf.get_symbol(name))
        for name in self.USED_REL_BSS_NAMES:
            sym = elf.get_symbol(name)
            sym.addr = self._header.init_size - end + sym.addr
            extra_mem.append(sym)
        return extra_mem

    @property
    def extra_mem_in_startup32(self) -> List[elflib.Symbol]:
        if self._elf:
            extra_mem = self._extra_mem_by_elf(self._elf)
        else:
            extra_mem = self._extra_mem_by_default()
        return sorted(extra_mem, key=lambda x: x.addr)

    def _setup_mem_for32(self):
        # Allocate BOOT_STACK
        for symbol in self.extra_mem_in_startup32:
            addr = self._header.pref_address + symbol.addr
            size = symbol.size
            self.state.seek(addr)
            logging.debug("_setup_mem_for32=%x %x" % (addr, size))
            self.state.memory.allocate(size)
            self._extra_validated_ram.append((addr, size))

    def _setup_e820(self, e820_table):
        e820_table[0].addr = 0
        e820_table[0].size = 0xa0000
        e820_table[0].type = E820_TYPE_RAM
        e820_table[1].addr = 0xa0000
        e820_table[1].size = 0x100000 - 0xa0000
        e820_table[1].type = E820_TYPE_RESERVED
        e820_table[2].addr = 0x100000
        e820_table[2].size = self.acpidata.end_addr - 0x100000
        e820_table[2].type = E820_TYPE_ACPI
        e820_table[3].addr = self._header.pref_address
        e820_table[3].size = self.state.memory.allocate(
            0) - self._header.pref_address
        e820_table[3].type = E820_TYPE_RAM
        count = 4
        for i in range(count):
            logging.debug("%x %x" % (
                e820_table[i].addr, e820_table[i].addr + e820_table[i].size))
        return count

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
        e820_table[3].addr = self._header.pref_address
        e820_table[3].size = self.vmlinux_size
        e820_table[3].type = E820_TYPE_RAM
        count = 4
        for addr, size in self._extra_validated_ram:
            e820_table[count].addr = addr
            e820_table[count].size = size
            e820_table[count].type = E820_TYPE_RAM
            count += 1
        for i in range(count):
            logging.debug("%x %x" % (
                e820_table[i].addr, e820_table[i].addr + e820_table[i].size))
        return count

    def setup_before_code(self, **kwargs):
        # [0-0xa0000] is reserved for BIOS
        # [0xe0000 - 0x200000] is for ACPI related data
        # load ACPI pages
        acpi_tables = self.acpidata
        sorted_gpa = list(acpi_tables.acpi.keys())
        sorted_gpa.sort()
        if not self._use_pvalidate_opt:
            self.state.memory.allocate(acpi_tables.end_addr)
        else:
             # RAM for bios/bootloader
            self.state.seek(0xa0000)
            self.state.memory.allocate(acpi_tables.end_addr - 0xa0000)

        for gpa in sorted_gpa:
            self.state.memory.write(gpa, acpi_tables.acpi[gpa])
        logging.debug("acpi_tables.end_addr=%x" % (acpi_tables.end_addr))
        self.state.seek(acpi_tables.end_addr)
        return sorted_gpa[0]

    def load_code(self) -> int:
        kernel_base = self._header.pref_address
        self.state.seek(kernel_base)
        if self._use_pvalidate_opt:
            logging.debug("_use_pvalidate_opt")
            self.state.memory.allocate(self.vmlinux_size)
            logging.debug("kernel end = %x" % (self.state.memory.allocate(0)))
            self._setup_mem_for32()
        else:
            self.state.memory.allocate(self.kernel_needed_mem)
        self.state.memory.write(kernel_base, self.vmlinux_bin)

        logging.debug("kernel need = %x" %
                      (kernel_base + self.kernel_needed_mem))
        self.state.seek(kernel_base + self.kernel_needed_mem)

        return kernel_base + (0x200 if self.state.boot_mode == ARCH.X64 else 0)

    def setup_after_code(self, kernel_entry: int):
        addr = self.state.setup_paging()
        self.state.setup_gdt()
        boot_params_addr = self.state.memory.allocate(sizeof(boot_params))
        cmdline_addr = self.state.memory.allocate(len(self.cmdline) + 1)
        # RAMDISK memory must be page aligned.
        ramdisk_addr = self.state.memory.allocate(len(self.ramdisk), PGSIZE)
        boot_stack_addr = self.state.memory.allocate(PGSIZE)
        self.cc_blob_addr = self.state.memory.allocate(PGSIZE)
        end = self.state.memory.allocate(0, PGSIZE)
        self._extra_validated_ram.append((addr, end-addr))
        params = boot_params.from_buffer(self.state.memory, boot_params_addr)
        cc_blob_addr = self.cc_blob_addr
        cc_blob = struct_cc_blob_sev_info.from_buffer(self.state.memory, cc_blob_addr)

        self.state.memory.write(cmdline_addr, self.cmdline)
        self.state.memory.write(ramdisk_addr, self.ramdisk)
        params.hdr = self._header
        params.hdr.code32_start = kernel_entry
        params.hdr.type_of_loader = 0xff
        params.hdr.cmd_line_ptr = cmdline_addr
        params.hdr.cmdline_size = len(self.cmdline)
        params.hdr.ramdisk_image = ramdisk_addr
        params.hdr.ramdisk_size = len(self.ramdisk)
        logging.info(f"ramdisk at {hex(ramdisk_addr)}")
        params.acpi_rsdp_addr = ACPI_RSDP_ADDR
        params.cc_blob_address = cc_blob_addr

        CC_BLOB_SEV_HDR_MAGIC =	0x45444d41
        cc_blob.magic = CC_BLOB_SEV_HDR_MAGIC
        cc_blob.reserved = 0
        cc_blob.secrets_phys = self.secrets_page
        cc_blob.secrets_len = PGSIZE
        cc_blob.cpuid_phys = self.cpuid_page
        cc_blob.cpuid_len = PGSIZE
        cc_blob.rsvd2 = 0

        # give 1GB to the kernel
        if not self._use_pvalidate_opt:
            params.e820_entries = self._setup_e820(params.e820_table)
        else:
            params.e820_entries = self._setup_e820_opt(params.e820_table)

        del cc_blob
        del params  # kill reference to re-allow allocation
        self.state.vmsa.rip = kernel_entry
        self.state.vmsa.rsi = boot_params_addr
        self.state.vmsa.rsp = boot_stack_addr + PGSIZE


class IGVMLinux2Generator(IGVMLinuxGenerator):
    """Load linux2 payload in guest-invalid memory"""

    def __init__(self, **kwargs):
        # Parse BzImage header
        IGVMLinuxGenerator.__init__(self, **kwargs)
        assert("shared_payload" in kwargs)
        _infile2 = kwargs["shared_payload"]
        self._shared_payload: bytearray = bytearray(_infile2.read())

    def setup_after_code(self, kernel_entry: int):
        IGVMLinuxGenerator.setup_after_code(self, kernel_entry)
        linux2_start = 0x10000000  # TODO: linux2 param
        self.state.seek(linux2_start)
        self.state.memory.allocate(len(self._shared_payload))
        self.state.write_not_validated(linux2_start, self._shared_payload)
