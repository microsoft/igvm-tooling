# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.

""" Convert C data structure to Python """

import os
import importlib
from typing import Sequence


DIR_PATH = os.path.abspath(os.path.dirname(__file__))
OUT_DIR = os.path.join(DIR_PATH, "structure")
#LINUX_DIR = os.path.join(DIR_PATH, "../snplinux")
LINUX_DIR = "/home/mchamarthy/work/LSG-linux-rolling"
MONITOR_DIR = os.path.join(DIR_PATH, "../../snp-sm")
WIN_OS_DIR = os.path.join(DIR_PATH, "../os/src")
WIN_SDK_DIR = "/mnt/c/"
INCLUDE_DIRS = ("arch/x86/include", "include", "include/asm-generic", "")
BOOT_SOURCES = ("arch/x86/include/uapi/asm/bootparam.h",
                "arch/x86/include/asm/e820/types.h",
                "arch/x86/include/asm/svm.h",
                "arch/x86/include/asm/desc_defs.h",
                "arch/x86/include/asm/segment.h",
                "include/acpi/acpi.h",
                "include/asm-generic/rwonce.h",
                "arch/x86/include/asm/sev.h")

LINUX_SYMBOLS = ("e820_type", "struct_vmcb_save_area", "struct_boot_params", "struct_cc_blob_sev_info",
                 "struct_desc_struct", "struct_acpi_table_rsdp", "struct_acpi_table_header")

MONITOR_SOURCES = ("monitor/include/monitor.h",)

# igvmfileformat from windows os repo.
# onecore/vm/common/guestloader/inc/IgvmFileFormat.h + SNP_PAGE related struct
IGVMFMT_SOURCES = ("onecore/vm/common/guestloader/inc/IgvmFileFormat.h",)


def _load_struct_from_c(src_dir: str, cpath: Sequence[str], pypath: str, symbols: Sequence = []):
    try:
        from ctypeslib.codegen.codegenerator import translate_files
        from ctypeslib.codegen import config
    except ImportError:
        raise ImportError("Install ctypeslib via `pip install ctypeslib2`")
    bootparam_path = os.path.join(OUT_DIR, pypath)
    cfg = config.CodegenConfig()
    # only extract enum and struct
    cfg._init_types('estmd')
    cfg.symbols = symbols
    for include_dir in INCLUDE_DIRS:
        include_dir = os.path.join(src_dir, include_dir)
        cfg.clang_opts.append(f"-I{include_dir}")
        cfg.clang_opts.append("-DC_ASSERT(x)=")
        cfg.clang_opts.append("-D__packed=")
        cfg.clang_opts.append("-Du32=uint32_t")
        cfg.clang_opts.append("-DUINT32=int")
        cfg.clang_opts.append("-DUINT64=long")
        cfg.clang_opts.append("-DUINT16=short")
        cfg.clang_opts.append("-DUINT8=char")
        cfg.clang_opts.append("-D__no_sanitize_or_inline=")
        cfg.clang_opts.append("-D__no_kasan_or_inline=")
        cfg.clang_opts.append("-D__attribute_const__=")
        cfg.clang_opts.append("-Dpgd_t=int")
        cfg.clang_opts.append("-D__init=")

    srcs = [os.path.join(src_dir, source) for source in cpath]
    with open(bootparam_path, 'w') as f:
        translate_files(srcs, f, cfg)
    spec = importlib.util.spec_from_file_location(
        bootparam_path, bootparam_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def install_linuxboot_struct():
    return _load_struct_from_c(LINUX_DIR, BOOT_SOURCES, "linuxboot.py", LINUX_SYMBOLS)

def install_monitor_struct():
    return _load_struct_from_c(MONITOR_DIR, MONITOR_SOURCES, "monitor.py", symbols=[])


def install_igvmfileformat_struct():
    return _load_struct_from_c(WIN_OS_DIR, IGVMFMT_SOURCES, "igvmfileformat.py", symbols=[])


try:
    from igvm.structure.linuxboot import *
except ImportError:
    if install_linuxboot_struct():
        from igvm.structure.linuxboot import *
    else:
        raise ImportError("Cannot find cstructs for bootparam")

try:
    from igvm.structure.igvmfileformat import *
except ImportError:
    if install_igvmfileformat_struct():
        from igvm.structure.igvmfileformat import *
    else:
        raise ImportError("Cannot find cstructs for bootparam")

try:
    from igvm.structure.monitor import *
except ImportError:
    if install_monitor_struct():
        from igvm.structure.monitor import *
    else:
        raise ImportError("Cannot find cstructs for bootparam")
