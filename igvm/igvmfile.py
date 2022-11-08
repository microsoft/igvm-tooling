from ctypes import *
from cached_property import cached_property
from ecdsa import SigningKey, NIST384p
from hashlib import sha384
from typing import List, Dict, Tuple, Optional


from igvm.bootcstruct import *
from igvm.structure.igvmfileformat import IGVM_VHF_PAGE_DATA_GUEST_INVALID
from igvm.vmstate import VMState, PGSIZE, ARCH


# SUPPORTED_PLATFORM
PLAT_COMPAT_MASK = 0x1
PLAT_TYPE = 0x2
PLAT_VERSION = 0x1
PLAT_SHARED_GPA_BOUND = 0

SEV_SNP_ENABLE = (1 << 0)
SEV_RESTRICTED_INT = (1 << 3)
SEV_ALTERNATIVE_INT = (1 << 4)

SEV_FEATURE_DEFAULT = SEV_SNP_ENABLE | SEV_RESTRICTED_INT


def ALIGN(addr, alignment):
    return (addr + alignment - 1) & (~(alignment-1))


SNP_PAGE_INFO = struct_SNP_PAGE_INFO
SNP_ID_BLOCK = struct_SNP_ID_BLOCK
IGVM_VHS_SNP_ID_BLOCK_SIGNATURE = struct__IGVM_VHS_SNP_ID_BLOCK_SIGNATURE
IGVM_VHS_SNP_ID_BLOCK_PUBLIC_KEY = struct__IGVM_VHS_SNP_ID_BLOCK_PUBLIC_KEY

IGVM_HMAP = {
    IGVM_VHT_SUPPORTED_PLATFORM: IGVM_VHS_SUPPORTED_PLATFORM,
    IGVM_VHT_SNP_POLICY: IGVM_VHS_SNP_POLICY,
    IGVM_VHT_PARAMETER_AREA: IGVM_VHS_PARAMETER_AREA,
    IGVM_VHT_PAGE_DATA: IGVM_VHS_PAGE_DATA,
    IGVM_VHT_PARAMETER_INSERT: IGVM_VHS_PARAMETER_INSERT,
    IGVM_VHT_VP_CONTEXT: IGVM_VHS_VP_CONTEXT,
    IGVM_VHT_REQUIRED_MEMORY: IGVM_VHS_REQUIRED_MEMORY,
    # IGVM_VHT_SHARED_BOUNDARY_GPA: IGVM_VHS_SHARED_BOUNDARY_GPA,
    IGVM_VHT_VP_COUNT_PARAMETER: IGVM_VHS_PARAMETER,
    IGVM_VHT_SRAT: IGVM_VHS_PARAMETER,
    IGVM_VHT_MADT: IGVM_VHS_PARAMETER,
    IGVM_VHT_MMIO_RANGES: IGVM_VHS_MMIO_RANGES,
    IGVM_VHT_SNP_ID_BLOCK: IGVM_VHS_SNP_ID_BLOCK,
    IGVM_VHT_MEMORY_MAP: IGVM_VHS_PARAMETER,
    IGVM_VHT_ERROR_RANGE: IGVM_VHS_ERROR_RANGE,
    IGVM_VHT_COMMAND_LINE: IGVM_VHS_PARAMETER,
    #IGVM_VHT_HCL_SGX_RANGES: IGVM_VHS_PARAMETER
}

SNP_PAGE_TYPE_NORMAL = 1
SNP_PAGE_TYPE_VMSA = 2
SNP_PAGE_TYPE_ZERO = 3
SNP_PAGE_TYPE_UNMEASURED = 4
SNP_PAGE_TYPE_SECRETS = 5
SNP_PAGE_TYPE_CPUID = 6

