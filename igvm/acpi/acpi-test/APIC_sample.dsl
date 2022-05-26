/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190509 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembly of acpi_table/test/APIC_sample.dat, Tue Feb  1 13:42:43 2022
 *
 * ACPI Data Table [APIC]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000   4]                    Signature : "APIC"    [Multiple APIC Description Table (MADT)]
[004h 0004   4]                 Table Length : 00000050
[008h 0008   1]                     Revision : 04
[009h 0009   1]                     Checksum : 23
[00Ah 0010   6]                       Oem ID : "VRTUAL"
[010h 0016   8]                 Oem Table ID : "MICROSFT"
[018h 0024   4]                 Oem Revision : 00000001
[01Ch 0028   4]              Asl Compiler ID : "MSFT"
[020h 0032   4]        Asl Compiler Revision : 00000001

[024h 0036   4]           Local Apic Address : FEE00000
[028h 0040   4]        Flags (decoded below) : 00000000
                         PC-AT Compatibility : 0

[02Ch 0044   1]                Subtable Type : 01 [I/O APIC]
[02Dh 0045   1]                       Length : 0C
[02Eh 0046   1]                  I/O Apic ID : 01
[02Fh 0047   1]                     Reserved : 00
[030h 0048   4]                      Address : FEC00000
[034h 0052   4]                    Interrupt : 00000000

[038h 0056   1]                Subtable Type : 02 [Interrupt Source Override]
[039h 0057   1]                       Length : 0A
[03Ah 0058   1]                          Bus : 00
[03Bh 0059   1]                       Source : 09
[03Ch 0060   4]                    Interrupt : 00000009
[040h 0064   2]        Flags (decoded below) : 000D
                                    Polarity : 1
                                Trigger Mode : 3

[042h 0066   1]                Subtable Type : 04 [Local APIC NMI]
[043h 0067   1]                       Length : 06
[044h 0068   1]                 Processor ID : 01
[045h 0069   2]        Flags (decoded below) : 0000
                                    Polarity : 0
                                Trigger Mode : 0
[047h 0071   1]         Interrupt Input LINT : 01

[048h 0072   1]                Subtable Type : 00 [Processor Local APIC]
[049h 0073   1]                       Length : 08
[04Ah 0074   1]                 Processor ID : 01
[04Bh 0075   1]                Local Apic ID : 00
[04Ch 0076   4]        Flags (decoded below) : 00000001
                           Processor Enabled : 1
                      Runtime Online Capable : 0

Raw Table Data: Length 80 (0x50)

    0000: 41 50 49 43 50 00 00 00 04 23 56 52 54 55 41 4C  // APICP....#VRTUAL
    0010: 4D 49 43 52 4F 53 46 54 01 00 00 00 4D 53 46 54  // MICROSFT....MSFT
    0020: 01 00 00 00 00 00 E0 FE 00 00 00 00 01 0C 01 00  // ................
    0030: 00 00 C0 FE 00 00 00 00 02 0A 00 09 09 00 00 00  // ................
    0040: 0D 00 04 06 01 00 00 01 00 08 01 00 01 00 00 00  // ................
