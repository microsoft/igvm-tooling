# IGVM Image Generator

## Install
```
cd src
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
* src/igvm/structure/linuxboot.py: data structures for linux booting
* src/igvm/structure/igvmfileformat.py: data structures for IGVM format, extracted from windows os repo

### Real Python code:

* src/igvm/vmstate.py: for configuring VMSA registers
* src/igvm/igvmbase.py: for generating an IGVM image
* src/igvm/igvmbzimage.py: for generating an IGVM image from a bzImage
* src/igvm/igvmelf.py: for generating an IGVM image from an arbitrary ELF
* src/igvm/acpi.py: for convert ACPI table to memory snapshot

## ACPI data

* src/igvm/acpi/acpi_test: a human-readable ACPI table in DSL format
* src/igvm/acpi/acpi-clh: a human-readable ACPI table in DSL format for CloudHypervisor guests
* src/igvm/acpi/acpi.zip: a memory snapshot for an ACPI table without TPM

## Supported Images

* SNP enlightened: https://github.com/wdcui/linux (public), https://github.com/MSRSSP/snplinux
* SNP vmpl0 as security monitor: https://github.com/MSRSSP/snp-sm
* [ongoing] verified SNP monitor: https://github.com/MSRSSP/verus-snp-sm

## Cloud Hypervisor support
We may use the same tool to create IGVM files that [Cloud Hypervisor](https://www.cloudhypervisor.org/) VMM can use to load a confidential guest.
The default set of ACPI tables do not function when using this programme to generate IGVM files for Cloud Hypervisor, thus you must pick one of
the folders under 'igvm/acpi/acpi-clh'. There are several folders under 'igvm/acpi/acpi-clh', and the name of the folder represents the number
of CPUs you want the guest to boot with. Here is a sample command that you could use to generate an IGVM file for a guest with 2 vcpus:

```
$(IGVMGEN) -o $(OUTPUT) \
		-kernel $(LINUX)/arch/x86/boot/bzImage \
		-append "$(CMDLINE)" \
		-boot_mode x64 \
		-vtl 0 \
		-inform bzImage \
		-svme 1 \
		-encrypted_page 1 \
		-pvalidate_opt 0 \
		-acpi_dir igvm/acpi/acpi-clh/2 \
```


## Tests
```
cd src
pytest-3 test
```

## Coverage
```
cd src
coverage run --source igvm -m pytest
coverage report -m
```

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
