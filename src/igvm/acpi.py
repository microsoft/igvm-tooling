import argparse
import base64
import cstruct
import logging
import os
import pickle
import subprocess
import zlib
from typing import Dict, List


ACPI_RSDP_ADDR = 0xe0000
ACPI_END_ADDR = 0x200000
DEFAULT_ACPI_FILE = os.path.join(os.path.dirname(__file__), "acpi", "acpi.zip")
PGSIZE = 4096
IASL_TOOL = "iasl"


class ACPITableHeader(cstruct.CStruct):
    __byte_order__ = cstruct.LITTLE_ENDIAN
    __def__ = """
   struct acpi_table_header {
        char signature[4];	/* ASCII table signature */
        uint32 length;		/* Length of table in bytes */
        uint8 revision;		/* ACPI Specification minor version number */
        uint8 checksum;		/* To make sum of entire table == 0 */
        char oem_id[6];	/* ASCII OEM identification */
        char oem_table_id[8];	/* ASCII OEM table identification */
        uint32 oem_revision;	/* OEM revision number */
        char asl_compiler_id[4];	/* ASCII ASL compiler vendor ID */
        uint32 asl_compiler_revision;	/* ASL compiler version */
    }
    """


class RSDPTable(cstruct.CStruct):
    __byte_order__ = cstruct.LITTLE_ENDIAN
    __def__ = """
    struct acpi_table_rsdp {
        char signature[8];	/* ACPI signature, contains "RSD PTR " */
        uint8 checksum;		/* ACPI 1.0 checksum */
        char oem_id[6];	/* OEM identification */
        uint8 revision;		/* Must be (0) for ACPI 1.0 or (2) for ACPI 2.0+ */
        uint32 rsdt_physical_address;	/* 32-bit physical address of the RSDT */
        uint32 length;		/* Table length in bytes, including header (ACPI 2.0+) */
        uint64 xsdt_physical_address;	/* 64-bit physical address of the XSDT (ACPI 2.0+) */
        uint8 extended_checksum;	/* Checksum of entire table (ACPI 2.0+) */
        uint8 reserved[3];		/* Reserved, must be zero */
    };
    """


ACPI_XSDT_ENTRY_SIZE = 8

ACPI_TABLE_STRUCTS = {
    "XSDT": ACPITableHeader,
    "FACP": ACPITableHeader,
    "FACS": ACPITableHeader,
    "APIC": ACPITableHeader,
    "DSDT": ACPITableHeader,
    "OEM0": ACPITableHeader,
    "RSD ": RSDPTable,
}


def convert2pages(data_map):
    sorted_addr = list(data_map.keys())
    page_map = {}
    sorted_addr.sort()
    assert(sorted_addr[0] % PGSIZE == 0)
    data_index = 0
    gpa = sorted_addr[0]
    addr = sorted_addr[0]
    page_map[gpa] = bytes(0)
    offset = 0
    while data_index < len(sorted_addr):
        addr = sorted_addr[data_index]
        gpa = int((addr+offset)/PGSIZE) * PGSIZE
        if(gpa not in page_map):
            page_map[gpa] = bytes(0)
        remain = PGSIZE - len(page_map[gpa])
        page_map[gpa] += data_map[addr][offset:offset+remain]
        if len(page_map[gpa]) == PGSIZE:
            offset += remain
        else:
            offset = 0
            data_index = data_index+1
    if len(page_map[gpa]) < PGSIZE:
        page_map[gpa] += bytes(PGSIZE-len(page_map[gpa]))
    return page_map


