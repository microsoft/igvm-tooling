/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190509 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembly of mcfg.dat, Mon Aug 28 10:09:31 2023
 *
 * ACPI Data Table [MCFG]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000   4]                    Signature : "MCFG"    [Memory Mapped Configuration table]
[004h 0004   4]                 Table Length : 000000CC
[008h 0008   1]                     Revision : 01
[009h 0009   1]                     Checksum : 23
[00Ah 0010   6]                       Oem ID : "CLOUDH"
[010h 0016   8]                 Oem Table ID : "CHMCFG  "
[018h 0024   4]                 Oem Revision : 00000001
[01Ch 0028   4]              Asl Compiler ID : "RVAT"
[020h 0032   4]        Asl Compiler Revision : 01000000

[024h 0036   8]                     Reserved : 0000000000000000

[02Ch 0044   8]                 Base Address : 00000000E8000000
[034h 0052   2]         Segment Group Number : 0000
[036h 0054   1]             Start Bus Number : 00
[037h 0055   1]               End Bus Number : 00
[038h 0056   4]                     Reserved : 00000000

[03Ch 0060   8]                 Base Address : 00000000E8100000
[044h 0068   2]         Segment Group Number : 0001
[046h 0070   1]             Start Bus Number : 00
[047h 0071   1]               End Bus Number : 00
[048h 0072   4]                     Reserved : 00000000

[04Ch 0076   8]                 Base Address : 00000000E8200000
[054h 0084   2]         Segment Group Number : 0002
[056h 0086   1]             Start Bus Number : 00
[057h 0087   1]               End Bus Number : 00
[058h 0088   4]                     Reserved : 00000000

[05Ch 0092   8]                 Base Address : 00000000E8300000
[064h 0100   2]         Segment Group Number : 0003
[066h 0102   1]             Start Bus Number : 00
[067h 0103   1]               End Bus Number : 00
[068h 0104   4]                     Reserved : 00000000

[06Ch 0108   8]                 Base Address : 00000000E8400000
[074h 0116   2]         Segment Group Number : 0004
[076h 0118   1]             Start Bus Number : 00
[077h 0119   1]               End Bus Number : 00
[078h 0120   4]                     Reserved : 00000000

[07Ch 0124   8]                 Base Address : 00000000E8500000
[084h 0132   2]         Segment Group Number : 0005
[086h 0134   1]             Start Bus Number : 00
[087h 0135   1]               End Bus Number : 00
[088h 0136   4]                     Reserved : 00000000

[08Ch 0140   8]                 Base Address : 00000000E8600000
[094h 0148   2]         Segment Group Number : 0006
[096h 0150   1]             Start Bus Number : 00
[097h 0151   1]               End Bus Number : 00
[098h 0152   4]                     Reserved : 00000000

[09Ch 0156   8]                 Base Address : 00000000E8700000
[0A4h 0164   2]         Segment Group Number : 0007
[0A6h 0166   1]             Start Bus Number : 00
[0A7h 0167   1]               End Bus Number : 00
[0A8h 0168   4]                     Reserved : 00000000

[0ACh 0172   8]                 Base Address : 00000000E8800000
[0B4h 0180   2]         Segment Group Number : 0008
[0B6h 0182   1]             Start Bus Number : 00
[0B7h 0183   1]               End Bus Number : 00
[0B8h 0184   4]                     Reserved : 00000000

[0BCh 0188   8]                 Base Address : 00000000E8900000
[0C4h 0196   2]         Segment Group Number : 0009
[0C6h 0198   1]             Start Bus Number : 00
[0C7h 0199   1]               End Bus Number : 00
[0C8h 0200   4]                     Reserved : 00000000

Raw Table Data: Length 204 (0xCC)

    0000: 4D 43 46 47 CC 00 00 00 01 23 43 4C 4F 55 44 48  // MCFG.....#CLOUDH
    0010: 43 48 4D 43 46 47 20 20 01 00 00 00 52 56 41 54  // CHMCFG  ....RVAT
    0020: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 E8  // ................
    0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 10 E8  // ................
    0040: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 20 E8  // .............. .
    0050: 00 00 00 00 02 00 00 00 00 00 00 00 00 00 30 E8  // ..............0.
    0060: 00 00 00 00 03 00 00 00 00 00 00 00 00 00 40 E8  // ..............@.
    0070: 00 00 00 00 04 00 00 00 00 00 00 00 00 00 50 E8  // ..............P.
    0080: 00 00 00 00 05 00 00 00 00 00 00 00 00 00 60 E8  // ..............`.
    0090: 00 00 00 00 06 00 00 00 00 00 00 00 00 00 70 E8  // ..............p.
    00A0: 00 00 00 00 07 00 00 00 00 00 00 00 00 00 80 E8  // ................
    00B0: 00 00 00 00 08 00 00 00 00 00 00 00 00 00 90 E8  // ................
    00C0: 00 00 00 00 09 00 00 00 00 00 00 00              // ............