CpuIdFunctionBasicMinimum = 0x00000000
CpuIdFunctionVendorAndMaxFunction = 0x00000000
CpuIdFunctionVersionAndFeatures = 0x00000001
CpuIdFunctionCacheAndTlbInformation = 0x00000002
CpuIdFunctionSerialNumber = 0x00000003
CpuIdFunctionCacheParameters = 0x00000004
CpuIdFunctionMonitorMwait = 0x00000005
CpuIdFunctionPowerManagement = 0x00000006
CpuIdFunctionExtendedFeatures = 0x00000007
CpuIdFunctionDirectCacheAccessParameters = 0x00000009
CpuIdFunctionPerformanceMonitoring = 0x0000000A
CpuIdFunctionExtendedTopologyEnumeration = 0x0000000B
CpuIdFunctionExtendedStateEnumeration = 0x0000000D
CpuIdFunctionRdtmEnumeration = 0x0000000F
CpuIdFunctionRdtaEnumeration = 0x00000010
CpuIdFunctionSgxEnumeration = 0x00000012
CpuIdFunctionIptEnumeration = 0x00000014
CpuIdFunctionCoreCrystalClockInformation = 0x00000015
CpuIdFunctionNativeModelId = 0x0000001A
CpuIdFunctionArchLbr = 0x0000001C
CpuIdFunctionTileInformation = 0x0000001D
CpuIdFunctionTmulInformation = 0x0000001E
CpuIdFunctionV2ExtendedTopologyEnumeration = 0x0000001F
CpuIdFunctionHistoryResetFeatures = 0x00000020
CpuIdFunctionBasicMaximum = 0x00000020
CpuIdFunctionIntelMaximum = 0x00000020
CpuIdFunctionAmdMaximum = 0x0000000D
CpuIdFunctionCompatBlueBasicMaximum = 0x0000000D
CpuIdFunctionGuestBasicMaximum = 0x0000001C
CpuIdFunctionUnimplementedMinimum = 0x40000000
CpuIdFunctionUnimplementedMaximum = 0x4FFFFFFF
CpuIdFunctionExtendedMinimum = 0x80000000
CpuIdFunctionExtendedMaxFunction = 0x80000000
CpuIdFunctionExtendedVersionAndFeatures = 0x80000001
CpuIdFunctionExtendedBrandingString1 = 0x80000002
CpuIdFunctionExtendedBrandingString2 = 0x80000003
CpuIdFunctionExtendedBrandingString3 = 0x80000004
CpuIdFunctionExtendedL1CacheParameters = 0x80000005
CpuIdFunctionExtendedL2CacheParameters = 0x80000006
CpuIdFunctionExtendedPowerManagement = 0x80000007
CpuIdFunctionExtendedAddressSpaceSizes = 0x80000008
CpuIdFunctionExtendedIntelMaximum = 0x80000008
CpuIdFunctionExtended80000009 = 0x80000009
CpuIdFunctionExtendedSvmVersionAndFeatures = 0x8000000A
CpuIdFunctionExtendedTlb1GBIdentifiers = 0x80000019
CpuIdFunctionExtendedOptimizationIdentifiers = 0x8000001A
CpuIdFunctionInstructionBasedSamplingProfiler = 0x8000001B
CpuIdFunctionLightweightProfilingCapabilities = 0x8000001C
CpuIdFunctionCacheTopologyDefinition = 0x8000001D
CpuIdFunctionProcessorTopologyDefinition = 0x8000001E
CpuIdFunctionExtendedSevFeatures = 0x8000001F
CpuIdFunctionExtendedFeatures2 = 0x80000021
CpuIdFunctionExtendedAmdMaximum = 0x80000021
CpuIdFunctionExtendedMaximum = 0x80000021


def dumps(struct: Structure):
    ans = ['{']
    for field_info in struct._fields_:
        field = getattr(struct, field_info[0])
        if isinstance(field, Structure) or isinstance(field, Union):
            ans.append('%s:' % (field_info[0]))
            ans.append(dumps(field))
        elif type(field) is int:
            ans.append('%s:%s' % (field_info[0], hex(field)))
        elif hasattr(field, '__getitem__'):
            ans.append('%s:%s' % (field_info[0], list(field)))
        else:
            ans.append('%s:%s' % (field_info[0], repr(field)))
    ans.append('}')
    return ' '.join(ans)


# For policy structure check table 20 in https://www.amd.com/system/files/TechDocs/56860.pdf
# SEV Secure Nested Paging Firmware ABI Specification
DEFAULT_POLICY = 0X20000
DEBUG_BIT_OFFSET = 19
MIGRATE_MA_BIT_OFFSET = 18
SMT_BIT_OFFSET = 16
ABI_MAJOR_OFFSET = 8
ABI_MINOR_OFFSET = 0
SNP_POLICY_ABI_MINOR = 0x1f
SNP_POLICY_ABI_MAJOR = 0x00
SNP_POLICY_VMPL_ENABLED = (0x1 << 17)
SNP_POLICY_BITS = SNP_POLICY_VMPL_ENABLED | (
    0x1 << SMT_BIT_OFFSET) | (
    SNP_POLICY_ABI_MAJOR << ABI_MAJOR_OFFSET) | (
    SNP_POLICY_ABI_MINOR << ABI_MINOR_OFFSET)


