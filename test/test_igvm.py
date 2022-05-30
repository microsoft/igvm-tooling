import unittest
from unittest.mock import MagicMock, patch
from igvm.vmstate import ARCH
import tracemalloc


TEST_ACPI = "igvm/acpi/acpi-test"


class IgvmGenTest(unittest.TestCase):
    def setUp(self) -> None:
        super().setUp()
        self.maxDiff = None
        self.patcher = patch('ecdsa.SigningKey')
        self.MockedSigningKey = self.patcher.start()
        tracemalloc.start()

        class mockObj(bytes):
            def to_bytes(self, x, y):
                return self
        self.MockedSigningKey.sign = MagicMock(
            return_value=[mockObj(48), mockObj(48)])
        self.MockedSigningKey.generate = MagicMock(
            return_value=self.MockedSigningKey)
        self.MockedSigningKey.from_pem = MagicMock(
            return_value=self.MockedSigningKey)
        self.MockedSigningKey.verifying_key.pubkey.point.x = MagicMock(
            return_value=mockObj(
                48))
        self.MockedSigningKey.verifying_key.pubkey.point.y = MagicMock(
            return_value=mockObj(
                48))

    def tearDown(self) -> None:
        self.patcher.stop()
        return super().tearDown()

    def assertEqualDump(self, got_binary: str, expected_dump: str):
        from igvm.igvmfile import IGVMFile
        dump = IGVMFile.dump(got_binary)
        self.assertEqual(dump, expected_dump)

    def testHash(self):
        from hashlib import sha384
        zero = sha384(b'\x00' * 0x1000).digest()
        self.assertEqual(
            zero, b'\xc0\xe5\x9a>?\xfb\xd3\xb5\xc7T(\xfb6C/\xac\xab\xc7E\x94B\x96\xffQ_s|O\xefN\xfcdXh\t\xf7\xa1oV5J\x1e\xae\xcf*\xa8\xd7t')

    def testBzImage(self):
        from igvm.igvmbzimage import IGVMLinuxGenerator
        with open("test/tests/test_bzImage", "rb") as infile:
            PARAMS = {
                "pvalidate_opt": True,
                "append": "panic=-1 console=ttySEV0",
                "symbol_elf": "",
                "vtl": 2,
                "acpi_dir": TEST_ACPI,
                "boot_mode": ARCH.X86,
                "sign_key": None,
                "kernel": infile,
            }
            generator = IGVMLinuxGenerator(**PARAMS)
            rawbytes = generator.generate()

        with open("test/tests/test_bzImage.dump", "r") as f:
            expected_dump = f.read()
            self.assertEqualDump(bytes(rawbytes), expected_dump)

    def testBzImage64(self):
        from igvm.igvmbzimage import IGVMLinuxGenerator
        with open("test/tests/test_bzImage", "rb") as infile:
            PARAMS = {
                "pvalidate_opt": True,
                "append": "panic=-1 console=ttySEV0",
                "symbol_elf": "",
                "vtl": 2,
                "boot_mode": ARCH.X64,
                "sign_key": None,
                "kernel": infile,
            }
            generator = IGVMLinuxGenerator(**PARAMS)
            rawbytes = generator.generate()

        with open("test/tests/test_bzImage_x64.dump", "r") as f:
            expected_dump = f.read()
            self.assertEqualDump(bytes(rawbytes), expected_dump)

    def testBzImageNoOpt(self):
        from igvm.igvmbzimage import IGVMLinuxGenerator
        with open("test/tests/test_bzImage", "rb") as infile:
            PARAMS = {
                "pvalidate_opt": False,
                "append": "panic=-1 console=ttySEV0",
                "symbol_elf": "",
                "vtl": 2,
                "acpi_dir": TEST_ACPI,
                "boot_mode": ARCH.X86,
                "sign_key": None,
                "kernel": infile,
            }
            generator = IGVMLinuxGenerator(**PARAMS)
            rawbytes = generator.generate()

        with open("test/tests/test_bzImage_noopt.dump", "r") as f:
            expected_dump = f.read()
            self.assertEqualDump(bytes(rawbytes), expected_dump)

    def testElf(self):
        from igvm.igvmelf import IGVMELFGenerator
        with open("test/tests/test_elf", "rb") as infile:
            PARAMS = {
                "pvalidate_opt": False,
                "append": "append",
                "symbol_elf": "",
                "vtl": 2,
                "acpi_dir": None,
                "boot_mode": ARCH.X86,
                "sign_key": None,
                "kernel": infile,
                "start_addr": 0x1a00000
            }
            generator = IGVMELFGenerator(**PARAMS)
            rawbytes = generator.generate()
            infile.close()
        with open("test/tests/test_elf.dump", "r") as f:
            expected_dump = f.read()
            self.assertEqualDump(bytes(rawbytes), expected_dump)


if __name__ == '__main__':
    unittest.main()
