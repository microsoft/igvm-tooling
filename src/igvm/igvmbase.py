import argparse

from abc import abstractclassmethod

from igvm.igvmfile import IGVMFile, PGSIZE
from igvm.structure.linuxboot import struct_cc_blob_sev_info, CC_BLOB_SEV_HDR_MAGIC


class IGVMBaseGenerator(object):
    SNP_CPUID_PAGE_ADDR = 0x800000

    def __init__(self, **kwargs):
        self._vtl: int = kwargs["vtl"]
        self.infile: argparse.FileType = kwargs["kernel"]

        # Init IGVMFile state
        config = kwargs["config"] if "config" in kwargs else None
        sign_key = kwargs["sign_key"] if "sign_key" in kwargs else None
        pem = sign_key.read() if sign_key else None
        boot_mode = kwargs["boot_mode"]
        self.state: IGVMFile = IGVMFile(boot_mode=boot_mode,
                                        config_path=config,
                                        pem=pem,
                                        encrypted_page=kwargs["encrypted_page"],
                                        svme=kwargs["svme"])
        self.cpuid_page: int = 0
        self.secrets_page: int = 0
        self.param_page: int = 0

    @abstractclassmethod
    def setup_before_code(self, **kwargs):
        """Set up memory before code"""
        pass

    @abstractclassmethod
    def setup_after_code(self, kernel_entry: int, **kwargs):
        """Set up memory after code"""
        pass

    @abstractclassmethod
    def load_code(self, **kwargs) -> int:
        """Load code and return entry address"""
        pass

    def generate(self):
        # ACPI
        self.setup_before_code()

        # for CPUID/secrets/param pages
        self.state.seek(self.SNP_CPUID_PAGE_ADDR)
        self.cpuid_page = self.state.memory.allocate(PGSIZE)
        self.secrets_page = self.state.memory.allocate(PGSIZE)
        self.param_page = self.state.memory.allocate(PGSIZE)
        self.sev_info_page = self.state.memory.allocate(PGSIZE)

        sev_info = struct_cc_blob_sev_info.from_buffer(
            self.state.memory, self.sev_info_page)
        sev_info.magic = CC_BLOB_SEV_HDR_MAGIC
        sev_info.secrets_phys = self.secrets_page
        sev_info.secrets_len = PGSIZE
        sev_info.cpuid_phys = self.cpuid_page
        sev_info.cpuid_len = PGSIZE
        del sev_info

        # VMSA page at 0x804000
        vmsa_page = self.state.memory.allocate(PGSIZE)  # VMSA page
        # Load vmlinux image
        kernel_entry = self.load_code()

        # Allocate gdt, boot_params, cmdline and ramdisk pages
        self.setup_after_code(kernel_entry, self.sev_info_page)
        return self.state.raw(
            vmsa_page, self.cpuid_page, self.secrets_page, self.param_page, self.sev_info_page, self._vtl)