# sample json
# {
#     "tei_config_name" : "confidential_ml_cvm",
#     "tei_config_version"     : 1,
#     "tei_config_data" : {
#         "version"   : 1,
#         "guest_svn" : 2,
#         "family_id" : "12161A1B12161A1B12161A1B12161A1B",
#         "image_id"  : "1A1B12161A1B12161A1B12161A1B1216",
#         "policy":{
#             "debug_allowed" : false,
#             "migrate_ma"    : false,
#             "smt_allowed"   : true,
#             "abi_major"     : 0,
#             "abi_minor"     : 31
#         }
#     }
# }
class TEIConfig():
    def __init__(self, file_path=None):
        if not file_path:  # if no file provided return default values
            self.version = (c_uint32)(1)
            self.guest_svn = (c_uint32)(2)
            self.family_id = (c_uint8 * 16)(1)
            self.image_id = (c_uint8 * 16)(2)
            self.policy = SNP_POLICY_BITS
            return
        import json
        with open(file_path, 'r') as f:
            data = json.load(f)
        # validate config fields
        if not self.is_tei_config_valid(data):
            raise Exception(" not valid config data ")

        config_data = data['tei_config_data']
        self.version = (c_uint32)(
            config_data['version']
            if 'version' in config_data.keys() else 1)
        self.guest_svn = (c_uint32)(
            config_data['guest_svn']
            if 'guest_svn' in config_data.keys() else 2)
        if 'family_id' in config_data.keys():
            family_id_decimal = int(config_data['family_id'], 16)
            self.family_id = (
                c_uint8 * 16)(*list(family_id_decimal.to_bytes(16, 'big')))
        else:
            self.family_id = (c_uint8 * 16)(1)

        if 'image_id' in config_data.keys():
            image_id_decimal = int(config_data['image_id'], 16)
            self.image_id = (
                c_uint8 * 16)(*list(image_id_decimal.to_bytes(16, 'big')))
        else:
            self.image_id = (c_uint8 * 16)(2)

        if 'policy' in config_data.keys():
            self.policy = (c_uint64)(
                self.construct_policy(config_data['policy']))
        else:
            self.policy = SNP_POLICY_BITS

    # todo :: all the configuration validations can be added here
    def is_tei_config_valid(self, data):
        return True

    def construct_policy(self, policy_dictionary: Dict):
        policy = DEFAULT_POLICY
        if 'debug_allowed' in policy_dictionary.keys():
            policy = policy | policy_dictionary['debug_allowed'] << DEBUG_BIT_OFFSET
        if 'migrate_ma' in policy_dictionary.keys():
            policy = policy | policy_dictionary['migrate_ma'] << MIGRATE_MA_BIT_OFFSET
        if 'smt_allowed' in policy_dictionary.keys():
            policy = policy | policy_dictionary['smt_allowed'] << SMT_BIT_OFFSET
        if 'abi_major' in policy_dictionary.keys():
            policy = policy | policy_dictionary['abi_major'] << ABI_MAJOR_OFFSET
        if 'abi_minor' in policy_dictionary.keys():
            policy = policy | policy_dictionary['abi_minor'] << ABI_MINOR_OFFSET
        return policy

    def __repr__(self):
        repr = "\n============Config details================\n"
        repr += f'Version: {self.version} \n'
        repr += f'Guest SVN: {self.guest_svn} \n'
        repr += f'Family ID: {self.family_id} {cast(self.family_id, c_char_p).value} \n'
        repr += f'Image ID: {self.image_id}, {cast(self.image_id, c_char_p).value} \n'
        repr += f'Policy: {self.policy} hex: {hex(self.policy.value)}\n'
        repr += f'==========================================\n'
        return repr


class HV_PSP_CPUID_LEAF(Structure):
    _fields_ = [('EaxIn', c_uint32),
                ('EcxIn', c_uint32),
                ('XfemIn', c_uint64),
                ('XssIn', c_uint64),
                ('EaxOut', c_uint32),
                ('EbxOut', c_uint32),
                ('EcxOut', c_uint32),
                ('EdxOut', c_uint32),
                ('ReservedZ', c_uint64)]


