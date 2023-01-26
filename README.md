# IGVM Image Generator

## Install
```
sudo apt install acpica-tools
pip3 install ./
```

## Run
```
igvmgen -h
```

* An example cmd to generate igvm image using bzImage

```
$(IGVMGEN) -o $(OUTPUT) \
		-kernel $(LINUX)/arch/x86/boot/bzImage \
		-append "$(CMDLINE)" \
		-boot_mode x86 \
		-vtl 2 \
		-inform bzImage
```

* To use a customized ACPI table from igvm/acpi/acpi_test

You can create your ACPI table following igvm/acpi/acpi_test's format

```
$(IGVMGEN) -o $(OUTPUT) \
		-kernel $(LINUX)/arch/x86/boot/bzImage \
		-append "$(CMDLINE)" \
		-boot_mode x86 \
		-vtl 2 \
		-inform bzImage \
		-acpi_dir igvm/acpi/acpi_test \
```

* You may use `-pvalidate_opt=true` to create a small image
pvalidate_opt assumes the kernel image will pvalidate data section before using them (https://github.com/wdcui/linux/commit/1c18d853230b142226cfb2c1c16766f7bf843497).
So that we do not need to include memory pages for data section in IGVM image.

* inform ELF is used only for a research protocol not for linux kernel booting.

## Code (igvm/)

### Auto-generated Python from C 
* igvm/structure/linuxboot.py: data structures for linux booting
* igvm/structure/igvmfileformat.py: data structures for IGVM format, extracted from windows os repo

### Real Python code:

* igvm/vmstate.py: for configuring VMSA registers
* igvm/igvmbase.py: for generating an IGVM image
* igvm/igvmbzimage.py: for generating an IGVM image from a bzImage
* igvm/igvmelf.py: for generating an IGVM image from an arbitrary ELF
* igvm/acpi.py: for convert ACPI table to memory snapshot

## ACPI data

* igvm/acpi/acpi_test: a human-readable ACPI table in DSL format
* igvm/acpi/acpi.zip: a memory snapshot for an ACPI table without TPM

## Supported Images

* SNP enlightened: https://github.com/wdcui/linux (public), https://github.com/MSRSSP/snplinux
* SNP vmpl0 as security monitor: https://github.com/MSRSSP/snp-sm
* [ongoing] verified SNP monitor: https://github.com/MSRSSP/verus-snp-sm


## Tests
```
pytest-3 test
```

## Coverage
```
coverage run --source igvm -m pytest
coverage report -m
```
