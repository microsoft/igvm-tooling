/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20190509 (64-bit version)
 * Copyright (c) 2000 - 2019 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of dsdt.dat, Mon Aug 28 10:09:31 2023
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x000080CF (32975)
 *     Revision         0x06
 *     Checksum         0xDB
 *     OEM ID           "CLOUDH"
 *     OEM Table ID     "CHDSDT  "
 *     OEM Revision     0x00000001 (1)
 *     Compiler ID      "RVAT"
 *     Compiler Version 0x01000000 (16777216)
 */
DefinitionBlock ("", "DSDT", 6, "CLOUDH", "CHDSDT  ", 0x00000001)
{
    Device (_SB.PHPR)
    {
        Name (_HID, EisaId ("PNP0A06") /* Generic Container Device */)  // _HID: Hardware ID
        Name (_STA, 0x0B)  // _STA: Status
        Name (_UID, "PCI Hotplug Controller")  // _UID: Unique ID
        Mutex (BLCK, 0x00)
        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x000007FFFFFEF000, // Range Minimum
                0x000007FFFFFEF00F, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000000000010, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        OperationRegion (PCST, SystemMemory, 0x000007FFFFFEF000, 0x10)
        Field (PCST, DWordAcc, NoLock, WriteAsZeros)
        {
            PCIU,   32, 
            PCID,   32, 
            B0EJ,   32, 
            PSEG,   32
        }

        Method (PCEJ, 2, Serialized)
        {
            Acquire (BLCK, 0xFFFF)
            PSEG = Arg1
            B0EJ = (One << Arg0)
            Release (BLCK)
            Return (Zero)
        }

        Method (PSCN, 0, Serialized)
        {
            \_SB.PC00.PCNT ()
            \_SB.PC01.PCNT ()
            \_SB.PC02.PCNT ()
            \_SB.PC03.PCNT ()
            \_SB.PC04.PCNT ()
            \_SB.PC05.PCNT ()
            \_SB.PC06.PCNT ()
            \_SB.PC07.PCNT ()
            \_SB.PC08.PCNT ()
            \_SB.PC09.PCNT ()
        }
    }

    Device (_SB.PC00)
    {
        Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
        Name (_ADR, Zero)  // _ADR: Address
        Name (_SEG, Zero)  // _SEG: PCI Segment
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CCA, One)  // _CCA: Cache Coherency Attribute
        Name (SUPP, Zero)
        Method (_PXM, 0, NotSerialized)  // _PXM: Device Proximity
        {
            Return (Zero)
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x21                                             // !
                    })
                }

                If ((Arg2 == 0x05))
                {
                    Return (Zero)
                }
            }

            Return (Buffer (One)
            {
                 0x00                                             // .
            })
        }

        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x0000,             // Range Maximum
                0x0000,             // Translation Offset
                0x0001,             // Length
                ,, )
            IO (Decode16,
                0x0CF8,             // Range Minimum
                0x0CF8,             // Range Maximum
                0x01,               // Alignment
                0x08,               // Length
                )
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x00000000,         // Granularity
                0xC0000000,         // Range Minimum
                0xE7FFFFFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x28000000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x0000010000000000, // Range Minimum
                0x00000100FFFFFFFF, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000100000000, // Length
                ,, , AddressRangeMemory, TypeStatic)
            WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x0CF7,             // Range Maximum
                0x0000,             // Translation Offset
                0x0CF8,             // Length
                ,, , TypeStatic, DenseTranslation)
            WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                0x0000,             // Granularity
                0x0D00,             // Range Minimum
                0xFFFF,             // Range Maximum
                0x0000,             // Translation Offset
                0xF300,             // Length
                ,, , TypeStatic, DenseTranslation)
        })
        Device (S000)
        {
            Name (_SUN, Zero)  // _SUN: Slot User Number
            Name (_ADR, Zero)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S001)
        {
            Name (_SUN, One)  // _SUN: Slot User Number
            Name (_ADR, 0x00010000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S002)
        {
            Name (_SUN, 0x02)  // _SUN: Slot User Number
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S003)
        {
            Name (_SUN, 0x03)  // _SUN: Slot User Number
            Name (_ADR, 0x00030000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S004)
        {
            Name (_SUN, 0x04)  // _SUN: Slot User Number
            Name (_ADR, 0x00040000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S005)
        {
            Name (_SUN, 0x05)  // _SUN: Slot User Number
            Name (_ADR, 0x00050000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S006)
        {
            Name (_SUN, 0x06)  // _SUN: Slot User Number
            Name (_ADR, 0x00060000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S007)
        {
            Name (_SUN, 0x07)  // _SUN: Slot User Number
            Name (_ADR, 0x00070000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S008)
        {
            Name (_SUN, 0x08)  // _SUN: Slot User Number
            Name (_ADR, 0x00080000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S009)
        {
            Name (_SUN, 0x09)  // _SUN: Slot User Number
            Name (_ADR, 0x00090000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S010)
        {
            Name (_SUN, 0x0A)  // _SUN: Slot User Number
            Name (_ADR, 0x000A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S011)
        {
            Name (_SUN, 0x0B)  // _SUN: Slot User Number
            Name (_ADR, 0x000B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S012)
        {
            Name (_SUN, 0x0C)  // _SUN: Slot User Number
            Name (_ADR, 0x000C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S013)
        {
            Name (_SUN, 0x0D)  // _SUN: Slot User Number
            Name (_ADR, 0x000D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S014)
        {
            Name (_SUN, 0x0E)  // _SUN: Slot User Number
            Name (_ADR, 0x000E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S015)
        {
            Name (_SUN, 0x0F)  // _SUN: Slot User Number
            Name (_ADR, 0x000F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S016)
        {
            Name (_SUN, 0x10)  // _SUN: Slot User Number
            Name (_ADR, 0x00100000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S017)
        {
            Name (_SUN, 0x11)  // _SUN: Slot User Number
            Name (_ADR, 0x00110000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S018)
        {
            Name (_SUN, 0x12)  // _SUN: Slot User Number
            Name (_ADR, 0x00120000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S019)
        {
            Name (_SUN, 0x13)  // _SUN: Slot User Number
            Name (_ADR, 0x00130000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S020)
        {
            Name (_SUN, 0x14)  // _SUN: Slot User Number
            Name (_ADR, 0x00140000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S021)
        {
            Name (_SUN, 0x15)  // _SUN: Slot User Number
            Name (_ADR, 0x00150000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S022)
        {
            Name (_SUN, 0x16)  // _SUN: Slot User Number
            Name (_ADR, 0x00160000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S023)
        {
            Name (_SUN, 0x17)  // _SUN: Slot User Number
            Name (_ADR, 0x00170000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S024)
        {
            Name (_SUN, 0x18)  // _SUN: Slot User Number
            Name (_ADR, 0x00180000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S025)
        {
            Name (_SUN, 0x19)  // _SUN: Slot User Number
            Name (_ADR, 0x00190000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S026)
        {
            Name (_SUN, 0x1A)  // _SUN: Slot User Number
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S027)
        {
            Name (_SUN, 0x1B)  // _SUN: Slot User Number
            Name (_ADR, 0x001B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S028)
        {
            Name (_SUN, 0x1C)  // _SUN: Slot User Number
            Name (_ADR, 0x001C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S029)
        {
            Name (_SUN, 0x1D)  // _SUN: Slot User Number
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S030)
        {
            Name (_SUN, 0x1E)  // _SUN: Slot User Number
            Name (_ADR, 0x001E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S031)
        {
            Name (_SUN, 0x1F)  // _SUN: Slot User Number
            Name (_ADR, 0x001F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Method (DVNT, 2, Serialized)
        {
            Local0 = (Arg0 & One)
            If ((Local0 == One))
            {
                Notify (S000, Arg1)
            }

            Local0 = (Arg0 & 0x02)
            If ((Local0 == 0x02))
            {
                Notify (S001, Arg1)
            }

            Local0 = (Arg0 & 0x04)
            If ((Local0 == 0x04))
            {
                Notify (S002, Arg1)
            }

            Local0 = (Arg0 & 0x08)
            If ((Local0 == 0x08))
            {
                Notify (S003, Arg1)
            }

            Local0 = (Arg0 & 0x10)
            If ((Local0 == 0x10))
            {
                Notify (S004, Arg1)
            }

            Local0 = (Arg0 & 0x20)
            If ((Local0 == 0x20))
            {
                Notify (S005, Arg1)
            }

            Local0 = (Arg0 & 0x40)
            If ((Local0 == 0x40))
            {
                Notify (S006, Arg1)
            }

            Local0 = (Arg0 & 0x80)
            If ((Local0 == 0x80))
            {
                Notify (S007, Arg1)
            }

            Local0 = (Arg0 & 0x0100)
            If ((Local0 == 0x0100))
            {
                Notify (S008, Arg1)
            }

            Local0 = (Arg0 & 0x0200)
            If ((Local0 == 0x0200))
            {
                Notify (S009, Arg1)
            }

            Local0 = (Arg0 & 0x0400)
            If ((Local0 == 0x0400))
            {
                Notify (S010, Arg1)
            }

            Local0 = (Arg0 & 0x0800)
            If ((Local0 == 0x0800))
            {
                Notify (S011, Arg1)
            }

            Local0 = (Arg0 & 0x1000)
            If ((Local0 == 0x1000))
            {
                Notify (S012, Arg1)
            }

            Local0 = (Arg0 & 0x2000)
            If ((Local0 == 0x2000))
            {
                Notify (S013, Arg1)
            }

            Local0 = (Arg0 & 0x4000)
            If ((Local0 == 0x4000))
            {
                Notify (S014, Arg1)
            }

            Local0 = (Arg0 & 0x8000)
            If ((Local0 == 0x8000))
            {
                Notify (S015, Arg1)
            }

            Local0 = (Arg0 & 0x00010000)
            If ((Local0 == 0x00010000))
            {
                Notify (S016, Arg1)
            }

            Local0 = (Arg0 & 0x00020000)
            If ((Local0 == 0x00020000))
            {
                Notify (S017, Arg1)
            }

            Local0 = (Arg0 & 0x00040000)
            If ((Local0 == 0x00040000))
            {
                Notify (S018, Arg1)
            }

            Local0 = (Arg0 & 0x00080000)
            If ((Local0 == 0x00080000))
            {
                Notify (S019, Arg1)
            }

            Local0 = (Arg0 & 0x00100000)
            If ((Local0 == 0x00100000))
            {
                Notify (S020, Arg1)
            }

            Local0 = (Arg0 & 0x00200000)
            If ((Local0 == 0x00200000))
            {
                Notify (S021, Arg1)
            }

            Local0 = (Arg0 & 0x00400000)
            If ((Local0 == 0x00400000))
            {
                Notify (S022, Arg1)
            }

            Local0 = (Arg0 & 0x00800000)
            If ((Local0 == 0x00800000))
            {
                Notify (S023, Arg1)
            }

            Local0 = (Arg0 & 0x01000000)
            If ((Local0 == 0x01000000))
            {
                Notify (S024, Arg1)
            }

            Local0 = (Arg0 & 0x02000000)
            If ((Local0 == 0x02000000))
            {
                Notify (S025, Arg1)
            }

            Local0 = (Arg0 & 0x04000000)
            If ((Local0 == 0x04000000))
            {
                Notify (S026, Arg1)
            }

            Local0 = (Arg0 & 0x08000000)
            If ((Local0 == 0x08000000))
            {
                Notify (S027, Arg1)
            }

            Local0 = (Arg0 & 0x10000000)
            If ((Local0 == 0x10000000))
            {
                Notify (S028, Arg1)
            }

            Local0 = (Arg0 & 0x20000000)
            If ((Local0 == 0x20000000))
            {
                Notify (S029, Arg1)
            }

            Local0 = (Arg0 & 0x40000000)
            If ((Local0 == 0x40000000))
            {
                Notify (S030, Arg1)
            }

            Local0 = (Arg0 & 0x80000000)
            If ((Local0 == 0x80000000))
            {
                Notify (S031, Arg1)
            }
        }

        Method (PCNT, 0, Serialized)
        {
            Acquire (\_SB.PHPR.BLCK, 0xFFFF)
            \_SB.PHPR.PSEG = _SEG /* \_SB_.PC00._SEG */
            DVNT (\_SB.PHPR.PCIU, One)
            DVNT (\_SB.PHPR.PCID, 0x03)
            Release (\_SB.PHPR.BLCK)
        }

        Name (_PRT, Package (0x20)  // _PRT: PCI Routing Table
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0007FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0008FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0009FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x000AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x000BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x000CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x000DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x000EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x000FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0010FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0012FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0013FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0014FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0015FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0017FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0018FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }
        })
    }

    Device (_SB.PC01)
    {
        Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
        Name (_ADR, Zero)  // _ADR: Address
        Name (_SEG, One)  // _SEG: PCI Segment
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CCA, One)  // _CCA: Cache Coherency Attribute
        Name (SUPP, Zero)
        Method (_PXM, 0, NotSerialized)  // _PXM: Device Proximity
        {
            Return (Zero)
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x21                                             // !
                    })
                }

                If ((Arg2 == 0x05))
                {
                    Return (Zero)
                }
            }

            Return (Buffer (One)
            {
                 0x00                                             // .
            })
        }

        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x0000,             // Range Maximum
                0x0000,             // Translation Offset
                0x0001,             // Length
                ,, )
            Memory32Fixed (ReadWrite,
                0xE8100000,         // Address Base
                0x00100000,         // Address Length
                )
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x0000010100000000, // Range Minimum
                0x00000101FFFFFFFF, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000100000000, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        Device (S000)
        {
            Name (_SUN, Zero)  // _SUN: Slot User Number
            Name (_ADR, Zero)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S001)
        {
            Name (_SUN, One)  // _SUN: Slot User Number
            Name (_ADR, 0x00010000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S002)
        {
            Name (_SUN, 0x02)  // _SUN: Slot User Number
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S003)
        {
            Name (_SUN, 0x03)  // _SUN: Slot User Number
            Name (_ADR, 0x00030000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S004)
        {
            Name (_SUN, 0x04)  // _SUN: Slot User Number
            Name (_ADR, 0x00040000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S005)
        {
            Name (_SUN, 0x05)  // _SUN: Slot User Number
            Name (_ADR, 0x00050000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S006)
        {
            Name (_SUN, 0x06)  // _SUN: Slot User Number
            Name (_ADR, 0x00060000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S007)
        {
            Name (_SUN, 0x07)  // _SUN: Slot User Number
            Name (_ADR, 0x00070000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S008)
        {
            Name (_SUN, 0x08)  // _SUN: Slot User Number
            Name (_ADR, 0x00080000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S009)
        {
            Name (_SUN, 0x09)  // _SUN: Slot User Number
            Name (_ADR, 0x00090000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S010)
        {
            Name (_SUN, 0x0A)  // _SUN: Slot User Number
            Name (_ADR, 0x000A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S011)
        {
            Name (_SUN, 0x0B)  // _SUN: Slot User Number
            Name (_ADR, 0x000B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S012)
        {
            Name (_SUN, 0x0C)  // _SUN: Slot User Number
            Name (_ADR, 0x000C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S013)
        {
            Name (_SUN, 0x0D)  // _SUN: Slot User Number
            Name (_ADR, 0x000D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S014)
        {
            Name (_SUN, 0x0E)  // _SUN: Slot User Number
            Name (_ADR, 0x000E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S015)
        {
            Name (_SUN, 0x0F)  // _SUN: Slot User Number
            Name (_ADR, 0x000F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S016)
        {
            Name (_SUN, 0x10)  // _SUN: Slot User Number
            Name (_ADR, 0x00100000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S017)
        {
            Name (_SUN, 0x11)  // _SUN: Slot User Number
            Name (_ADR, 0x00110000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S018)
        {
            Name (_SUN, 0x12)  // _SUN: Slot User Number
            Name (_ADR, 0x00120000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S019)
        {
            Name (_SUN, 0x13)  // _SUN: Slot User Number
            Name (_ADR, 0x00130000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S020)
        {
            Name (_SUN, 0x14)  // _SUN: Slot User Number
            Name (_ADR, 0x00140000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S021)
        {
            Name (_SUN, 0x15)  // _SUN: Slot User Number
            Name (_ADR, 0x00150000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S022)
        {
            Name (_SUN, 0x16)  // _SUN: Slot User Number
            Name (_ADR, 0x00160000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S023)
        {
            Name (_SUN, 0x17)  // _SUN: Slot User Number
            Name (_ADR, 0x00170000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S024)
        {
            Name (_SUN, 0x18)  // _SUN: Slot User Number
            Name (_ADR, 0x00180000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S025)
        {
            Name (_SUN, 0x19)  // _SUN: Slot User Number
            Name (_ADR, 0x00190000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S026)
        {
            Name (_SUN, 0x1A)  // _SUN: Slot User Number
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S027)
        {
            Name (_SUN, 0x1B)  // _SUN: Slot User Number
            Name (_ADR, 0x001B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S028)
        {
            Name (_SUN, 0x1C)  // _SUN: Slot User Number
            Name (_ADR, 0x001C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S029)
        {
            Name (_SUN, 0x1D)  // _SUN: Slot User Number
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S030)
        {
            Name (_SUN, 0x1E)  // _SUN: Slot User Number
            Name (_ADR, 0x001E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S031)
        {
            Name (_SUN, 0x1F)  // _SUN: Slot User Number
            Name (_ADR, 0x001F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Method (DVNT, 2, Serialized)
        {
            Local0 = (Arg0 & One)
            If ((Local0 == One))
            {
                Notify (S000, Arg1)
            }

            Local0 = (Arg0 & 0x02)
            If ((Local0 == 0x02))
            {
                Notify (S001, Arg1)
            }

            Local0 = (Arg0 & 0x04)
            If ((Local0 == 0x04))
            {
                Notify (S002, Arg1)
            }

            Local0 = (Arg0 & 0x08)
            If ((Local0 == 0x08))
            {
                Notify (S003, Arg1)
            }

            Local0 = (Arg0 & 0x10)
            If ((Local0 == 0x10))
            {
                Notify (S004, Arg1)
            }

            Local0 = (Arg0 & 0x20)
            If ((Local0 == 0x20))
            {
                Notify (S005, Arg1)
            }

            Local0 = (Arg0 & 0x40)
            If ((Local0 == 0x40))
            {
                Notify (S006, Arg1)
            }

            Local0 = (Arg0 & 0x80)
            If ((Local0 == 0x80))
            {
                Notify (S007, Arg1)
            }

            Local0 = (Arg0 & 0x0100)
            If ((Local0 == 0x0100))
            {
                Notify (S008, Arg1)
            }

            Local0 = (Arg0 & 0x0200)
            If ((Local0 == 0x0200))
            {
                Notify (S009, Arg1)
            }

            Local0 = (Arg0 & 0x0400)
            If ((Local0 == 0x0400))
            {
                Notify (S010, Arg1)
            }

            Local0 = (Arg0 & 0x0800)
            If ((Local0 == 0x0800))
            {
                Notify (S011, Arg1)
            }

            Local0 = (Arg0 & 0x1000)
            If ((Local0 == 0x1000))
            {
                Notify (S012, Arg1)
            }

            Local0 = (Arg0 & 0x2000)
            If ((Local0 == 0x2000))
            {
                Notify (S013, Arg1)
            }

            Local0 = (Arg0 & 0x4000)
            If ((Local0 == 0x4000))
            {
                Notify (S014, Arg1)
            }

            Local0 = (Arg0 & 0x8000)
            If ((Local0 == 0x8000))
            {
                Notify (S015, Arg1)
            }

            Local0 = (Arg0 & 0x00010000)
            If ((Local0 == 0x00010000))
            {
                Notify (S016, Arg1)
            }

            Local0 = (Arg0 & 0x00020000)
            If ((Local0 == 0x00020000))
            {
                Notify (S017, Arg1)
            }

            Local0 = (Arg0 & 0x00040000)
            If ((Local0 == 0x00040000))
            {
                Notify (S018, Arg1)
            }

            Local0 = (Arg0 & 0x00080000)
            If ((Local0 == 0x00080000))
            {
                Notify (S019, Arg1)
            }

            Local0 = (Arg0 & 0x00100000)
            If ((Local0 == 0x00100000))
            {
                Notify (S020, Arg1)
            }

            Local0 = (Arg0 & 0x00200000)
            If ((Local0 == 0x00200000))
            {
                Notify (S021, Arg1)
            }

            Local0 = (Arg0 & 0x00400000)
            If ((Local0 == 0x00400000))
            {
                Notify (S022, Arg1)
            }

            Local0 = (Arg0 & 0x00800000)
            If ((Local0 == 0x00800000))
            {
                Notify (S023, Arg1)
            }

            Local0 = (Arg0 & 0x01000000)
            If ((Local0 == 0x01000000))
            {
                Notify (S024, Arg1)
            }

            Local0 = (Arg0 & 0x02000000)
            If ((Local0 == 0x02000000))
            {
                Notify (S025, Arg1)
            }

            Local0 = (Arg0 & 0x04000000)
            If ((Local0 == 0x04000000))
            {
                Notify (S026, Arg1)
            }

            Local0 = (Arg0 & 0x08000000)
            If ((Local0 == 0x08000000))
            {
                Notify (S027, Arg1)
            }

            Local0 = (Arg0 & 0x10000000)
            If ((Local0 == 0x10000000))
            {
                Notify (S028, Arg1)
            }

            Local0 = (Arg0 & 0x20000000)
            If ((Local0 == 0x20000000))
            {
                Notify (S029, Arg1)
            }

            Local0 = (Arg0 & 0x40000000)
            If ((Local0 == 0x40000000))
            {
                Notify (S030, Arg1)
            }

            Local0 = (Arg0 & 0x80000000)
            If ((Local0 == 0x80000000))
            {
                Notify (S031, Arg1)
            }
        }

        Method (PCNT, 0, Serialized)
        {
            Acquire (\_SB.PHPR.BLCK, 0xFFFF)
            \_SB.PHPR.PSEG = _SEG /* \_SB_.PC01._SEG */
            DVNT (\_SB.PHPR.PCIU, One)
            DVNT (\_SB.PHPR.PCID, 0x03)
            Release (\_SB.PHPR.BLCK)
        }

        Name (_PRT, Package (0x20)  // _PRT: PCI Routing Table
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0007FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0008FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0009FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x000AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x000BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x000CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x000DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x000EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x000FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0010FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0012FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0013FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0014FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0015FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0017FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0018FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }
        })
    }

    Device (_SB.PC02)
    {
        Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
        Name (_ADR, Zero)  // _ADR: Address
        Name (_SEG, 0x02)  // _SEG: PCI Segment
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CCA, One)  // _CCA: Cache Coherency Attribute
        Name (SUPP, Zero)
        Method (_PXM, 0, NotSerialized)  // _PXM: Device Proximity
        {
            Return (Zero)
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x21                                             // !
                    })
                }

                If ((Arg2 == 0x05))
                {
                    Return (Zero)
                }
            }

            Return (Buffer (One)
            {
                 0x00                                             // .
            })
        }

        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x0000,             // Range Maximum
                0x0000,             // Translation Offset
                0x0001,             // Length
                ,, )
            Memory32Fixed (ReadWrite,
                0xE8200000,         // Address Base
                0x00100000,         // Address Length
                )
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x0000010200000000, // Range Minimum
                0x00000102FFFFFFFF, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000100000000, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        Device (S000)
        {
            Name (_SUN, Zero)  // _SUN: Slot User Number
            Name (_ADR, Zero)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S001)
        {
            Name (_SUN, One)  // _SUN: Slot User Number
            Name (_ADR, 0x00010000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S002)
        {
            Name (_SUN, 0x02)  // _SUN: Slot User Number
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S003)
        {
            Name (_SUN, 0x03)  // _SUN: Slot User Number
            Name (_ADR, 0x00030000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S004)
        {
            Name (_SUN, 0x04)  // _SUN: Slot User Number
            Name (_ADR, 0x00040000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S005)
        {
            Name (_SUN, 0x05)  // _SUN: Slot User Number
            Name (_ADR, 0x00050000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S006)
        {
            Name (_SUN, 0x06)  // _SUN: Slot User Number
            Name (_ADR, 0x00060000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S007)
        {
            Name (_SUN, 0x07)  // _SUN: Slot User Number
            Name (_ADR, 0x00070000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S008)
        {
            Name (_SUN, 0x08)  // _SUN: Slot User Number
            Name (_ADR, 0x00080000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S009)
        {
            Name (_SUN, 0x09)  // _SUN: Slot User Number
            Name (_ADR, 0x00090000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S010)
        {
            Name (_SUN, 0x0A)  // _SUN: Slot User Number
            Name (_ADR, 0x000A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S011)
        {
            Name (_SUN, 0x0B)  // _SUN: Slot User Number
            Name (_ADR, 0x000B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S012)
        {
            Name (_SUN, 0x0C)  // _SUN: Slot User Number
            Name (_ADR, 0x000C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S013)
        {
            Name (_SUN, 0x0D)  // _SUN: Slot User Number
            Name (_ADR, 0x000D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S014)
        {
            Name (_SUN, 0x0E)  // _SUN: Slot User Number
            Name (_ADR, 0x000E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S015)
        {
            Name (_SUN, 0x0F)  // _SUN: Slot User Number
            Name (_ADR, 0x000F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S016)
        {
            Name (_SUN, 0x10)  // _SUN: Slot User Number
            Name (_ADR, 0x00100000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S017)
        {
            Name (_SUN, 0x11)  // _SUN: Slot User Number
            Name (_ADR, 0x00110000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S018)
        {
            Name (_SUN, 0x12)  // _SUN: Slot User Number
            Name (_ADR, 0x00120000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S019)
        {
            Name (_SUN, 0x13)  // _SUN: Slot User Number
            Name (_ADR, 0x00130000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S020)
        {
            Name (_SUN, 0x14)  // _SUN: Slot User Number
            Name (_ADR, 0x00140000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S021)
        {
            Name (_SUN, 0x15)  // _SUN: Slot User Number
            Name (_ADR, 0x00150000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S022)
        {
            Name (_SUN, 0x16)  // _SUN: Slot User Number
            Name (_ADR, 0x00160000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S023)
        {
            Name (_SUN, 0x17)  // _SUN: Slot User Number
            Name (_ADR, 0x00170000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S024)
        {
            Name (_SUN, 0x18)  // _SUN: Slot User Number
            Name (_ADR, 0x00180000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S025)
        {
            Name (_SUN, 0x19)  // _SUN: Slot User Number
            Name (_ADR, 0x00190000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S026)
        {
            Name (_SUN, 0x1A)  // _SUN: Slot User Number
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S027)
        {
            Name (_SUN, 0x1B)  // _SUN: Slot User Number
            Name (_ADR, 0x001B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S028)
        {
            Name (_SUN, 0x1C)  // _SUN: Slot User Number
            Name (_ADR, 0x001C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S029)
        {
            Name (_SUN, 0x1D)  // _SUN: Slot User Number
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S030)
        {
            Name (_SUN, 0x1E)  // _SUN: Slot User Number
            Name (_ADR, 0x001E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S031)
        {
            Name (_SUN, 0x1F)  // _SUN: Slot User Number
            Name (_ADR, 0x001F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Method (DVNT, 2, Serialized)
        {
            Local0 = (Arg0 & One)
            If ((Local0 == One))
            {
                Notify (S000, Arg1)
            }

            Local0 = (Arg0 & 0x02)
            If ((Local0 == 0x02))
            {
                Notify (S001, Arg1)
            }

            Local0 = (Arg0 & 0x04)
            If ((Local0 == 0x04))
            {
                Notify (S002, Arg1)
            }

            Local0 = (Arg0 & 0x08)
            If ((Local0 == 0x08))
            {
                Notify (S003, Arg1)
            }

            Local0 = (Arg0 & 0x10)
            If ((Local0 == 0x10))
            {
                Notify (S004, Arg1)
            }

            Local0 = (Arg0 & 0x20)
            If ((Local0 == 0x20))
            {
                Notify (S005, Arg1)
            }

            Local0 = (Arg0 & 0x40)
            If ((Local0 == 0x40))
            {
                Notify (S006, Arg1)
            }

            Local0 = (Arg0 & 0x80)
            If ((Local0 == 0x80))
            {
                Notify (S007, Arg1)
            }

            Local0 = (Arg0 & 0x0100)
            If ((Local0 == 0x0100))
            {
                Notify (S008, Arg1)
            }

            Local0 = (Arg0 & 0x0200)
            If ((Local0 == 0x0200))
            {
                Notify (S009, Arg1)
            }

            Local0 = (Arg0 & 0x0400)
            If ((Local0 == 0x0400))
            {
                Notify (S010, Arg1)
            }

            Local0 = (Arg0 & 0x0800)
            If ((Local0 == 0x0800))
            {
                Notify (S011, Arg1)
            }

            Local0 = (Arg0 & 0x1000)
            If ((Local0 == 0x1000))
            {
                Notify (S012, Arg1)
            }

            Local0 = (Arg0 & 0x2000)
            If ((Local0 == 0x2000))
            {
                Notify (S013, Arg1)
            }

            Local0 = (Arg0 & 0x4000)
            If ((Local0 == 0x4000))
            {
                Notify (S014, Arg1)
            }

            Local0 = (Arg0 & 0x8000)
            If ((Local0 == 0x8000))
            {
                Notify (S015, Arg1)
            }

            Local0 = (Arg0 & 0x00010000)
            If ((Local0 == 0x00010000))
            {
                Notify (S016, Arg1)
            }

            Local0 = (Arg0 & 0x00020000)
            If ((Local0 == 0x00020000))
            {
                Notify (S017, Arg1)
            }

            Local0 = (Arg0 & 0x00040000)
            If ((Local0 == 0x00040000))
            {
                Notify (S018, Arg1)
            }

            Local0 = (Arg0 & 0x00080000)
            If ((Local0 == 0x00080000))
            {
                Notify (S019, Arg1)
            }

            Local0 = (Arg0 & 0x00100000)
            If ((Local0 == 0x00100000))
            {
                Notify (S020, Arg1)
            }

            Local0 = (Arg0 & 0x00200000)
            If ((Local0 == 0x00200000))
            {
                Notify (S021, Arg1)
            }

            Local0 = (Arg0 & 0x00400000)
            If ((Local0 == 0x00400000))
            {
                Notify (S022, Arg1)
            }

            Local0 = (Arg0 & 0x00800000)
            If ((Local0 == 0x00800000))
            {
                Notify (S023, Arg1)
            }

            Local0 = (Arg0 & 0x01000000)
            If ((Local0 == 0x01000000))
            {
                Notify (S024, Arg1)
            }

            Local0 = (Arg0 & 0x02000000)
            If ((Local0 == 0x02000000))
            {
                Notify (S025, Arg1)
            }

            Local0 = (Arg0 & 0x04000000)
            If ((Local0 == 0x04000000))
            {
                Notify (S026, Arg1)
            }

            Local0 = (Arg0 & 0x08000000)
            If ((Local0 == 0x08000000))
            {
                Notify (S027, Arg1)
            }

            Local0 = (Arg0 & 0x10000000)
            If ((Local0 == 0x10000000))
            {
                Notify (S028, Arg1)
            }

            Local0 = (Arg0 & 0x20000000)
            If ((Local0 == 0x20000000))
            {
                Notify (S029, Arg1)
            }

            Local0 = (Arg0 & 0x40000000)
            If ((Local0 == 0x40000000))
            {
                Notify (S030, Arg1)
            }

            Local0 = (Arg0 & 0x80000000)
            If ((Local0 == 0x80000000))
            {
                Notify (S031, Arg1)
            }
        }

        Method (PCNT, 0, Serialized)
        {
            Acquire (\_SB.PHPR.BLCK, 0xFFFF)
            \_SB.PHPR.PSEG = _SEG /* \_SB_.PC02._SEG */
            DVNT (\_SB.PHPR.PCIU, One)
            DVNT (\_SB.PHPR.PCID, 0x03)
            Release (\_SB.PHPR.BLCK)
        }

        Name (_PRT, Package (0x20)  // _PRT: PCI Routing Table
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0007FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0008FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0009FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x000AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x000BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x000CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x000DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x000EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x000FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0010FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0012FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0013FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0014FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0015FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0017FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0018FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }
        })
    }

    Device (_SB.PC03)
    {
        Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
        Name (_ADR, Zero)  // _ADR: Address
        Name (_SEG, 0x03)  // _SEG: PCI Segment
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CCA, One)  // _CCA: Cache Coherency Attribute
        Name (SUPP, Zero)
        Method (_PXM, 0, NotSerialized)  // _PXM: Device Proximity
        {
            Return (Zero)
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x21                                             // !
                    })
                }

                If ((Arg2 == 0x05))
                {
                    Return (Zero)
                }
            }

            Return (Buffer (One)
            {
                 0x00                                             // .
            })
        }

        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x0000,             // Range Maximum
                0x0000,             // Translation Offset
                0x0001,             // Length
                ,, )
            Memory32Fixed (ReadWrite,
                0xE8300000,         // Address Base
                0x00100000,         // Address Length
                )
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x0000010300000000, // Range Minimum
                0x00000103FFFFFFFF, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000100000000, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        Device (S000)
        {
            Name (_SUN, Zero)  // _SUN: Slot User Number
            Name (_ADR, Zero)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S001)
        {
            Name (_SUN, One)  // _SUN: Slot User Number
            Name (_ADR, 0x00010000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S002)
        {
            Name (_SUN, 0x02)  // _SUN: Slot User Number
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S003)
        {
            Name (_SUN, 0x03)  // _SUN: Slot User Number
            Name (_ADR, 0x00030000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S004)
        {
            Name (_SUN, 0x04)  // _SUN: Slot User Number
            Name (_ADR, 0x00040000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S005)
        {
            Name (_SUN, 0x05)  // _SUN: Slot User Number
            Name (_ADR, 0x00050000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S006)
        {
            Name (_SUN, 0x06)  // _SUN: Slot User Number
            Name (_ADR, 0x00060000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S007)
        {
            Name (_SUN, 0x07)  // _SUN: Slot User Number
            Name (_ADR, 0x00070000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S008)
        {
            Name (_SUN, 0x08)  // _SUN: Slot User Number
            Name (_ADR, 0x00080000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S009)
        {
            Name (_SUN, 0x09)  // _SUN: Slot User Number
            Name (_ADR, 0x00090000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S010)
        {
            Name (_SUN, 0x0A)  // _SUN: Slot User Number
            Name (_ADR, 0x000A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S011)
        {
            Name (_SUN, 0x0B)  // _SUN: Slot User Number
            Name (_ADR, 0x000B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S012)
        {
            Name (_SUN, 0x0C)  // _SUN: Slot User Number
            Name (_ADR, 0x000C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S013)
        {
            Name (_SUN, 0x0D)  // _SUN: Slot User Number
            Name (_ADR, 0x000D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S014)
        {
            Name (_SUN, 0x0E)  // _SUN: Slot User Number
            Name (_ADR, 0x000E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S015)
        {
            Name (_SUN, 0x0F)  // _SUN: Slot User Number
            Name (_ADR, 0x000F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S016)
        {
            Name (_SUN, 0x10)  // _SUN: Slot User Number
            Name (_ADR, 0x00100000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S017)
        {
            Name (_SUN, 0x11)  // _SUN: Slot User Number
            Name (_ADR, 0x00110000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S018)
        {
            Name (_SUN, 0x12)  // _SUN: Slot User Number
            Name (_ADR, 0x00120000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S019)
        {
            Name (_SUN, 0x13)  // _SUN: Slot User Number
            Name (_ADR, 0x00130000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S020)
        {
            Name (_SUN, 0x14)  // _SUN: Slot User Number
            Name (_ADR, 0x00140000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S021)
        {
            Name (_SUN, 0x15)  // _SUN: Slot User Number
            Name (_ADR, 0x00150000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S022)
        {
            Name (_SUN, 0x16)  // _SUN: Slot User Number
            Name (_ADR, 0x00160000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S023)
        {
            Name (_SUN, 0x17)  // _SUN: Slot User Number
            Name (_ADR, 0x00170000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S024)
        {
            Name (_SUN, 0x18)  // _SUN: Slot User Number
            Name (_ADR, 0x00180000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S025)
        {
            Name (_SUN, 0x19)  // _SUN: Slot User Number
            Name (_ADR, 0x00190000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S026)
        {
            Name (_SUN, 0x1A)  // _SUN: Slot User Number
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S027)
        {
            Name (_SUN, 0x1B)  // _SUN: Slot User Number
            Name (_ADR, 0x001B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S028)
        {
            Name (_SUN, 0x1C)  // _SUN: Slot User Number
            Name (_ADR, 0x001C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S029)
        {
            Name (_SUN, 0x1D)  // _SUN: Slot User Number
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S030)
        {
            Name (_SUN, 0x1E)  // _SUN: Slot User Number
            Name (_ADR, 0x001E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S031)
        {
            Name (_SUN, 0x1F)  // _SUN: Slot User Number
            Name (_ADR, 0x001F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Method (DVNT, 2, Serialized)
        {
            Local0 = (Arg0 & One)
            If ((Local0 == One))
            {
                Notify (S000, Arg1)
            }

            Local0 = (Arg0 & 0x02)
            If ((Local0 == 0x02))
            {
                Notify (S001, Arg1)
            }

            Local0 = (Arg0 & 0x04)
            If ((Local0 == 0x04))
            {
                Notify (S002, Arg1)
            }

            Local0 = (Arg0 & 0x08)
            If ((Local0 == 0x08))
            {
                Notify (S003, Arg1)
            }

            Local0 = (Arg0 & 0x10)
            If ((Local0 == 0x10))
            {
                Notify (S004, Arg1)
            }

            Local0 = (Arg0 & 0x20)
            If ((Local0 == 0x20))
            {
                Notify (S005, Arg1)
            }

            Local0 = (Arg0 & 0x40)
            If ((Local0 == 0x40))
            {
                Notify (S006, Arg1)
            }

            Local0 = (Arg0 & 0x80)
            If ((Local0 == 0x80))
            {
                Notify (S007, Arg1)
            }

            Local0 = (Arg0 & 0x0100)
            If ((Local0 == 0x0100))
            {
                Notify (S008, Arg1)
            }

            Local0 = (Arg0 & 0x0200)
            If ((Local0 == 0x0200))
            {
                Notify (S009, Arg1)
            }

            Local0 = (Arg0 & 0x0400)
            If ((Local0 == 0x0400))
            {
                Notify (S010, Arg1)
            }

            Local0 = (Arg0 & 0x0800)
            If ((Local0 == 0x0800))
            {
                Notify (S011, Arg1)
            }

            Local0 = (Arg0 & 0x1000)
            If ((Local0 == 0x1000))
            {
                Notify (S012, Arg1)
            }

            Local0 = (Arg0 & 0x2000)
            If ((Local0 == 0x2000))
            {
                Notify (S013, Arg1)
            }

            Local0 = (Arg0 & 0x4000)
            If ((Local0 == 0x4000))
            {
                Notify (S014, Arg1)
            }

            Local0 = (Arg0 & 0x8000)
            If ((Local0 == 0x8000))
            {
                Notify (S015, Arg1)
            }

            Local0 = (Arg0 & 0x00010000)
            If ((Local0 == 0x00010000))
            {
                Notify (S016, Arg1)
            }

            Local0 = (Arg0 & 0x00020000)
            If ((Local0 == 0x00020000))
            {
                Notify (S017, Arg1)
            }

            Local0 = (Arg0 & 0x00040000)
            If ((Local0 == 0x00040000))
            {
                Notify (S018, Arg1)
            }

            Local0 = (Arg0 & 0x00080000)
            If ((Local0 == 0x00080000))
            {
                Notify (S019, Arg1)
            }

            Local0 = (Arg0 & 0x00100000)
            If ((Local0 == 0x00100000))
            {
                Notify (S020, Arg1)
            }

            Local0 = (Arg0 & 0x00200000)
            If ((Local0 == 0x00200000))
            {
                Notify (S021, Arg1)
            }

            Local0 = (Arg0 & 0x00400000)
            If ((Local0 == 0x00400000))
            {
                Notify (S022, Arg1)
            }

            Local0 = (Arg0 & 0x00800000)
            If ((Local0 == 0x00800000))
            {
                Notify (S023, Arg1)
            }

            Local0 = (Arg0 & 0x01000000)
            If ((Local0 == 0x01000000))
            {
                Notify (S024, Arg1)
            }

            Local0 = (Arg0 & 0x02000000)
            If ((Local0 == 0x02000000))
            {
                Notify (S025, Arg1)
            }

            Local0 = (Arg0 & 0x04000000)
            If ((Local0 == 0x04000000))
            {
                Notify (S026, Arg1)
            }

            Local0 = (Arg0 & 0x08000000)
            If ((Local0 == 0x08000000))
            {
                Notify (S027, Arg1)
            }

            Local0 = (Arg0 & 0x10000000)
            If ((Local0 == 0x10000000))
            {
                Notify (S028, Arg1)
            }

            Local0 = (Arg0 & 0x20000000)
            If ((Local0 == 0x20000000))
            {
                Notify (S029, Arg1)
            }

            Local0 = (Arg0 & 0x40000000)
            If ((Local0 == 0x40000000))
            {
                Notify (S030, Arg1)
            }

            Local0 = (Arg0 & 0x80000000)
            If ((Local0 == 0x80000000))
            {
                Notify (S031, Arg1)
            }
        }

        Method (PCNT, 0, Serialized)
        {
            Acquire (\_SB.PHPR.BLCK, 0xFFFF)
            \_SB.PHPR.PSEG = _SEG /* \_SB_.PC03._SEG */
            DVNT (\_SB.PHPR.PCIU, One)
            DVNT (\_SB.PHPR.PCID, 0x03)
            Release (\_SB.PHPR.BLCK)
        }

        Name (_PRT, Package (0x20)  // _PRT: PCI Routing Table
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0007FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0008FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0009FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x000AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x000BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x000CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x000DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x000EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x000FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0010FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0012FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0013FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0014FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0015FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0017FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0018FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }
        })
    }

    Device (_SB.PC04)
    {
        Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
        Name (_ADR, Zero)  // _ADR: Address
        Name (_SEG, 0x04)  // _SEG: PCI Segment
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CCA, One)  // _CCA: Cache Coherency Attribute
        Name (SUPP, Zero)
        Method (_PXM, 0, NotSerialized)  // _PXM: Device Proximity
        {
            Return (Zero)
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x21                                             // !
                    })
                }

                If ((Arg2 == 0x05))
                {
                    Return (Zero)
                }
            }

            Return (Buffer (One)
            {
                 0x00                                             // .
            })
        }

        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x0000,             // Range Maximum
                0x0000,             // Translation Offset
                0x0001,             // Length
                ,, )
            Memory32Fixed (ReadWrite,
                0xE8400000,         // Address Base
                0x00100000,         // Address Length
                )
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x0000010400000000, // Range Minimum
                0x00000104FFFFFFFF, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000100000000, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        Device (S000)
        {
            Name (_SUN, Zero)  // _SUN: Slot User Number
            Name (_ADR, Zero)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S001)
        {
            Name (_SUN, One)  // _SUN: Slot User Number
            Name (_ADR, 0x00010000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S002)
        {
            Name (_SUN, 0x02)  // _SUN: Slot User Number
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S003)
        {
            Name (_SUN, 0x03)  // _SUN: Slot User Number
            Name (_ADR, 0x00030000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S004)
        {
            Name (_SUN, 0x04)  // _SUN: Slot User Number
            Name (_ADR, 0x00040000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S005)
        {
            Name (_SUN, 0x05)  // _SUN: Slot User Number
            Name (_ADR, 0x00050000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S006)
        {
            Name (_SUN, 0x06)  // _SUN: Slot User Number
            Name (_ADR, 0x00060000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S007)
        {
            Name (_SUN, 0x07)  // _SUN: Slot User Number
            Name (_ADR, 0x00070000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S008)
        {
            Name (_SUN, 0x08)  // _SUN: Slot User Number
            Name (_ADR, 0x00080000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S009)
        {
            Name (_SUN, 0x09)  // _SUN: Slot User Number
            Name (_ADR, 0x00090000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S010)
        {
            Name (_SUN, 0x0A)  // _SUN: Slot User Number
            Name (_ADR, 0x000A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S011)
        {
            Name (_SUN, 0x0B)  // _SUN: Slot User Number
            Name (_ADR, 0x000B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S012)
        {
            Name (_SUN, 0x0C)  // _SUN: Slot User Number
            Name (_ADR, 0x000C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S013)
        {
            Name (_SUN, 0x0D)  // _SUN: Slot User Number
            Name (_ADR, 0x000D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S014)
        {
            Name (_SUN, 0x0E)  // _SUN: Slot User Number
            Name (_ADR, 0x000E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S015)
        {
            Name (_SUN, 0x0F)  // _SUN: Slot User Number
            Name (_ADR, 0x000F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S016)
        {
            Name (_SUN, 0x10)  // _SUN: Slot User Number
            Name (_ADR, 0x00100000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S017)
        {
            Name (_SUN, 0x11)  // _SUN: Slot User Number
            Name (_ADR, 0x00110000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S018)
        {
            Name (_SUN, 0x12)  // _SUN: Slot User Number
            Name (_ADR, 0x00120000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S019)
        {
            Name (_SUN, 0x13)  // _SUN: Slot User Number
            Name (_ADR, 0x00130000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S020)
        {
            Name (_SUN, 0x14)  // _SUN: Slot User Number
            Name (_ADR, 0x00140000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S021)
        {
            Name (_SUN, 0x15)  // _SUN: Slot User Number
            Name (_ADR, 0x00150000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S022)
        {
            Name (_SUN, 0x16)  // _SUN: Slot User Number
            Name (_ADR, 0x00160000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S023)
        {
            Name (_SUN, 0x17)  // _SUN: Slot User Number
            Name (_ADR, 0x00170000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S024)
        {
            Name (_SUN, 0x18)  // _SUN: Slot User Number
            Name (_ADR, 0x00180000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S025)
        {
            Name (_SUN, 0x19)  // _SUN: Slot User Number
            Name (_ADR, 0x00190000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S026)
        {
            Name (_SUN, 0x1A)  // _SUN: Slot User Number
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S027)
        {
            Name (_SUN, 0x1B)  // _SUN: Slot User Number
            Name (_ADR, 0x001B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S028)
        {
            Name (_SUN, 0x1C)  // _SUN: Slot User Number
            Name (_ADR, 0x001C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S029)
        {
            Name (_SUN, 0x1D)  // _SUN: Slot User Number
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S030)
        {
            Name (_SUN, 0x1E)  // _SUN: Slot User Number
            Name (_ADR, 0x001E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S031)
        {
            Name (_SUN, 0x1F)  // _SUN: Slot User Number
            Name (_ADR, 0x001F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Method (DVNT, 2, Serialized)
        {
            Local0 = (Arg0 & One)
            If ((Local0 == One))
            {
                Notify (S000, Arg1)
            }

            Local0 = (Arg0 & 0x02)
            If ((Local0 == 0x02))
            {
                Notify (S001, Arg1)
            }

            Local0 = (Arg0 & 0x04)
            If ((Local0 == 0x04))
            {
                Notify (S002, Arg1)
            }

            Local0 = (Arg0 & 0x08)
            If ((Local0 == 0x08))
            {
                Notify (S003, Arg1)
            }

            Local0 = (Arg0 & 0x10)
            If ((Local0 == 0x10))
            {
                Notify (S004, Arg1)
            }

            Local0 = (Arg0 & 0x20)
            If ((Local0 == 0x20))
            {
                Notify (S005, Arg1)
            }

            Local0 = (Arg0 & 0x40)
            If ((Local0 == 0x40))
            {
                Notify (S006, Arg1)
            }

            Local0 = (Arg0 & 0x80)
            If ((Local0 == 0x80))
            {
                Notify (S007, Arg1)
            }

            Local0 = (Arg0 & 0x0100)
            If ((Local0 == 0x0100))
            {
                Notify (S008, Arg1)
            }

            Local0 = (Arg0 & 0x0200)
            If ((Local0 == 0x0200))
            {
                Notify (S009, Arg1)
            }

            Local0 = (Arg0 & 0x0400)
            If ((Local0 == 0x0400))
            {
                Notify (S010, Arg1)
            }

            Local0 = (Arg0 & 0x0800)
            If ((Local0 == 0x0800))
            {
                Notify (S011, Arg1)
            }

            Local0 = (Arg0 & 0x1000)
            If ((Local0 == 0x1000))
            {
                Notify (S012, Arg1)
            }

            Local0 = (Arg0 & 0x2000)
            If ((Local0 == 0x2000))
            {
                Notify (S013, Arg1)
            }

            Local0 = (Arg0 & 0x4000)
            If ((Local0 == 0x4000))
            {
                Notify (S014, Arg1)
            }

            Local0 = (Arg0 & 0x8000)
            If ((Local0 == 0x8000))
            {
                Notify (S015, Arg1)
            }

            Local0 = (Arg0 & 0x00010000)
            If ((Local0 == 0x00010000))
            {
                Notify (S016, Arg1)
            }

            Local0 = (Arg0 & 0x00020000)
            If ((Local0 == 0x00020000))
            {
                Notify (S017, Arg1)
            }

            Local0 = (Arg0 & 0x00040000)
            If ((Local0 == 0x00040000))
            {
                Notify (S018, Arg1)
            }

            Local0 = (Arg0 & 0x00080000)
            If ((Local0 == 0x00080000))
            {
                Notify (S019, Arg1)
            }

            Local0 = (Arg0 & 0x00100000)
            If ((Local0 == 0x00100000))
            {
                Notify (S020, Arg1)
            }

            Local0 = (Arg0 & 0x00200000)
            If ((Local0 == 0x00200000))
            {
                Notify (S021, Arg1)
            }

            Local0 = (Arg0 & 0x00400000)
            If ((Local0 == 0x00400000))
            {
                Notify (S022, Arg1)
            }

            Local0 = (Arg0 & 0x00800000)
            If ((Local0 == 0x00800000))
            {
                Notify (S023, Arg1)
            }

            Local0 = (Arg0 & 0x01000000)
            If ((Local0 == 0x01000000))
            {
                Notify (S024, Arg1)
            }

            Local0 = (Arg0 & 0x02000000)
            If ((Local0 == 0x02000000))
            {
                Notify (S025, Arg1)
            }

            Local0 = (Arg0 & 0x04000000)
            If ((Local0 == 0x04000000))
            {
                Notify (S026, Arg1)
            }

            Local0 = (Arg0 & 0x08000000)
            If ((Local0 == 0x08000000))
            {
                Notify (S027, Arg1)
            }

            Local0 = (Arg0 & 0x10000000)
            If ((Local0 == 0x10000000))
            {
                Notify (S028, Arg1)
            }

            Local0 = (Arg0 & 0x20000000)
            If ((Local0 == 0x20000000))
            {
                Notify (S029, Arg1)
            }

            Local0 = (Arg0 & 0x40000000)
            If ((Local0 == 0x40000000))
            {
                Notify (S030, Arg1)
            }

            Local0 = (Arg0 & 0x80000000)
            If ((Local0 == 0x80000000))
            {
                Notify (S031, Arg1)
            }
        }

        Method (PCNT, 0, Serialized)
        {
            Acquire (\_SB.PHPR.BLCK, 0xFFFF)
            \_SB.PHPR.PSEG = _SEG /* \_SB_.PC04._SEG */
            DVNT (\_SB.PHPR.PCIU, One)
            DVNT (\_SB.PHPR.PCID, 0x03)
            Release (\_SB.PHPR.BLCK)
        }

        Name (_PRT, Package (0x20)  // _PRT: PCI Routing Table
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0007FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0008FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0009FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x000AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x000BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x000CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x000DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x000EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x000FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0010FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0012FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0013FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0014FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0015FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0017FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0018FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }
        })
    }

    Device (_SB.PC05)
    {
        Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
        Name (_ADR, Zero)  // _ADR: Address
        Name (_SEG, 0x05)  // _SEG: PCI Segment
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CCA, One)  // _CCA: Cache Coherency Attribute
        Name (SUPP, Zero)
        Method (_PXM, 0, NotSerialized)  // _PXM: Device Proximity
        {
            Return (Zero)
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x21                                             // !
                    })
                }

                If ((Arg2 == 0x05))
                {
                    Return (Zero)
                }
            }

            Return (Buffer (One)
            {
                 0x00                                             // .
            })
        }

        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x0000,             // Range Maximum
                0x0000,             // Translation Offset
                0x0001,             // Length
                ,, )
            Memory32Fixed (ReadWrite,
                0xE8500000,         // Address Base
                0x00100000,         // Address Length
                )
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x0000010500000000, // Range Minimum
                0x00000105FFFFFFFF, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000100000000, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        Device (S000)
        {
            Name (_SUN, Zero)  // _SUN: Slot User Number
            Name (_ADR, Zero)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S001)
        {
            Name (_SUN, One)  // _SUN: Slot User Number
            Name (_ADR, 0x00010000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S002)
        {
            Name (_SUN, 0x02)  // _SUN: Slot User Number
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S003)
        {
            Name (_SUN, 0x03)  // _SUN: Slot User Number
            Name (_ADR, 0x00030000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S004)
        {
            Name (_SUN, 0x04)  // _SUN: Slot User Number
            Name (_ADR, 0x00040000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S005)
        {
            Name (_SUN, 0x05)  // _SUN: Slot User Number
            Name (_ADR, 0x00050000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S006)
        {
            Name (_SUN, 0x06)  // _SUN: Slot User Number
            Name (_ADR, 0x00060000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S007)
        {
            Name (_SUN, 0x07)  // _SUN: Slot User Number
            Name (_ADR, 0x00070000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S008)
        {
            Name (_SUN, 0x08)  // _SUN: Slot User Number
            Name (_ADR, 0x00080000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S009)
        {
            Name (_SUN, 0x09)  // _SUN: Slot User Number
            Name (_ADR, 0x00090000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S010)
        {
            Name (_SUN, 0x0A)  // _SUN: Slot User Number
            Name (_ADR, 0x000A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S011)
        {
            Name (_SUN, 0x0B)  // _SUN: Slot User Number
            Name (_ADR, 0x000B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S012)
        {
            Name (_SUN, 0x0C)  // _SUN: Slot User Number
            Name (_ADR, 0x000C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S013)
        {
            Name (_SUN, 0x0D)  // _SUN: Slot User Number
            Name (_ADR, 0x000D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S014)
        {
            Name (_SUN, 0x0E)  // _SUN: Slot User Number
            Name (_ADR, 0x000E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S015)
        {
            Name (_SUN, 0x0F)  // _SUN: Slot User Number
            Name (_ADR, 0x000F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S016)
        {
            Name (_SUN, 0x10)  // _SUN: Slot User Number
            Name (_ADR, 0x00100000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S017)
        {
            Name (_SUN, 0x11)  // _SUN: Slot User Number
            Name (_ADR, 0x00110000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S018)
        {
            Name (_SUN, 0x12)  // _SUN: Slot User Number
            Name (_ADR, 0x00120000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S019)
        {
            Name (_SUN, 0x13)  // _SUN: Slot User Number
            Name (_ADR, 0x00130000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S020)
        {
            Name (_SUN, 0x14)  // _SUN: Slot User Number
            Name (_ADR, 0x00140000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S021)
        {
            Name (_SUN, 0x15)  // _SUN: Slot User Number
            Name (_ADR, 0x00150000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S022)
        {
            Name (_SUN, 0x16)  // _SUN: Slot User Number
            Name (_ADR, 0x00160000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S023)
        {
            Name (_SUN, 0x17)  // _SUN: Slot User Number
            Name (_ADR, 0x00170000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S024)
        {
            Name (_SUN, 0x18)  // _SUN: Slot User Number
            Name (_ADR, 0x00180000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S025)
        {
            Name (_SUN, 0x19)  // _SUN: Slot User Number
            Name (_ADR, 0x00190000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S026)
        {
            Name (_SUN, 0x1A)  // _SUN: Slot User Number
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S027)
        {
            Name (_SUN, 0x1B)  // _SUN: Slot User Number
            Name (_ADR, 0x001B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S028)
        {
            Name (_SUN, 0x1C)  // _SUN: Slot User Number
            Name (_ADR, 0x001C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S029)
        {
            Name (_SUN, 0x1D)  // _SUN: Slot User Number
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S030)
        {
            Name (_SUN, 0x1E)  // _SUN: Slot User Number
            Name (_ADR, 0x001E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S031)
        {
            Name (_SUN, 0x1F)  // _SUN: Slot User Number
            Name (_ADR, 0x001F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Method (DVNT, 2, Serialized)
        {
            Local0 = (Arg0 & One)
            If ((Local0 == One))
            {
                Notify (S000, Arg1)
            }

            Local0 = (Arg0 & 0x02)
            If ((Local0 == 0x02))
            {
                Notify (S001, Arg1)
            }

            Local0 = (Arg0 & 0x04)
            If ((Local0 == 0x04))
            {
                Notify (S002, Arg1)
            }

            Local0 = (Arg0 & 0x08)
            If ((Local0 == 0x08))
            {
                Notify (S003, Arg1)
            }

            Local0 = (Arg0 & 0x10)
            If ((Local0 == 0x10))
            {
                Notify (S004, Arg1)
            }

            Local0 = (Arg0 & 0x20)
            If ((Local0 == 0x20))
            {
                Notify (S005, Arg1)
            }

            Local0 = (Arg0 & 0x40)
            If ((Local0 == 0x40))
            {
                Notify (S006, Arg1)
            }

            Local0 = (Arg0 & 0x80)
            If ((Local0 == 0x80))
            {
                Notify (S007, Arg1)
            }

            Local0 = (Arg0 & 0x0100)
            If ((Local0 == 0x0100))
            {
                Notify (S008, Arg1)
            }

            Local0 = (Arg0 & 0x0200)
            If ((Local0 == 0x0200))
            {
                Notify (S009, Arg1)
            }

            Local0 = (Arg0 & 0x0400)
            If ((Local0 == 0x0400))
            {
                Notify (S010, Arg1)
            }

            Local0 = (Arg0 & 0x0800)
            If ((Local0 == 0x0800))
            {
                Notify (S011, Arg1)
            }

            Local0 = (Arg0 & 0x1000)
            If ((Local0 == 0x1000))
            {
                Notify (S012, Arg1)
            }

            Local0 = (Arg0 & 0x2000)
            If ((Local0 == 0x2000))
            {
                Notify (S013, Arg1)
            }

            Local0 = (Arg0 & 0x4000)
            If ((Local0 == 0x4000))
            {
                Notify (S014, Arg1)
            }

            Local0 = (Arg0 & 0x8000)
            If ((Local0 == 0x8000))
            {
                Notify (S015, Arg1)
            }

            Local0 = (Arg0 & 0x00010000)
            If ((Local0 == 0x00010000))
            {
                Notify (S016, Arg1)
            }

            Local0 = (Arg0 & 0x00020000)
            If ((Local0 == 0x00020000))
            {
                Notify (S017, Arg1)
            }

            Local0 = (Arg0 & 0x00040000)
            If ((Local0 == 0x00040000))
            {
                Notify (S018, Arg1)
            }

            Local0 = (Arg0 & 0x00080000)
            If ((Local0 == 0x00080000))
            {
                Notify (S019, Arg1)
            }

            Local0 = (Arg0 & 0x00100000)
            If ((Local0 == 0x00100000))
            {
                Notify (S020, Arg1)
            }

            Local0 = (Arg0 & 0x00200000)
            If ((Local0 == 0x00200000))
            {
                Notify (S021, Arg1)
            }

            Local0 = (Arg0 & 0x00400000)
            If ((Local0 == 0x00400000))
            {
                Notify (S022, Arg1)
            }

            Local0 = (Arg0 & 0x00800000)
            If ((Local0 == 0x00800000))
            {
                Notify (S023, Arg1)
            }

            Local0 = (Arg0 & 0x01000000)
            If ((Local0 == 0x01000000))
            {
                Notify (S024, Arg1)
            }

            Local0 = (Arg0 & 0x02000000)
            If ((Local0 == 0x02000000))
            {
                Notify (S025, Arg1)
            }

            Local0 = (Arg0 & 0x04000000)
            If ((Local0 == 0x04000000))
            {
                Notify (S026, Arg1)
            }

            Local0 = (Arg0 & 0x08000000)
            If ((Local0 == 0x08000000))
            {
                Notify (S027, Arg1)
            }

            Local0 = (Arg0 & 0x10000000)
            If ((Local0 == 0x10000000))
            {
                Notify (S028, Arg1)
            }

            Local0 = (Arg0 & 0x20000000)
            If ((Local0 == 0x20000000))
            {
                Notify (S029, Arg1)
            }

            Local0 = (Arg0 & 0x40000000)
            If ((Local0 == 0x40000000))
            {
                Notify (S030, Arg1)
            }

            Local0 = (Arg0 & 0x80000000)
            If ((Local0 == 0x80000000))
            {
                Notify (S031, Arg1)
            }
        }

        Method (PCNT, 0, Serialized)
        {
            Acquire (\_SB.PHPR.BLCK, 0xFFFF)
            \_SB.PHPR.PSEG = _SEG /* \_SB_.PC05._SEG */
            DVNT (\_SB.PHPR.PCIU, One)
            DVNT (\_SB.PHPR.PCID, 0x03)
            Release (\_SB.PHPR.BLCK)
        }

        Name (_PRT, Package (0x20)  // _PRT: PCI Routing Table
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0007FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0008FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0009FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x000AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x000BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x000CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x000DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x000EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x000FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0010FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0012FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0013FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0014FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0015FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0017FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0018FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }
        })
    }

    Device (_SB.PC06)
    {
        Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
        Name (_ADR, Zero)  // _ADR: Address
        Name (_SEG, 0x06)  // _SEG: PCI Segment
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CCA, One)  // _CCA: Cache Coherency Attribute
        Name (SUPP, Zero)
        Method (_PXM, 0, NotSerialized)  // _PXM: Device Proximity
        {
            Return (Zero)
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x21                                             // !
                    })
                }

                If ((Arg2 == 0x05))
                {
                    Return (Zero)
                }
            }

            Return (Buffer (One)
            {
                 0x00                                             // .
            })
        }

        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x0000,             // Range Maximum
                0x0000,             // Translation Offset
                0x0001,             // Length
                ,, )
            Memory32Fixed (ReadWrite,
                0xE8600000,         // Address Base
                0x00100000,         // Address Length
                )
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x0000010600000000, // Range Minimum
                0x00000106FFFFFFFF, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000100000000, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        Device (S000)
        {
            Name (_SUN, Zero)  // _SUN: Slot User Number
            Name (_ADR, Zero)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S001)
        {
            Name (_SUN, One)  // _SUN: Slot User Number
            Name (_ADR, 0x00010000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S002)
        {
            Name (_SUN, 0x02)  // _SUN: Slot User Number
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S003)
        {
            Name (_SUN, 0x03)  // _SUN: Slot User Number
            Name (_ADR, 0x00030000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S004)
        {
            Name (_SUN, 0x04)  // _SUN: Slot User Number
            Name (_ADR, 0x00040000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S005)
        {
            Name (_SUN, 0x05)  // _SUN: Slot User Number
            Name (_ADR, 0x00050000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S006)
        {
            Name (_SUN, 0x06)  // _SUN: Slot User Number
            Name (_ADR, 0x00060000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S007)
        {
            Name (_SUN, 0x07)  // _SUN: Slot User Number
            Name (_ADR, 0x00070000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S008)
        {
            Name (_SUN, 0x08)  // _SUN: Slot User Number
            Name (_ADR, 0x00080000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S009)
        {
            Name (_SUN, 0x09)  // _SUN: Slot User Number
            Name (_ADR, 0x00090000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S010)
        {
            Name (_SUN, 0x0A)  // _SUN: Slot User Number
            Name (_ADR, 0x000A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S011)
        {
            Name (_SUN, 0x0B)  // _SUN: Slot User Number
            Name (_ADR, 0x000B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S012)
        {
            Name (_SUN, 0x0C)  // _SUN: Slot User Number
            Name (_ADR, 0x000C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S013)
        {
            Name (_SUN, 0x0D)  // _SUN: Slot User Number
            Name (_ADR, 0x000D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S014)
        {
            Name (_SUN, 0x0E)  // _SUN: Slot User Number
            Name (_ADR, 0x000E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S015)
        {
            Name (_SUN, 0x0F)  // _SUN: Slot User Number
            Name (_ADR, 0x000F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S016)
        {
            Name (_SUN, 0x10)  // _SUN: Slot User Number
            Name (_ADR, 0x00100000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S017)
        {
            Name (_SUN, 0x11)  // _SUN: Slot User Number
            Name (_ADR, 0x00110000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S018)
        {
            Name (_SUN, 0x12)  // _SUN: Slot User Number
            Name (_ADR, 0x00120000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S019)
        {
            Name (_SUN, 0x13)  // _SUN: Slot User Number
            Name (_ADR, 0x00130000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S020)
        {
            Name (_SUN, 0x14)  // _SUN: Slot User Number
            Name (_ADR, 0x00140000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S021)
        {
            Name (_SUN, 0x15)  // _SUN: Slot User Number
            Name (_ADR, 0x00150000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S022)
        {
            Name (_SUN, 0x16)  // _SUN: Slot User Number
            Name (_ADR, 0x00160000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S023)
        {
            Name (_SUN, 0x17)  // _SUN: Slot User Number
            Name (_ADR, 0x00170000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S024)
        {
            Name (_SUN, 0x18)  // _SUN: Slot User Number
            Name (_ADR, 0x00180000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S025)
        {
            Name (_SUN, 0x19)  // _SUN: Slot User Number
            Name (_ADR, 0x00190000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S026)
        {
            Name (_SUN, 0x1A)  // _SUN: Slot User Number
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S027)
        {
            Name (_SUN, 0x1B)  // _SUN: Slot User Number
            Name (_ADR, 0x001B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S028)
        {
            Name (_SUN, 0x1C)  // _SUN: Slot User Number
            Name (_ADR, 0x001C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S029)
        {
            Name (_SUN, 0x1D)  // _SUN: Slot User Number
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S030)
        {
            Name (_SUN, 0x1E)  // _SUN: Slot User Number
            Name (_ADR, 0x001E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S031)
        {
            Name (_SUN, 0x1F)  // _SUN: Slot User Number
            Name (_ADR, 0x001F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Method (DVNT, 2, Serialized)
        {
            Local0 = (Arg0 & One)
            If ((Local0 == One))
            {
                Notify (S000, Arg1)
            }

            Local0 = (Arg0 & 0x02)
            If ((Local0 == 0x02))
            {
                Notify (S001, Arg1)
            }

            Local0 = (Arg0 & 0x04)
            If ((Local0 == 0x04))
            {
                Notify (S002, Arg1)
            }

            Local0 = (Arg0 & 0x08)
            If ((Local0 == 0x08))
            {
                Notify (S003, Arg1)
            }

            Local0 = (Arg0 & 0x10)
            If ((Local0 == 0x10))
            {
                Notify (S004, Arg1)
            }

            Local0 = (Arg0 & 0x20)
            If ((Local0 == 0x20))
            {
                Notify (S005, Arg1)
            }

            Local0 = (Arg0 & 0x40)
            If ((Local0 == 0x40))
            {
                Notify (S006, Arg1)
            }

            Local0 = (Arg0 & 0x80)
            If ((Local0 == 0x80))
            {
                Notify (S007, Arg1)
            }

            Local0 = (Arg0 & 0x0100)
            If ((Local0 == 0x0100))
            {
                Notify (S008, Arg1)
            }

            Local0 = (Arg0 & 0x0200)
            If ((Local0 == 0x0200))
            {
                Notify (S009, Arg1)
            }

            Local0 = (Arg0 & 0x0400)
            If ((Local0 == 0x0400))
            {
                Notify (S010, Arg1)
            }

            Local0 = (Arg0 & 0x0800)
            If ((Local0 == 0x0800))
            {
                Notify (S011, Arg1)
            }

            Local0 = (Arg0 & 0x1000)
            If ((Local0 == 0x1000))
            {
                Notify (S012, Arg1)
            }

            Local0 = (Arg0 & 0x2000)
            If ((Local0 == 0x2000))
            {
                Notify (S013, Arg1)
            }

            Local0 = (Arg0 & 0x4000)
            If ((Local0 == 0x4000))
            {
                Notify (S014, Arg1)
            }

            Local0 = (Arg0 & 0x8000)
            If ((Local0 == 0x8000))
            {
                Notify (S015, Arg1)
            }

            Local0 = (Arg0 & 0x00010000)
            If ((Local0 == 0x00010000))
            {
                Notify (S016, Arg1)
            }

            Local0 = (Arg0 & 0x00020000)
            If ((Local0 == 0x00020000))
            {
                Notify (S017, Arg1)
            }

            Local0 = (Arg0 & 0x00040000)
            If ((Local0 == 0x00040000))
            {
                Notify (S018, Arg1)
            }

            Local0 = (Arg0 & 0x00080000)
            If ((Local0 == 0x00080000))
            {
                Notify (S019, Arg1)
            }

            Local0 = (Arg0 & 0x00100000)
            If ((Local0 == 0x00100000))
            {
                Notify (S020, Arg1)
            }

            Local0 = (Arg0 & 0x00200000)
            If ((Local0 == 0x00200000))
            {
                Notify (S021, Arg1)
            }

            Local0 = (Arg0 & 0x00400000)
            If ((Local0 == 0x00400000))
            {
                Notify (S022, Arg1)
            }

            Local0 = (Arg0 & 0x00800000)
            If ((Local0 == 0x00800000))
            {
                Notify (S023, Arg1)
            }

            Local0 = (Arg0 & 0x01000000)
            If ((Local0 == 0x01000000))
            {
                Notify (S024, Arg1)
            }

            Local0 = (Arg0 & 0x02000000)
            If ((Local0 == 0x02000000))
            {
                Notify (S025, Arg1)
            }

            Local0 = (Arg0 & 0x04000000)
            If ((Local0 == 0x04000000))
            {
                Notify (S026, Arg1)
            }

            Local0 = (Arg0 & 0x08000000)
            If ((Local0 == 0x08000000))
            {
                Notify (S027, Arg1)
            }

            Local0 = (Arg0 & 0x10000000)
            If ((Local0 == 0x10000000))
            {
                Notify (S028, Arg1)
            }

            Local0 = (Arg0 & 0x20000000)
            If ((Local0 == 0x20000000))
            {
                Notify (S029, Arg1)
            }

            Local0 = (Arg0 & 0x40000000)
            If ((Local0 == 0x40000000))
            {
                Notify (S030, Arg1)
            }

            Local0 = (Arg0 & 0x80000000)
            If ((Local0 == 0x80000000))
            {
                Notify (S031, Arg1)
            }
        }

        Method (PCNT, 0, Serialized)
        {
            Acquire (\_SB.PHPR.BLCK, 0xFFFF)
            \_SB.PHPR.PSEG = _SEG /* \_SB_.PC06._SEG */
            DVNT (\_SB.PHPR.PCIU, One)
            DVNT (\_SB.PHPR.PCID, 0x03)
            Release (\_SB.PHPR.BLCK)
        }

        Name (_PRT, Package (0x20)  // _PRT: PCI Routing Table
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0007FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0008FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0009FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x000AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x000BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x000CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x000DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x000EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x000FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0010FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0012FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0013FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0014FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0015FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0017FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0018FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }
        })
    }

    Device (_SB.PC07)
    {
        Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
        Name (_ADR, Zero)  // _ADR: Address
        Name (_SEG, 0x07)  // _SEG: PCI Segment
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CCA, One)  // _CCA: Cache Coherency Attribute
        Name (SUPP, Zero)
        Method (_PXM, 0, NotSerialized)  // _PXM: Device Proximity
        {
            Return (Zero)
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x21                                             // !
                    })
                }

                If ((Arg2 == 0x05))
                {
                    Return (Zero)
                }
            }

            Return (Buffer (One)
            {
                 0x00                                             // .
            })
        }

        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x0000,             // Range Maximum
                0x0000,             // Translation Offset
                0x0001,             // Length
                ,, )
            Memory32Fixed (ReadWrite,
                0xE8700000,         // Address Base
                0x00100000,         // Address Length
                )
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x0000010700000000, // Range Minimum
                0x00000107FFFFFFFF, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000100000000, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        Device (S000)
        {
            Name (_SUN, Zero)  // _SUN: Slot User Number
            Name (_ADR, Zero)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S001)
        {
            Name (_SUN, One)  // _SUN: Slot User Number
            Name (_ADR, 0x00010000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S002)
        {
            Name (_SUN, 0x02)  // _SUN: Slot User Number
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S003)
        {
            Name (_SUN, 0x03)  // _SUN: Slot User Number
            Name (_ADR, 0x00030000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S004)
        {
            Name (_SUN, 0x04)  // _SUN: Slot User Number
            Name (_ADR, 0x00040000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S005)
        {
            Name (_SUN, 0x05)  // _SUN: Slot User Number
            Name (_ADR, 0x00050000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S006)
        {
            Name (_SUN, 0x06)  // _SUN: Slot User Number
            Name (_ADR, 0x00060000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S007)
        {
            Name (_SUN, 0x07)  // _SUN: Slot User Number
            Name (_ADR, 0x00070000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S008)
        {
            Name (_SUN, 0x08)  // _SUN: Slot User Number
            Name (_ADR, 0x00080000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S009)
        {
            Name (_SUN, 0x09)  // _SUN: Slot User Number
            Name (_ADR, 0x00090000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S010)
        {
            Name (_SUN, 0x0A)  // _SUN: Slot User Number
            Name (_ADR, 0x000A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S011)
        {
            Name (_SUN, 0x0B)  // _SUN: Slot User Number
            Name (_ADR, 0x000B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S012)
        {
            Name (_SUN, 0x0C)  // _SUN: Slot User Number
            Name (_ADR, 0x000C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S013)
        {
            Name (_SUN, 0x0D)  // _SUN: Slot User Number
            Name (_ADR, 0x000D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S014)
        {
            Name (_SUN, 0x0E)  // _SUN: Slot User Number
            Name (_ADR, 0x000E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S015)
        {
            Name (_SUN, 0x0F)  // _SUN: Slot User Number
            Name (_ADR, 0x000F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S016)
        {
            Name (_SUN, 0x10)  // _SUN: Slot User Number
            Name (_ADR, 0x00100000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S017)
        {
            Name (_SUN, 0x11)  // _SUN: Slot User Number
            Name (_ADR, 0x00110000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S018)
        {
            Name (_SUN, 0x12)  // _SUN: Slot User Number
            Name (_ADR, 0x00120000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S019)
        {
            Name (_SUN, 0x13)  // _SUN: Slot User Number
            Name (_ADR, 0x00130000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S020)
        {
            Name (_SUN, 0x14)  // _SUN: Slot User Number
            Name (_ADR, 0x00140000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S021)
        {
            Name (_SUN, 0x15)  // _SUN: Slot User Number
            Name (_ADR, 0x00150000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S022)
        {
            Name (_SUN, 0x16)  // _SUN: Slot User Number
            Name (_ADR, 0x00160000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S023)
        {
            Name (_SUN, 0x17)  // _SUN: Slot User Number
            Name (_ADR, 0x00170000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S024)
        {
            Name (_SUN, 0x18)  // _SUN: Slot User Number
            Name (_ADR, 0x00180000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S025)
        {
            Name (_SUN, 0x19)  // _SUN: Slot User Number
            Name (_ADR, 0x00190000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S026)
        {
            Name (_SUN, 0x1A)  // _SUN: Slot User Number
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S027)
        {
            Name (_SUN, 0x1B)  // _SUN: Slot User Number
            Name (_ADR, 0x001B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S028)
        {
            Name (_SUN, 0x1C)  // _SUN: Slot User Number
            Name (_ADR, 0x001C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S029)
        {
            Name (_SUN, 0x1D)  // _SUN: Slot User Number
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S030)
        {
            Name (_SUN, 0x1E)  // _SUN: Slot User Number
            Name (_ADR, 0x001E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S031)
        {
            Name (_SUN, 0x1F)  // _SUN: Slot User Number
            Name (_ADR, 0x001F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Method (DVNT, 2, Serialized)
        {
            Local0 = (Arg0 & One)
            If ((Local0 == One))
            {
                Notify (S000, Arg1)
            }

            Local0 = (Arg0 & 0x02)
            If ((Local0 == 0x02))
            {
                Notify (S001, Arg1)
            }

            Local0 = (Arg0 & 0x04)
            If ((Local0 == 0x04))
            {
                Notify (S002, Arg1)
            }

            Local0 = (Arg0 & 0x08)
            If ((Local0 == 0x08))
            {
                Notify (S003, Arg1)
            }

            Local0 = (Arg0 & 0x10)
            If ((Local0 == 0x10))
            {
                Notify (S004, Arg1)
            }

            Local0 = (Arg0 & 0x20)
            If ((Local0 == 0x20))
            {
                Notify (S005, Arg1)
            }

            Local0 = (Arg0 & 0x40)
            If ((Local0 == 0x40))
            {
                Notify (S006, Arg1)
            }

            Local0 = (Arg0 & 0x80)
            If ((Local0 == 0x80))
            {
                Notify (S007, Arg1)
            }

            Local0 = (Arg0 & 0x0100)
            If ((Local0 == 0x0100))
            {
                Notify (S008, Arg1)
            }

            Local0 = (Arg0 & 0x0200)
            If ((Local0 == 0x0200))
            {
                Notify (S009, Arg1)
            }

            Local0 = (Arg0 & 0x0400)
            If ((Local0 == 0x0400))
            {
                Notify (S010, Arg1)
            }

            Local0 = (Arg0 & 0x0800)
            If ((Local0 == 0x0800))
            {
                Notify (S011, Arg1)
            }

            Local0 = (Arg0 & 0x1000)
            If ((Local0 == 0x1000))
            {
                Notify (S012, Arg1)
            }

            Local0 = (Arg0 & 0x2000)
            If ((Local0 == 0x2000))
            {
                Notify (S013, Arg1)
            }

            Local0 = (Arg0 & 0x4000)
            If ((Local0 == 0x4000))
            {
                Notify (S014, Arg1)
            }

            Local0 = (Arg0 & 0x8000)
            If ((Local0 == 0x8000))
            {
                Notify (S015, Arg1)
            }

            Local0 = (Arg0 & 0x00010000)
            If ((Local0 == 0x00010000))
            {
                Notify (S016, Arg1)
            }

            Local0 = (Arg0 & 0x00020000)
            If ((Local0 == 0x00020000))
            {
                Notify (S017, Arg1)
            }

            Local0 = (Arg0 & 0x00040000)
            If ((Local0 == 0x00040000))
            {
                Notify (S018, Arg1)
            }

            Local0 = (Arg0 & 0x00080000)
            If ((Local0 == 0x00080000))
            {
                Notify (S019, Arg1)
            }

            Local0 = (Arg0 & 0x00100000)
            If ((Local0 == 0x00100000))
            {
                Notify (S020, Arg1)
            }

            Local0 = (Arg0 & 0x00200000)
            If ((Local0 == 0x00200000))
            {
                Notify (S021, Arg1)
            }

            Local0 = (Arg0 & 0x00400000)
            If ((Local0 == 0x00400000))
            {
                Notify (S022, Arg1)
            }

            Local0 = (Arg0 & 0x00800000)
            If ((Local0 == 0x00800000))
            {
                Notify (S023, Arg1)
            }

            Local0 = (Arg0 & 0x01000000)
            If ((Local0 == 0x01000000))
            {
                Notify (S024, Arg1)
            }

            Local0 = (Arg0 & 0x02000000)
            If ((Local0 == 0x02000000))
            {
                Notify (S025, Arg1)
            }

            Local0 = (Arg0 & 0x04000000)
            If ((Local0 == 0x04000000))
            {
                Notify (S026, Arg1)
            }

            Local0 = (Arg0 & 0x08000000)
            If ((Local0 == 0x08000000))
            {
                Notify (S027, Arg1)
            }

            Local0 = (Arg0 & 0x10000000)
            If ((Local0 == 0x10000000))
            {
                Notify (S028, Arg1)
            }

            Local0 = (Arg0 & 0x20000000)
            If ((Local0 == 0x20000000))
            {
                Notify (S029, Arg1)
            }

            Local0 = (Arg0 & 0x40000000)
            If ((Local0 == 0x40000000))
            {
                Notify (S030, Arg1)
            }

            Local0 = (Arg0 & 0x80000000)
            If ((Local0 == 0x80000000))
            {
                Notify (S031, Arg1)
            }
        }

        Method (PCNT, 0, Serialized)
        {
            Acquire (\_SB.PHPR.BLCK, 0xFFFF)
            \_SB.PHPR.PSEG = _SEG /* \_SB_.PC07._SEG */
            DVNT (\_SB.PHPR.PCIU, One)
            DVNT (\_SB.PHPR.PCID, 0x03)
            Release (\_SB.PHPR.BLCK)
        }

        Name (_PRT, Package (0x20)  // _PRT: PCI Routing Table
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0007FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0008FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0009FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x000AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x000BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x000CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x000DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x000EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x000FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0010FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0012FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0013FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0014FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0015FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0017FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0018FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }
        })
    }

    Device (_SB.PC08)
    {
        Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
        Name (_ADR, Zero)  // _ADR: Address
        Name (_SEG, 0x08)  // _SEG: PCI Segment
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CCA, One)  // _CCA: Cache Coherency Attribute
        Name (SUPP, Zero)
        Method (_PXM, 0, NotSerialized)  // _PXM: Device Proximity
        {
            Return (Zero)
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x21                                             // !
                    })
                }

                If ((Arg2 == 0x05))
                {
                    Return (Zero)
                }
            }

            Return (Buffer (One)
            {
                 0x00                                             // .
            })
        }

        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x0000,             // Range Maximum
                0x0000,             // Translation Offset
                0x0001,             // Length
                ,, )
            Memory32Fixed (ReadWrite,
                0xE8800000,         // Address Base
                0x00100000,         // Address Length
                )
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x0000010800000000, // Range Minimum
                0x00000108FFFFFFFF, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000100000000, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        Device (S000)
        {
            Name (_SUN, Zero)  // _SUN: Slot User Number
            Name (_ADR, Zero)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S001)
        {
            Name (_SUN, One)  // _SUN: Slot User Number
            Name (_ADR, 0x00010000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S002)
        {
            Name (_SUN, 0x02)  // _SUN: Slot User Number
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S003)
        {
            Name (_SUN, 0x03)  // _SUN: Slot User Number
            Name (_ADR, 0x00030000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S004)
        {
            Name (_SUN, 0x04)  // _SUN: Slot User Number
            Name (_ADR, 0x00040000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S005)
        {
            Name (_SUN, 0x05)  // _SUN: Slot User Number
            Name (_ADR, 0x00050000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S006)
        {
            Name (_SUN, 0x06)  // _SUN: Slot User Number
            Name (_ADR, 0x00060000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S007)
        {
            Name (_SUN, 0x07)  // _SUN: Slot User Number
            Name (_ADR, 0x00070000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S008)
        {
            Name (_SUN, 0x08)  // _SUN: Slot User Number
            Name (_ADR, 0x00080000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S009)
        {
            Name (_SUN, 0x09)  // _SUN: Slot User Number
            Name (_ADR, 0x00090000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S010)
        {
            Name (_SUN, 0x0A)  // _SUN: Slot User Number
            Name (_ADR, 0x000A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S011)
        {
            Name (_SUN, 0x0B)  // _SUN: Slot User Number
            Name (_ADR, 0x000B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S012)
        {
            Name (_SUN, 0x0C)  // _SUN: Slot User Number
            Name (_ADR, 0x000C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S013)
        {
            Name (_SUN, 0x0D)  // _SUN: Slot User Number
            Name (_ADR, 0x000D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S014)
        {
            Name (_SUN, 0x0E)  // _SUN: Slot User Number
            Name (_ADR, 0x000E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S015)
        {
            Name (_SUN, 0x0F)  // _SUN: Slot User Number
            Name (_ADR, 0x000F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S016)
        {
            Name (_SUN, 0x10)  // _SUN: Slot User Number
            Name (_ADR, 0x00100000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S017)
        {
            Name (_SUN, 0x11)  // _SUN: Slot User Number
            Name (_ADR, 0x00110000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S018)
        {
            Name (_SUN, 0x12)  // _SUN: Slot User Number
            Name (_ADR, 0x00120000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S019)
        {
            Name (_SUN, 0x13)  // _SUN: Slot User Number
            Name (_ADR, 0x00130000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S020)
        {
            Name (_SUN, 0x14)  // _SUN: Slot User Number
            Name (_ADR, 0x00140000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S021)
        {
            Name (_SUN, 0x15)  // _SUN: Slot User Number
            Name (_ADR, 0x00150000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S022)
        {
            Name (_SUN, 0x16)  // _SUN: Slot User Number
            Name (_ADR, 0x00160000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S023)
        {
            Name (_SUN, 0x17)  // _SUN: Slot User Number
            Name (_ADR, 0x00170000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S024)
        {
            Name (_SUN, 0x18)  // _SUN: Slot User Number
            Name (_ADR, 0x00180000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S025)
        {
            Name (_SUN, 0x19)  // _SUN: Slot User Number
            Name (_ADR, 0x00190000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S026)
        {
            Name (_SUN, 0x1A)  // _SUN: Slot User Number
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S027)
        {
            Name (_SUN, 0x1B)  // _SUN: Slot User Number
            Name (_ADR, 0x001B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S028)
        {
            Name (_SUN, 0x1C)  // _SUN: Slot User Number
            Name (_ADR, 0x001C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S029)
        {
            Name (_SUN, 0x1D)  // _SUN: Slot User Number
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S030)
        {
            Name (_SUN, 0x1E)  // _SUN: Slot User Number
            Name (_ADR, 0x001E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S031)
        {
            Name (_SUN, 0x1F)  // _SUN: Slot User Number
            Name (_ADR, 0x001F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Method (DVNT, 2, Serialized)
        {
            Local0 = (Arg0 & One)
            If ((Local0 == One))
            {
                Notify (S000, Arg1)
            }

            Local0 = (Arg0 & 0x02)
            If ((Local0 == 0x02))
            {
                Notify (S001, Arg1)
            }

            Local0 = (Arg0 & 0x04)
            If ((Local0 == 0x04))
            {
                Notify (S002, Arg1)
            }

            Local0 = (Arg0 & 0x08)
            If ((Local0 == 0x08))
            {
                Notify (S003, Arg1)
            }

            Local0 = (Arg0 & 0x10)
            If ((Local0 == 0x10))
            {
                Notify (S004, Arg1)
            }

            Local0 = (Arg0 & 0x20)
            If ((Local0 == 0x20))
            {
                Notify (S005, Arg1)
            }

            Local0 = (Arg0 & 0x40)
            If ((Local0 == 0x40))
            {
                Notify (S006, Arg1)
            }

            Local0 = (Arg0 & 0x80)
            If ((Local0 == 0x80))
            {
                Notify (S007, Arg1)
            }

            Local0 = (Arg0 & 0x0100)
            If ((Local0 == 0x0100))
            {
                Notify (S008, Arg1)
            }

            Local0 = (Arg0 & 0x0200)
            If ((Local0 == 0x0200))
            {
                Notify (S009, Arg1)
            }

            Local0 = (Arg0 & 0x0400)
            If ((Local0 == 0x0400))
            {
                Notify (S010, Arg1)
            }

            Local0 = (Arg0 & 0x0800)
            If ((Local0 == 0x0800))
            {
                Notify (S011, Arg1)
            }

            Local0 = (Arg0 & 0x1000)
            If ((Local0 == 0x1000))
            {
                Notify (S012, Arg1)
            }

            Local0 = (Arg0 & 0x2000)
            If ((Local0 == 0x2000))
            {
                Notify (S013, Arg1)
            }

            Local0 = (Arg0 & 0x4000)
            If ((Local0 == 0x4000))
            {
                Notify (S014, Arg1)
            }

            Local0 = (Arg0 & 0x8000)
            If ((Local0 == 0x8000))
            {
                Notify (S015, Arg1)
            }

            Local0 = (Arg0 & 0x00010000)
            If ((Local0 == 0x00010000))
            {
                Notify (S016, Arg1)
            }

            Local0 = (Arg0 & 0x00020000)
            If ((Local0 == 0x00020000))
            {
                Notify (S017, Arg1)
            }

            Local0 = (Arg0 & 0x00040000)
            If ((Local0 == 0x00040000))
            {
                Notify (S018, Arg1)
            }

            Local0 = (Arg0 & 0x00080000)
            If ((Local0 == 0x00080000))
            {
                Notify (S019, Arg1)
            }

            Local0 = (Arg0 & 0x00100000)
            If ((Local0 == 0x00100000))
            {
                Notify (S020, Arg1)
            }

            Local0 = (Arg0 & 0x00200000)
            If ((Local0 == 0x00200000))
            {
                Notify (S021, Arg1)
            }

            Local0 = (Arg0 & 0x00400000)
            If ((Local0 == 0x00400000))
            {
                Notify (S022, Arg1)
            }

            Local0 = (Arg0 & 0x00800000)
            If ((Local0 == 0x00800000))
            {
                Notify (S023, Arg1)
            }

            Local0 = (Arg0 & 0x01000000)
            If ((Local0 == 0x01000000))
            {
                Notify (S024, Arg1)
            }

            Local0 = (Arg0 & 0x02000000)
            If ((Local0 == 0x02000000))
            {
                Notify (S025, Arg1)
            }

            Local0 = (Arg0 & 0x04000000)
            If ((Local0 == 0x04000000))
            {
                Notify (S026, Arg1)
            }

            Local0 = (Arg0 & 0x08000000)
            If ((Local0 == 0x08000000))
            {
                Notify (S027, Arg1)
            }

            Local0 = (Arg0 & 0x10000000)
            If ((Local0 == 0x10000000))
            {
                Notify (S028, Arg1)
            }

            Local0 = (Arg0 & 0x20000000)
            If ((Local0 == 0x20000000))
            {
                Notify (S029, Arg1)
            }

            Local0 = (Arg0 & 0x40000000)
            If ((Local0 == 0x40000000))
            {
                Notify (S030, Arg1)
            }

            Local0 = (Arg0 & 0x80000000)
            If ((Local0 == 0x80000000))
            {
                Notify (S031, Arg1)
            }
        }

        Method (PCNT, 0, Serialized)
        {
            Acquire (\_SB.PHPR.BLCK, 0xFFFF)
            \_SB.PHPR.PSEG = _SEG /* \_SB_.PC08._SEG */
            DVNT (\_SB.PHPR.PCIU, One)
            DVNT (\_SB.PHPR.PCID, 0x03)
            Release (\_SB.PHPR.BLCK)
        }

        Name (_PRT, Package (0x20)  // _PRT: PCI Routing Table
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0007FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0008FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0009FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x000AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x000BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x000CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x000DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x000EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x000FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0010FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0012FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0013FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0014FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0015FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0017FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0018FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }
        })
    }

    Device (_SB.PC09)
    {
        Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
        Name (_ADR, Zero)  // _ADR: Address
        Name (_SEG, 0x09)  // _SEG: PCI Segment
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CCA, One)  // _CCA: Cache Coherency Attribute
        Name (SUPP, Zero)
        Method (_PXM, 0, NotSerialized)  // _PXM: Device Proximity
        {
            Return (Zero)
        }

        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x21                                             // !
                    })
                }

                If ((Arg2 == 0x05))
                {
                    Return (Zero)
                }
            }

            Return (Buffer (One)
            {
                 0x00                                             // .
            })
        }

        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                0x0000,             // Granularity
                0x0000,             // Range Minimum
                0x0000,             // Range Maximum
                0x0000,             // Translation Offset
                0x0001,             // Length
                ,, )
            Memory32Fixed (ReadWrite,
                0xE8900000,         // Address Base
                0x00100000,         // Address Length
                )
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x0000010900000000, // Range Minimum
                0x00000109FFFFFFFF, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000100000000, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        Device (S000)
        {
            Name (_SUN, Zero)  // _SUN: Slot User Number
            Name (_ADR, Zero)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S001)
        {
            Name (_SUN, One)  // _SUN: Slot User Number
            Name (_ADR, 0x00010000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S002)
        {
            Name (_SUN, 0x02)  // _SUN: Slot User Number
            Name (_ADR, 0x00020000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S003)
        {
            Name (_SUN, 0x03)  // _SUN: Slot User Number
            Name (_ADR, 0x00030000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S004)
        {
            Name (_SUN, 0x04)  // _SUN: Slot User Number
            Name (_ADR, 0x00040000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S005)
        {
            Name (_SUN, 0x05)  // _SUN: Slot User Number
            Name (_ADR, 0x00050000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S006)
        {
            Name (_SUN, 0x06)  // _SUN: Slot User Number
            Name (_ADR, 0x00060000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S007)
        {
            Name (_SUN, 0x07)  // _SUN: Slot User Number
            Name (_ADR, 0x00070000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S008)
        {
            Name (_SUN, 0x08)  // _SUN: Slot User Number
            Name (_ADR, 0x00080000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S009)
        {
            Name (_SUN, 0x09)  // _SUN: Slot User Number
            Name (_ADR, 0x00090000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S010)
        {
            Name (_SUN, 0x0A)  // _SUN: Slot User Number
            Name (_ADR, 0x000A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S011)
        {
            Name (_SUN, 0x0B)  // _SUN: Slot User Number
            Name (_ADR, 0x000B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S012)
        {
            Name (_SUN, 0x0C)  // _SUN: Slot User Number
            Name (_ADR, 0x000C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S013)
        {
            Name (_SUN, 0x0D)  // _SUN: Slot User Number
            Name (_ADR, 0x000D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S014)
        {
            Name (_SUN, 0x0E)  // _SUN: Slot User Number
            Name (_ADR, 0x000E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S015)
        {
            Name (_SUN, 0x0F)  // _SUN: Slot User Number
            Name (_ADR, 0x000F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S016)
        {
            Name (_SUN, 0x10)  // _SUN: Slot User Number
            Name (_ADR, 0x00100000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S017)
        {
            Name (_SUN, 0x11)  // _SUN: Slot User Number
            Name (_ADR, 0x00110000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S018)
        {
            Name (_SUN, 0x12)  // _SUN: Slot User Number
            Name (_ADR, 0x00120000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S019)
        {
            Name (_SUN, 0x13)  // _SUN: Slot User Number
            Name (_ADR, 0x00130000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S020)
        {
            Name (_SUN, 0x14)  // _SUN: Slot User Number
            Name (_ADR, 0x00140000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S021)
        {
            Name (_SUN, 0x15)  // _SUN: Slot User Number
            Name (_ADR, 0x00150000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S022)
        {
            Name (_SUN, 0x16)  // _SUN: Slot User Number
            Name (_ADR, 0x00160000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S023)
        {
            Name (_SUN, 0x17)  // _SUN: Slot User Number
            Name (_ADR, 0x00170000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S024)
        {
            Name (_SUN, 0x18)  // _SUN: Slot User Number
            Name (_ADR, 0x00180000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S025)
        {
            Name (_SUN, 0x19)  // _SUN: Slot User Number
            Name (_ADR, 0x00190000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S026)
        {
            Name (_SUN, 0x1A)  // _SUN: Slot User Number
            Name (_ADR, 0x001A0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S027)
        {
            Name (_SUN, 0x1B)  // _SUN: Slot User Number
            Name (_ADR, 0x001B0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S028)
        {
            Name (_SUN, 0x1C)  // _SUN: Slot User Number
            Name (_ADR, 0x001C0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S029)
        {
            Name (_SUN, 0x1D)  // _SUN: Slot User Number
            Name (_ADR, 0x001D0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S030)
        {
            Name (_SUN, 0x1E)  // _SUN: Slot User Number
            Name (_ADR, 0x001E0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Device (S031)
        {
            Name (_SUN, 0x1F)  // _SUN: Slot User Number
            Name (_ADR, 0x001F0000)  // _ADR: Address
            Method (_EJ0, 1, Serialized)  // _EJx: Eject Device, x=0-9
            {
                \_SB.PHPR.PCEJ (_SUN, _SEG)
            }
        }

        Method (DVNT, 2, Serialized)
        {
            Local0 = (Arg0 & One)
            If ((Local0 == One))
            {
                Notify (S000, Arg1)
            }

            Local0 = (Arg0 & 0x02)
            If ((Local0 == 0x02))
            {
                Notify (S001, Arg1)
            }

            Local0 = (Arg0 & 0x04)
            If ((Local0 == 0x04))
            {
                Notify (S002, Arg1)
            }

            Local0 = (Arg0 & 0x08)
            If ((Local0 == 0x08))
            {
                Notify (S003, Arg1)
            }

            Local0 = (Arg0 & 0x10)
            If ((Local0 == 0x10))
            {
                Notify (S004, Arg1)
            }

            Local0 = (Arg0 & 0x20)
            If ((Local0 == 0x20))
            {
                Notify (S005, Arg1)
            }

            Local0 = (Arg0 & 0x40)
            If ((Local0 == 0x40))
            {
                Notify (S006, Arg1)
            }

            Local0 = (Arg0 & 0x80)
            If ((Local0 == 0x80))
            {
                Notify (S007, Arg1)
            }

            Local0 = (Arg0 & 0x0100)
            If ((Local0 == 0x0100))
            {
                Notify (S008, Arg1)
            }

            Local0 = (Arg0 & 0x0200)
            If ((Local0 == 0x0200))
            {
                Notify (S009, Arg1)
            }

            Local0 = (Arg0 & 0x0400)
            If ((Local0 == 0x0400))
            {
                Notify (S010, Arg1)
            }

            Local0 = (Arg0 & 0x0800)
            If ((Local0 == 0x0800))
            {
                Notify (S011, Arg1)
            }

            Local0 = (Arg0 & 0x1000)
            If ((Local0 == 0x1000))
            {
                Notify (S012, Arg1)
            }

            Local0 = (Arg0 & 0x2000)
            If ((Local0 == 0x2000))
            {
                Notify (S013, Arg1)
            }

            Local0 = (Arg0 & 0x4000)
            If ((Local0 == 0x4000))
            {
                Notify (S014, Arg1)
            }

            Local0 = (Arg0 & 0x8000)
            If ((Local0 == 0x8000))
            {
                Notify (S015, Arg1)
            }

            Local0 = (Arg0 & 0x00010000)
            If ((Local0 == 0x00010000))
            {
                Notify (S016, Arg1)
            }

            Local0 = (Arg0 & 0x00020000)
            If ((Local0 == 0x00020000))
            {
                Notify (S017, Arg1)
            }

            Local0 = (Arg0 & 0x00040000)
            If ((Local0 == 0x00040000))
            {
                Notify (S018, Arg1)
            }

            Local0 = (Arg0 & 0x00080000)
            If ((Local0 == 0x00080000))
            {
                Notify (S019, Arg1)
            }

            Local0 = (Arg0 & 0x00100000)
            If ((Local0 == 0x00100000))
            {
                Notify (S020, Arg1)
            }

            Local0 = (Arg0 & 0x00200000)
            If ((Local0 == 0x00200000))
            {
                Notify (S021, Arg1)
            }

            Local0 = (Arg0 & 0x00400000)
            If ((Local0 == 0x00400000))
            {
                Notify (S022, Arg1)
            }

            Local0 = (Arg0 & 0x00800000)
            If ((Local0 == 0x00800000))
            {
                Notify (S023, Arg1)
            }

            Local0 = (Arg0 & 0x01000000)
            If ((Local0 == 0x01000000))
            {
                Notify (S024, Arg1)
            }

            Local0 = (Arg0 & 0x02000000)
            If ((Local0 == 0x02000000))
            {
                Notify (S025, Arg1)
            }

            Local0 = (Arg0 & 0x04000000)
            If ((Local0 == 0x04000000))
            {
                Notify (S026, Arg1)
            }

            Local0 = (Arg0 & 0x08000000)
            If ((Local0 == 0x08000000))
            {
                Notify (S027, Arg1)
            }

            Local0 = (Arg0 & 0x10000000)
            If ((Local0 == 0x10000000))
            {
                Notify (S028, Arg1)
            }

            Local0 = (Arg0 & 0x20000000)
            If ((Local0 == 0x20000000))
            {
                Notify (S029, Arg1)
            }

            Local0 = (Arg0 & 0x40000000)
            If ((Local0 == 0x40000000))
            {
                Notify (S030, Arg1)
            }

            Local0 = (Arg0 & 0x80000000)
            If ((Local0 == 0x80000000))
            {
                Notify (S031, Arg1)
            }
        }

        Method (PCNT, 0, Serialized)
        {
            Acquire (\_SB.PHPR.BLCK, 0xFFFF)
            \_SB.PHPR.PSEG = _SEG /* \_SB_.PC09._SEG */
            DVNT (\_SB.PHPR.PCIU, One)
            DVNT (\_SB.PHPR.PCID, 0x03)
            Release (\_SB.PHPR.BLCK)
        }

        Name (_PRT, Package (0x20)  // _PRT: PCI Routing Table
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0005FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0006FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0007FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0008FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0009FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x000AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x000BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x000CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x000DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x000EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x000FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0010FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x0012FFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x0013FFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x0014FFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x0015FFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x0017FFFF, 
                Zero, 
                Zero, 
                0x0C
            }, 

            Package (0x04)
            {
                0x0018FFFF, 
                Zero, 
                Zero, 
                0x05
            }, 

            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x06
            }, 

            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x07
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x08
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x09
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x0A
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                Zero, 
                Zero, 
                0x0B
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x0C
            }
        })
    }

    Device (_SB.MBRD)
    {
        Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            Memory32Fixed (ReadWrite,
                0xE8000000,         // Address Base
                0x00100000,         // Address Length
                )
            Memory32Fixed (ReadWrite,
                0xE8100000,         // Address Base
                0x00100000,         // Address Length
                )
            Memory32Fixed (ReadWrite,
                0xE8200000,         // Address Base
                0x00100000,         // Address Length
                )
            Memory32Fixed (ReadWrite,
                0xE8300000,         // Address Base
                0x00100000,         // Address Length
                )
            Memory32Fixed (ReadWrite,
                0xE8400000,         // Address Base
                0x00100000,         // Address Length
                )
            Memory32Fixed (ReadWrite,
                0xE8500000,         // Address Base
                0x00100000,         // Address Length
                )
            Memory32Fixed (ReadWrite,
                0xE8600000,         // Address Base
                0x00100000,         // Address Length
                )
            Memory32Fixed (ReadWrite,
                0xE8700000,         // Address Base
                0x00100000,         // Address Length
                )
            Memory32Fixed (ReadWrite,
                0xE8800000,         // Address Base
                0x00100000,         // Address Length
                )
            Memory32Fixed (ReadWrite,
                0xE8900000,         // Address Base
                0x00100000,         // Address Length
                )
        })
    }

    Device (_SB.COM1)
    {
        Name (_HID, EisaId ("PNP0501") /* 16550A-compatible COM Serial Port */)  // _HID: Hardware ID
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_DDN, "COM1")  // _DDN: DOS Device Name
        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
            {
                0x00000004,
            }
            IO (Decode16,
                0x03F8,             // Range Minimum
                0x03F8,             // Range Maximum
                0x00,               // Alignment
                0x08,               // Length
                )
        })
    }

    Name (_S5, Package (0x01)  // _S5_: S5 System State
    {
        0x05
    })
    Device (_SB.PWRB)
    {
        Name (_HID, EisaId ("PNP0C0C") /* Power Button Device */)  // _HID: Hardware ID
        Name (_UID, Zero)  // _UID: Unique ID
    }

    Device (_SB.GEC)
    {
        Name (_HID, EisaId ("PNP0A06") /* Generic Container Device */)  // _HID: Hardware ID
        Name (_UID, "Generic Event Controller")  // _UID: Unique ID
        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x000007FFFFFED000, // Range Minimum
                0x000007FFFFFED000, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x0000000000000001, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        OperationRegion (GDST, SystemMemory, 0x000007FFFFFED000, One)
        Field (GDST, ByteAcc, NoLock, WriteAsZeros)
        {
            GDAT,   8
        }

        Method (ESCN, 0, Serialized)
        {
            Local0 = GDAT /* \_SB_.GEC_.GDAT */
            Local1 = (Local0 & One)
            If ((Local1 == One))
            {
                \_SB.CPUS.CSCN ()
            }

            Local1 = (Local0 & 0x02)
            If ((Local1 == 0x02))
            {
                \_SB.MHPC.MSCN ()
            }

            Local1 = (Local0 & 0x04)
            If ((Local1 == 0x04))
            {
                \_SB.PHPR.PSCN ()
            }

            Local1 = (Local0 & 0x08)
            If ((Local1 == 0x08))
            {
                Notify (\_SB.PWRB, 0x80) // Status Change
            }
        }
    }

    Device (_SB.GED)
    {
        Name (_HID, "ACPI0013" /* Generic Event Device */)  // _HID: Hardware ID
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
            {
                0x0000000D,
            }
        })
        Method (_EVT, 1, Serialized)  // _EVT: Event
        {
            \_SB.GEC.ESCN ()
        }
    }

    Device (_SB.PRES)
    {
        Name (_HID, EisaId ("PNP0A06") /* Generic Container Device */)  // _HID: Hardware ID
        Name (_UID, "CPU Hotplug Controller")  // _UID: Unique ID
        Mutex (CPLK, 0x00)
        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x0000000000000000, // Granularity
                0x000007FFFFFEE000, // Range Minimum
                0x000007FFFFFEE00B, // Range Maximum
                0x0000000000000000, // Translation Offset
                0x000000000000000C, // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        OperationRegion (PRST, SystemMemory, 0x000007FFFFFEE000, 0x0C)
        Field (PRST, ByteAcc, NoLock, WriteAsZeros)
        {
            Offset (0x04), 
            CPEN,   1, 
            CINS,   1, 
            CRMV,   1, 
            CEJ0,   1, 
            Offset (0x05), 
            CCMD,   8
        }

        Field (PRST, DWordAcc, NoLock, Preserve)
        {
            CSEL,   32, 
            Offset (0x08), 
            CDAT,   32
        }
    }

    Device (_SB.CPUS)
    {
        Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
        Name (_CID, EisaId ("PNP0A05") /* Generic Container Device */)  // _CID: Compatible ID
        Method (CSTA, 1, Serialized)
        {
            Acquire (\_SB.PRES.CPLK, 0xFFFF)
            \_SB.PRES.CSEL = Arg0
            Local0 = Zero
            If ((\_SB.PRES.CPEN == One))
            {
                Local0 = 0x0F
            }

            Release (\_SB.PRES.CPLK)
            Return (Local0)
        }

        Method (CTFY, 2, Serialized)
        {
            If ((Arg0 == Zero))
            {
                Notify (C000, Arg1)
            }

        }

        Method (CEJ0, 1, Serialized)
        {
            Acquire (\_SB.PRES.CPLK, 0xFFFF)
            \_SB.PRES.CSEL = Arg0
            \_SB.PRES.CEJ0 = One
            Release (\_SB.PRES.CPLK)
        }

        Method (CSCN, 0, Serialized)
        {
            Acquire (\_SB.PRES.CPLK, 0xFFFF)
            Local0 = Zero
            While ((Local0 < 0x01))
            {
                \_SB.PRES.CSEL = Local0
                If ((\_SB.PRES.CINS == One))
                {
                    CTFY (Local0, One)
                    \_SB.PRES.CINS = One
                }

                If ((\_SB.PRES.CRMV == One))
                {
                    CTFY (Local0, 0x03)
                    \_SB.PRES.CRMV = One
                }

                Local0 += One
            }

            Release (\_SB.PRES.CPLK)
        }

        Device (C000)
        {
            Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (CSTA (Zero))
            }

            Method (_PXM, 0, NotSerialized)  // _PXM: Device Proximity
            {
                Return (Zero)
            }

            Name (_MAT, Buffer (0x08)  // _MAT: Multiple APIC Table Entry
            {
                 0x00, 0x08, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00   // ........
            })
            Method (_EJ0, 1, NotSerialized)  // _EJx: Eject Device, x=0-9
            {
                CEJ0 (Zero)
            }
        }
    }

    Device (_SB.MHPC)
    {
        Name (_HID, EisaId ("PNP0A06") /* Generic Container Device */)  // _HID: Hardware ID
        Name (_UID, "Memory Hotplug Controller")  // _UID: Unique ID
        Method (MSCN, 0, Serialized)
        {
        }
    }
}

