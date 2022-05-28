class Symbol:
    addr: int
    size: int

    def __init__(self, addr: int, size: int):
        self.addr = addr
        self.size = size


class ELFObj(object):
    def __init__(self, f):
        try:
            import elftools.elf.elffile as elffile
        except ImportError:
            raise ImportError("Install elftools via `pip install pyelftools`")
        self.elf = elffile.ELFFile(f)
        self._sym_table = self.elf.get_section_by_name(".symtab")

    def get_symbol(self, name):
        syms = self._sym_table.get_symbol_by_name(name)
        assert(len(syms) == 1)
        return Symbol(syms[0].entry.st_value, syms[0].entry.st_size)