class HV_PSP_CPUID_PAGE(Structure):
    _fields_ = [('Count', c_uint32),
                ('ReservedZ1', c_uint32),
                ('ReservedZ2', c_uint64),
                ('CpuidLeafInfo', HV_PSP_CPUID_LEAF * 64)]


class IGVMHeaders:
    _ZERO_DIGEST = sha384(b'\x00' * PGSIZE).digest()
    _MEASURED_PAGE_TYPES = [SNP_PAGE_TYPE_VMSA, SNP_PAGE_TYPE_NORMAL]

    def __init__(self, vtl: int, policy: int):
        self.curr_digest = b'\x00' * 48
        self.offset = 0
        self.headers = []
        self._add_fixed_header()
        self._add_variable_header(
            IGVM_VHT_SUPPORTED_PLATFORM, PLAT_COMPAT_MASK, vtl, PLAT_TYPE,
            PLAT_VERSION, PLAT_SHARED_GPA_BOUND)
        self._add_variable_header(
            IGVM_VHT_SNP_POLICY, policy, PLAT_COMPAT_MASK, 0)

    def _add_variable_header(self, header_type: int, *params):
        assert header_type in IGVM_HMAP
        header_class = IGVM_HMAP[header_type]
        header_size = sizeof(header_class())
        self.headers.append(IGVM_VHS_VARIABLE_HEADER(
            header_type, sizeof(header_class)))
        self.headers.append(header_class(*params))
        self.offset += ALIGN(sizeof(self.headers[-2]),
                             8) + ALIGN(sizeof(self.headers[-1]), 8)
        assert self.offset % 8 == 0

    def _add_fixed_header(self):
        self.headers.append(
            IGVM_FIXED_HEADER(
                IGVM_MAGIC_VALUE, 1, sizeof(IGVM_FIXED_HEADER),
                0, 0, 0))
        self.offset += ALIGN(sizeof(self.headers[-1]), 8)
        assert self.offset % 8 == 0

    def _add_page_data(
            self, gpa: int, file_offset: int, flags: int, data_type: int):
        self._add_variable_header(IGVM_VHT_PAGE_DATA, gpa,
                                  PLAT_COMPAT_MASK,
                                  file_offset, flags, data_type, 0)

    def add_vmsa_page(self, gpa: int, page: bytes):
        self._add_variable_header(IGVM_VHT_VP_CONTEXT, gpa, 1, 0xffffffff, 0)
        self._update_digest(gpa, page, SNP_PAGE_TYPE_VMSA)

    def add_param_page(self, gpa: int, page: bytes):
        self._add_variable_header(IGVM_VHT_PARAMETER_AREA, PGSIZE, 0, 0)
        # offset = 0
        self._add_variable_header(IGVM_VHT_VP_COUNT_PARAMETER, 0, 0)
        # offset = sizeof(IGVM_VHS_MEMORY_MAP_ENTRY)
        self._add_variable_header(
            IGVM_VHT_MEMORY_MAP, 0, sizeof(IGVM_VHS_MEMORY_MAP_ENTRY))
        self._add_variable_header(IGVM_VHT_PARAMETER_INSERT, gpa, 1, 0)
        self._update_digest(gpa, page, SNP_PAGE_TYPE_UNMEASURED)

    def add_cpuid_page(self, gpa: int, page: bytes):
        self._add_page_data(gpa=gpa,
                            file_offset=1,
                            flags=0,
                            data_type=IGVM_VHS_PAGE_DATA_TYPE_CPUID_DATA)
        self._update_digest(gpa, page, SNP_PAGE_TYPE_CPUID)

    def add_secret_page(self, gpa: int, page: bytes):
        self._add_page_data(gpa=gpa,
                            file_offset=0,
                            flags=0,
                            data_type=IGVM_VHS_PAGE_DATA_TYPE_SECRETS)
        self._update_digest(gpa, page, SNP_PAGE_TYPE_SECRETS)

    def add_measured_normal_page(self, gpa: int, page: bytes):
        self._add_page_data(gpa=gpa,
                            file_offset=any(page),
                            flags=0,
                            data_type=IGVM_VHS_PAGE_DATA_TYPE_NORMAL)
        self._update_digest(gpa, page, SNP_PAGE_TYPE_NORMAL)

    def add_unmeasured_normal_page(self, gpa: int, page: bytes):
        self._add_page_data(gpa=gpa,
                            file_offset=any(page),
                            flags=IGVM_VHF_PAGE_DATA_UNMEASURED,
                            data_type=IGVM_VHS_PAGE_DATA_TYPE_NORMAL)
        self._update_digest(gpa, page, SNP_PAGE_TYPE_UNMEASURED)

    def add_guest_invalid_normal_page(self, gpa: int, page: bytes):
        self._add_page_data(gpa=gpa,
                            file_offset=any(page),
                            flags=IGVM_VHF_PAGE_DATA_GUEST_INVALID,
                            data_type=IGVM_VHS_PAGE_DATA_TYPE_NORMAL)
        #self._update_digest(gpa, page, SNP_PAGE_TYPE_UNMEASURED)

    def add_id_block_raw(self, id_block: IGVM_VHS_SNP_ID_BLOCK):
        self._add_variable_header(IGVM_VHT_SNP_ID_BLOCK)
        assert sizeof(self.headers[-1]) == sizeof(id_block)
        self.headers[-1] = id_block

    def _update_digest(self, gpa: int, page: bytes, pagetype: int):
        digest = b'\x00' * 48
        assert(len(page) == PGSIZE)
        if pagetype in self._MEASURED_PAGE_TYPES:
            digest = sha384(page).digest() if any(page) else self._ZERO_DIGEST
        info = SNP_PAGE_INFO(
            (c_uint8 * 48)(*self.curr_digest),
            (c_uint8 * 48)(*digest),
            sizeof(SNP_PAGE_INFO),
            pagetype, 0, 0, gpa)
        self.curr_digest = sha384(bytes(info)).digest()

    def setup_file_offset(self):
        total_offset = self.offset
        self.headers[0].VariableHeaderSize = self.offset - \
            self.headers[0].VariableHeaderOffset
        for h in self.nonempty_page_header_iter():
            h.FileOffset = total_offset
            total_offset += PGSIZE
        self.headers[0].TotalFileSize = total_offset

    def nonempty_page_header_iter(self):
        for h in self.headers:
            if hasattr(h, 'GPA') and hasattr(h, 'FileOffset') and h.FileOffset:
                yield h

    def marshal(self) -> bytes:
        out = bytearray()
        for h in self.headers:
            size = sizeof(h)
            #IGVM parser assumes the header is aligned by 8
            aligned_size = ((size + 7) >> 3) << 3
            out.extend(bytes(h))
            out.extend(b'0'*(aligned_size-size))
        return out

    @staticmethod
    def dump(raw: bytes) -> None:
        header = IGVM_FIXED_HEADER.from_buffer_copy(raw, 0)
        ans = []
        ans.append(dumps(header))
        offset = header.VariableHeaderOffset
        while offset < header.VariableHeaderOffset + header.VariableHeaderSize:
            varheader = IGVM_VHS_VARIABLE_HEADER.from_buffer_copy(raw, offset)
            if varheader.Type in IGVM_HMAP:
                header_class = IGVM_HMAP[varheader.Type]
                header_name = IGVM_VARIABLE_HEADER_TYPES__enumvalues[varheader.Type]
                ans.append(
                    f'{header_name}({offset:02x})' +
                    dumps(
                        header_class.from_buffer_copy(
                            raw, offset + sizeof(varheader))))
            else:
                ans.append(dumps(varheader)+f'({offset:02x})')
            if varheader.Type == IGVM_VHT_VP_CONTEXT:
                context = IGVM_VHS_VP_CONTEXT.from_buffer_copy(
                    raw, offset + sizeof(varheader))
                vmsa = struct_vmcb_save_area.from_buffer_copy(
                    raw, context.FileOffset)
                ans.append(
                    f'IGVM_VHT_VP_CONTEXT({offset:02x})' + dumps(context) + dumps(vmsa))
            offset += sizeof(IGVM_VHS_VARIABLE_HEADER) + varheader.Length
            offset = (offset + 7) & ~7
        return "\n".join(ans)