class ACPIUpdate:

    def __init__(self, name: str, addr: int, dslpath: str, amldata: bytes,
                 length: int):
        self.updates: Dict[str, str] = {}
        self.appends: List[str] = []
        self.name: str = name
        self.addr: int = addr
        self.dslpath: str = dslpath
        self.length: int = length
        self.amldata: bytes = amldata

    def update_dsl(self):
        if len(self.updates) + len(self.appends) == 0:
            return
        newdir = os.path.dirname(self.dslpath) + "-new"
        if not os.path.exists(newdir):
            os.mkdir(newdir)
        newdsl = os.path.join(newdir, os.path.basename(self.dslpath))
        newaml = newdsl.replace("dsl", "aml")
        data = ""
        with open(self.dslpath, "r") as f:
            data = f.read()
        for old in self.updates:
            new = self.updates[old]
            data = data.replace(old, new)
        data += "\n"+"\n".join(self.appends)
        with open(newdsl, "w+") as f:
            f.write(data)
        subprocess.call(
            [IASL_TOOL, "-f", newdsl],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        with open(newaml, "rb") as f:
            self.amldata = f.read()


class ACPI:
    rsdp_addr = 0xe0000
    start_addr = 0xe0000
    end_addr = 0x200000
    xsdt_addr = 0x100000
    TOP_TABLES = ['XSDT', 'RSD_']
    XSDT_SUB_TABLES = ["FACP", "OEM0", "APIC", "TPM2", "TCPA"]
    FACP_SUB_TABLES = ['DSDT', 'FACS']
    SUB_TABLES = FACP_SUB_TABLES + XSDT_SUB_TABLES
    VALID_TABLES = TOP_TABLES + SUB_TABLES

    def default_acpi(self):
        with open(DEFAULT_ACPI_FILE, "rb") as f:
            data = f.read()
        acpi = pickle.loads(zlib.decompress(base64.b64decode(data)))
        assert(self.rsdp_addr in acpi)
        for gpa in acpi:
            assert(gpa < self.end_addr)
            assert(gpa >= self.rsdp_addr)
        return acpi

    def __init__(self, acpi_dir):
        self.acpi: Dict[int, bytes] = {}
        try:
            subprocess.check_output(["which", IASL_TOOL])
        except:
            raise Exception("Install `iasl` via `apt install acpica-tools`")
        if not acpi_dir:
            self.acpi = self.default_acpi()
        else:
            self.from_dir(acpi_dir)

    def from_dir(self, acpi_dir):
        files = os.listdir(acpi_dir)
        acpi_table = ACPITableHeader()
        rsdp = RSDPTable()
        xsdt = ACPITableHeader()
        tables = {}
        acpi = {}
        acpi_updates: Dict[ACPIUpdate] = {}
        aml_file = ""
        addr = 0
        for file in files:
            if file.endswith(".dsl"):
                file = os.path.join(acpi_dir, file)
                aml_file = file.replace("dsl", "aml")
                subprocess.call([IASL_TOOL, "-f", file],
                                stdout=subprocess.DEVNULL,
                                stderr=subprocess.DEVNULL)
            else:
                continue
            with open(aml_file, "rb") as f:
                data = f.read()
            acpi_table.unpack(data)
            name = acpi_table.signature.decode(
                "utf-8", "ignore").replace(" ", "_")
            assert (name in self.VALID_TABLES)
            if name.startswith("RSD"):
                rsdp.unpack(data)
                if(not rsdp.xsdt_physical_address):
                    rsdp.xsdt_physical_address = self.xsdt_addr
                    rsdp.rsdt_physical_address = self.xsdt_addr
                self.xsdt_addr = rsdp.xsdt_physical_address
                acpi[self.rsdp_addr] = rsdp.pack()
                addr = self.rsdp_addr
            elif name.startswith('XSDT'):
                addr = self.xsdt_addr
            elif name in self.SUB_TABLES:
                assert(acpi_table.length == len(data))

            acpi_updates[name] = ACPIUpdate(
                name=name, addr=addr, dslpath=file, amldata=data,
                length=acpi_table.length)

        addr = self.xsdt_addr + 0x1000
        nentries = 0
        table_names = sorted(acpi_updates.keys())

        # Assign start address to each table
        for name in table_names:
            if name in self.TOP_TABLES:
                continue
            if name in self.SUB_TABLES:
                acpi_updates[name].addr = addr
                addr += acpi_updates[name].length
                nentries += 1

        # Add FACP_SUB_TABLES
        for name in self.FACP_SUB_TABLES:
            old = f"{name} Address : 0"
            new = f"{name} Address : {hex(acpi_updates[name].addr)}"
            logging.info("replace %s %s" % (old, new))
            acpi_updates["FACP"].updates[old] = new

        tab_idx = 0
        width = 8
        offset = ACPITableHeader.size
        # Add XSDT_SUB_TABLES
        for name in table_names:
            if name not in self.XSDT_SUB_TABLES:
                continue
            addr = acpi_updates[name].addr
            assert "XSDT" in acpi_updates
            acpi_updates["XSDT"].appends.append(
                "[%xh %d  %d]\tACPI Table Address %d : %lx" %
                (offset, offset, width, tab_idx, addr))
            tab_idx += 1
            offset += width

        # Update Tables
        for name in table_names:
            acpi_update = acpi_updates[name]
            acpi_update.update_dsl()
            acpi[acpi_update.addr] = acpi_update.amldata
            logging.info("table[%s] %x" % (name, acpi_update.addr))

        self.acpi = convert2pages(acpi)
        sorted_gpa = list(self.acpi.keys())
        sorted_gpa.sort()
        self.start_addr = sorted_gpa[0]
        self.end_addr = sorted_gpa[-1] + PGSIZE


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-dir', type=str,
        metavar='acpi_infolder', help='acpi_infolder')
    args = parser.parse_args()
    acpi = ACPI(args.dir)
