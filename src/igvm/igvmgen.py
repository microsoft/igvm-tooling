import argparse
import sys
import json
import logging

from distutils.log import INFO
from enum import Enum
from frozendict import frozendict

from igvm.bootcstruct import *
from igvm.igvmbzimage import IGVMLinuxGenerator, IGVMLinux2Generator
from igvm.igvmelf import IGVMELFGenerator
from igvm.igvmfile import IGVMFile
from igvm.vmstate import ARCH, Arch


class INFORM(Enum):
    bzImage = "bzImage"
    elf = "elf"
    bzImage2 = "bzImage2"


Generators = frozendict({INFORM.bzImage: IGVMLinuxGenerator,
                         INFORM.bzImage2: IGVMLinux2Generator,
                         INFORM.elf: IGVMELFGenerator, })


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
        '-arch', type=Arch, default=Arch.Intel, help='hardware architecture', required=False)
    parser.add_argument(
        '-o', type=argparse.FileType('wb'),
        metavar='igvmfile.bin', help='igvmfile to output')
    parser.add_argument(
        '-kernel', type=argparse.FileType('rb'),
        help='Input image. bzImage or ELF depends on inform')
    parser.add_argument(
        '-vmpl2_kernel', type=argparse.FileType('rb'),
        help='Input image. bzImage or ELF depends on inform')
    parser.add_argument(
        '-pgtable_level', type=int,
        help='2-level or 4-level paging')
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
    parser.add_argument(
        '-shared_payload', type=argparse.FileType('rb'), help="content to be populated to guest-invalid memory(shared between hypervisor and guest), skipping expensive PSP commands")
    parser.add_argument(
        '-measurement_file', type=argparse.FileType("w"), help="measurement file", required=False)

    args = parser.parse_args(argv)

    if args.d:
        print(IGVMFile.dump(bytearray(args.d.read())))
    elif args.o:
        assert args.inform in Generators
        generator = Generators[args.inform](**vars(args))
        rawbytes, measurement = generator.generate()
        args.o.write(rawbytes)
        if args.measurement_file:
             with args.measurement_file as f:
                info = {"sevsnpvm-launchmeasurement": measurement}
                print(info)
                json.dump(info, f, indent=2)
    else:
        parser.print_help()


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except Exception:
        # return non-zero exit status in case of an unhandled exception
        sys.exit(1)
