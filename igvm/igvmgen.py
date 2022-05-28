import argparse
import sys
import logging
from enum import Enum

from igvm.bootcstruct import *
from igvm.igvmbzimage import IGVMLinuxGenerator
from igvm.igvmelf import IGVMELFGenerator
from igvm.igvmfile import IGVMFile
from igvm.vmstate import ARCH


class INFORM(Enum):
    bzImage = "bzImage"
    elf = "elf"


def str2bool(val):
    return val in ["true", "1", "True"]


def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]

    logging_argparse = argparse.ArgumentParser(add_help=False)
    logging_argparse.add_argument('-l', '--log-level', default='DEBUG',
                                  help='set log level')
    logging_args, _ = logging_argparse.parse_known_args(argv)

    logging.basicConfig(filename='igvm.log', filemode='w',
                        level=logging_args.log_level)
    parser = argparse.ArgumentParser(parents=[logging_argparse])
    parser.add_argument(
        '-d', type=argparse.FileType('rb'),
        metavar='igvmfile.bin', help='igvmfile for inspection')
    parser.add_argument(
        '-inform', type=INFORM, default=INFORM.bzImage, help='igvm input format', required=False)
    parser.add_argument(
        '-o', type=argparse.FileType('wb'),
        metavar='igvmfile.bin', help='igvmfile to output')
    parser.add_argument(
        '-kernel', type=argparse.FileType('rb'),
        help='Input image. bzImage or ELF depends on inform')
    parser.add_argument(
        '-symbol_elf', type=argparse.FileType('rb'), help='arch/x86/boot/compressed/vmlinux')
    parser.add_argument('-append', type=str, metavar='cmdline')
    parser.add_argument(
        '-rdinit', type=argparse.FileType('rb'),
        metavar='ramdisk')
    parser.add_argument('-vtl', type=int, metavar='2', default=2,
                        help='highest vtl')
    parser.add_argument('-config_file', type=str,
                        help='igvm config file', required=False)
    parser.add_argument(
        '-sign_key', type=argparse.FileType('rb'),
        help='private signing key', required=False)
    parser.add_argument(
        '-acpi_dir', type=str,
        help='ACPI folder', required=False)
    parser.add_argument(
        '-pvalidate_opt', type=str2bool, default=True,
        help='Pvalidate Optimization for fast booting (Check your kernel code to see whether the early boot code can pvalidate guest MEM on demand)')
    parser.add_argument(
        '-boot_mode', type=ARCH, default="x86", help='Boot mode (x86 or x64)')
    parser.add_argument(
        '-start_addr', type=int, default=0x1a00000, help="start gpa for the image")

    args = parser.parse_args(argv)

    if args.d:
        print(IGVMFile.dump(bytearray(args.d.read())))
    elif args.o:
        if args.inform == INFORM.bzImage:
            generator = IGVMLinuxGenerator(**vars(args))
        if args.inform == INFORM.elf:
            generator = IGVMELFGenerator(**vars(args))
        rawbytes = generator.generate()
        args.o.write(rawbytes)
    else:
        parser.print_help()


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except Exception:
        # return non-zero exit status in case of an unhandled exception
        sys.exit(1)
