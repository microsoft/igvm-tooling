import argparse

from abc import abstractclassmethod

from igvm.igvmfile import IGVMFile, PGSIZE


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
                                        config_path=config,  pem=pem)

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
        cpuid_page = self.state.memory.allocate(PGSIZE)
        secrets_page = self.state.memory.allocate(PGSIZE)
        param_page = self.state.memory.allocate(PGSIZE)
        # VMSA page at 0x803000
        vmsa_page = self.state.memory.allocate(PGSIZE)  # VMSA page
        # Load vmlinux image
        kernel_entry = self.load_code()

        # Allocate gdt, boot_params, cmdline and ramdisk pages
        self.setup_after_code(kernel_entry)
        return self.state.raw(
            vmsa_page, cpuid_page, secrets_page, param_page, self._vtl)