class IGVMFile(VMState):
    @staticmethod
    def dump(raw):
        return IGVMHeaders.dump(raw)

    def __init__(self, boot_mode: ARCH, config_path: Optional[str], pem: Optional[bytes]):
        VMState.__init__(self, boot_mode)
        self.skipped_regions: List[Tuple] = []
        self._not_validated_regions: List[Tuple] = []
        self._config_path = config_path
        self._sign_key_pem = pem
        self._sign_key = None

    @cached_property
    def config(self) -> TEIConfig:
        if self._config_path:
            return TEIConfig(self._config_path)
        else:
            return TEIConfig()

    @cached_property
    def sign_key(self) -> SigningKey:
        if self._sign_key:
            return self._sign_key
        if self._sign_key_pem:
            self._sign_key = SigningKey.from_pem(
                self._sign_key_pem, hashfunc=sha384)
        else:
            self._sign_key = SigningKey.generate(
                curve=NIST384p, hashfunc=sha384)
        return self._sign_key

    @cached_property
    def cpuid_page(self) -> HV_PSP_CPUID_PAGE:
        cpuid_leaves = [(CpuIdFunctionExtendedSevFeatures, 0),
                        (CpuIdFunctionVendorAndMaxFunction, 0),
                        (CpuIdFunctionVersionAndFeatures, 0),
                        (CpuIdFunctionExtendedMaxFunction, 0),
                        (CpuIdFunctionCacheAndTlbInformation, 0),
                        (CpuIdFunctionMonitorMwait, 0),
                        (CpuIdFunctionPowerManagement, 0),
                        (CpuIdFunctionDirectCacheAccessParameters, 0),
                        (CpuIdFunctionPerformanceMonitoring, 0),
                        (CpuIdFunctionExtendedFeatures, 0),
                        (CpuIdFunctionCacheParameters, 0),
                        (CpuIdFunctionCacheParameters, 1),
                        (CpuIdFunctionCacheParameters, 2),
                        (CpuIdFunctionExtendedTopologyEnumeration, 0),
                        (CpuIdFunctionExtendedTopologyEnumeration, 1),
                        (CpuIdFunctionExtendedVersionAndFeatures, 0),
                        (CpuIdFunctionExtendedL1CacheParameters, 0),
                        (CpuIdFunctionExtendedL2CacheParameters, 0),
                        (CpuIdFunctionExtendedPowerManagement, 0),
                        (CpuIdFunctionExtendedAddressSpaceSizes, 0),
                        (CpuIdFunctionExtendedSvmVersionAndFeatures, 0),
                        (CpuIdFunctionProcessorTopologyDefinition, 0),
                        (CpuIdFunctionExtendedStateEnumeration, 0),
                        (CpuIdFunctionExtendedStateEnumeration, 1),
                        (CpuIdFunctionExtendedStateEnumeration, 2),
                        (CpuIdFunctionExtendedStateEnumeration, 3),
                        (CpuIdFunctionExtendedStateEnumeration, 4),
                        (CpuIdFunctionExtendedStateEnumeration, 5),
                        (CpuIdFunctionExtendedStateEnumeration, 6),
                        (CpuIdFunctionExtendedStateEnumeration, 7),
                        (CpuIdFunctionExtendedBrandingString1, 0),
                        (CpuIdFunctionExtendedBrandingString2, 0),
                        (CpuIdFunctionExtendedBrandingString3, 0),
                        (CpuIdFunctionCacheTopologyDefinition, 0),
                        (CpuIdFunctionCacheTopologyDefinition, 1),
                        (CpuIdFunctionCacheTopologyDefinition, 2),
                        (CpuIdFunctionCacheTopologyDefinition, 3)]
        cpuid_page = HV_PSP_CPUID_PAGE()
        for i in range(len(cpuid_leaves)):
            cpuid_page.Count += 1
            cpuid_page.CpuidLeafInfo[i].EaxIn = cpuid_leaves[i][0]
            cpuid_page.CpuidLeafInfo[i].EcxIn = cpuid_leaves[i][1]
            if cpuid_leaves[i][0] == CpuIdFunctionExtendedStateEnumeration:
                cpuid_page.CpuidLeafInfo[i].XfemIn = 1
        return cpuid_page

    def seek(self, addr: int):
        assert addr & ~(PGSIZE - 1) == addr
        end = self.memory.allocate(0)
        assert addr >= end
        if addr > end:
            self.skipped_regions.append((end, addr))
            self.memory.allocate(addr - end)

    def is_skipped(self, addr: int) -> bool:
        for (start, end) in self.skipped_regions:
            if start <= addr < end:
                return True
        return False

    def write_not_validated(self, addr: int, content: bytearray):
        self.memory.write(addr, content)
        end = addr + len(content)
        self._not_validated_regions.append((addr, end))
        print("write_not_validated %x %x" %(addr, end))

    def not_validated(self, addr: int) -> bool:
        for (start, end) in self._not_validated_regions:
            if start <= addr < end:
                return True
        return False

    def gen_vmsa(self) -> struct_vmcb_save_area:
        """Return SVM_VMSA page content"""
        self.vmsa.vmcb_save_area_0.vmcb_save_area_0_0.sev_feature_snp = 1
        self.vmsa.vmcb_save_area_0.vmcb_save_area_0_0.sev_feature_restrict_injection = 1
        self.vmsa.virtual_tom = 0x0
        self.vmsa.xcr0 = 0x1
        return self.vmsa

    def gen_id_block(self, digest: bytes) -> IGVM_VHS_SNP_ID_BLOCK:
        x = self.sign_key.verifying_key.pubkey.point.x()
        y = self.sign_key.verifying_key.pubkey.point.y()

        block = SNP_ID_BLOCK((c_uint8 * 48)(*digest),
                             self.config.family_id,
                             self.config.image_id,
                             self.config.version,
                             self.config.guest_svn,
                             self.config.policy)
        r, s = self.sign_key.sign(
            bytearray(block), sigencode=lambda r, s, o: (r, s))

        signature = IGVM_VHS_SNP_ID_BLOCK_SIGNATURE(
            (c_uint8 * 72)(*list(r.to_bytes(48, 'little'))),
            (c_uint8 * 72)(*list(s.to_bytes(48, 'little'))))
        public_key = IGVM_VHS_SNP_ID_BLOCK_PUBLIC_KEY(
            2, 0, (c_uint8 * 72)(*list(x.to_bytes(48, 'little'))),
            (c_uint8 * 72)(*list(y.to_bytes(48, 'little'))))
        id_block = IGVM_VHS_SNP_ID_BLOCK(
            1, 0, (c_uint8 * 3)(),
            block.Ld, block.FamilyId, block.ImageId, block.Version, block.
            GuestSvn, 1, 0, signature, public_key)
        return id_block

    def raw(self, vmsa_page: int, cpuid_page: int, secret_page: int,
            param_page: int, vtl: int):
        # fill in VMSA/SECRET/PARAM page
        assert not self.is_skipped(vmsa_page)
        assert not self.is_skipped(cpuid_page)
        assert not self.is_skipped(secret_page)
        assert not self.is_skipped(param_page)
        self.memory.write(vmsa_page, bytes(self.gen_vmsa()))
        self.memory.write(cpuid_page, bytes(self.cpuid_page))
        self.memory.write(secret_page, b'\x00' * PGSIZE)
        self.memory.write(param_page, b'\x00' * PGSIZE)

        end = self.memory.allocate(0, PGSIZE)
        igvm_headers = IGVMHeaders(vtl, self.config.policy)
        # Add all guest page info to headers.
        for gpa in range(0, end, PGSIZE):
            page = self.memory.read(gpa, PGSIZE)
            if gpa == vmsa_page:
                igvm_headers.add_vmsa_page(gpa, page)
            elif gpa == param_page:
                igvm_headers.add_param_page(gpa, page)
            elif gpa == cpuid_page:
                igvm_headers.add_cpuid_page(gpa, page)
            elif gpa == secret_page:
                igvm_headers.add_secret_page(gpa, page)
            elif not self.is_skipped(gpa):
                if self.not_validated(gpa):
                    igvm_headers.add_guest_invalid_normal_page(gpa, page)
                else:
                    igvm_headers.add_measured_normal_page(gpa, page)
            else:
                assert not any(page)
                continue
        igvm_headers.add_id_block_raw(
            self.gen_id_block(igvm_headers.curr_digest))
        igvm_headers.setup_file_offset()
        # Assemble the IGVM file
        body = bytearray()
        for h in igvm_headers.nonempty_page_header_iter():
            body.extend(self.memory[h.GPA:h.GPA + PGSIZE])
        return igvm_headers.marshal() + body
