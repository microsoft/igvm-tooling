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

## Date

* igvm/acpi/acpi_test: a human-readable ACPI table in DSL format
* igvm/acpi/acpi.zip: a memory snapshot for an ACPI table without TPM

## Tests
```
pytest-3 test
```

## Coverage
```
coverage run --source igvm -m pytest
coverage report -m
```