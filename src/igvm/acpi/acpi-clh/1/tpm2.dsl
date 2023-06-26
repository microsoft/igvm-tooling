/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190509 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembly of scripts/igvm/acpi-test-new/tpm2.aml, Mon Apr 18 14:13:43 2022
 *
 * ACPI Data Table [TPM2]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000   4]                    Signature : "TPM2"    [Trusted Platform Module hardware interface table]
[004h 0004   4]                 Table Length : 0000004C
[008h 0008   1]                     Revision : 04
[009h 0009   1]                     Checksum : 57
[00Ah 0010   6]                       Oem ID : "BOCHS "
[010h 0016   8]                 Oem Table ID : "BXPCTPM2"
[018h 0024   4]                 Oem Revision : 00000001
[01Ch 0028   4]              Asl Compiler ID : "INTL"
[020h 0032   4]        Asl Compiler Revision : 20190509

[024h 0036   2]               Platform Class : 0000
[026h 0038   2]                     Reserved : 0000
[028h 0040   8]              Control Address : 00000000FED40040
[030h 0048   4]                 Start Method : 07 [Command Response Buffer]

[034h 0052  12]            Method Parameters : 00 00 00 00 00 00 00 00 00 00 00 00
[040h 0064   4]           Minimum Log Length : 00010000
[044h 0068   8]                  Log Address : 00000000BFFF0000

Raw Table Data: Length 76 (0x4C)

    0000: 54 50 4D 32 4C 00 00 00 04 57 42 4F 43 48 53 20  // TPM2L....WBOCHS 
    0010: 42 58 50 43 54 50 4D 32 01 00 00 00 49 4E 54 4C  // BXPCTPM2....INTL
    0020: 09 05 19 20 00 00 00 00 40 00 D4 FE 00 00 00 00  // ... ....@.......
    0030: 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  // ................
    0040: 00 00 01 00 00 00 FF BF 00 00 00 00              // ............
