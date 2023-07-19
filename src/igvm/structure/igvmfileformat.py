# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.

# -*- coding: utf-8 -*-
#
# TARGET arch is: ['-I/root/cvm/linux/arch/x86/include', '-DC_ASSERT(x)=', '-I/root/cvm/linux/include', '-DC_ASSERT(x)=', '-I/root/cvm/linux/', '-DC_ASSERT(x)=']
# WORD_SIZE is: 8
# POINTER_SIZE is: 8
# LONGDOUBLE_SIZE is: 16
#
import ctypes


class AsDictMixin:
    @classmethod
    def as_dict(cls, self):
        result = {}
        if not isinstance(self, AsDictMixin):
            # not a structure, assume it's already a python object
            return self
        if not hasattr(cls, "_fields_"):
            return result
        # sys.version_info >= (3, 5)
        # for (field, *_) in cls._fields_:  # noqa
        for field_tuple in cls._fields_:  # noqa
            field = field_tuple[0]
            if field.startswith('PADDING_'):
                continue
            value = getattr(self, field)
            type_ = type(value)
            if hasattr(value, "_length_") and hasattr(value, "_type_"):
                # array
                if not hasattr(type_, "as_dict"):
                    value = [v for v in value]
                else:
                    type_ = type_._type_
                    value = [type_.as_dict(v) for v in value]
            elif hasattr(value, "contents") and hasattr(value, "_type_"):
                # pointer
                try:
                    if not hasattr(type_, "as_dict"):
                        value = value.contents
                    else:
                        type_ = type_._type_
                        value = type_.as_dict(value.contents)
                except ValueError:
                    # nullptr
                    value = None
            elif isinstance(value, AsDictMixin):
                # other structure
                value = type_.as_dict(value)
            result[field] = value
        return result


class Structure(ctypes.Structure, AsDictMixin):

    def __init__(self, *args, **kwds):
        # We don't want to use positional arguments fill PADDING_* fields

        args = dict(zip(self.__class__._field_names_(), args))
        args.update(kwds)
        super(Structure, self).__init__(**args)

    @classmethod
    def _field_names_(cls):
        if hasattr(cls, '_fields_'):
            return (f[0] for f in cls._fields_ if not f[0].startswith('PADDING'))
        else:
            return ()

    @classmethod
    def get_type(cls, field):
        for f in cls._fields_:
            if f[0] == field:
                return f[1]
        return None

    @classmethod
    def bind(cls, bound_fields):
        fields = {}
        for name, type_ in cls._fields_:
            if hasattr(type_, "restype"):
                if name in bound_fields:
                    if bound_fields[name] is None:
                        fields[name] = type_()
                    else:
                        # use a closure to capture the callback from the loop scope
                        fields[name] = (
                            type_((lambda callback: lambda *args: callback(*args))(
                                bound_fields[name]))
                        )
                    del bound_fields[name]
                else:
                    # default callback implementation (does nothing)
                    try:
                        default_ = type_(0).restype().value
                    except TypeError:
                        default_ = None
                    fields[name] = type_((
                        lambda default_: lambda *args: default_)(default_))
            else:
                # not a callback function, use default initialization
                if name in bound_fields:
                    fields[name] = bound_fields[name]
                    del bound_fields[name]
                else:
                    fields[name] = type_()
        if len(bound_fields) != 0:
            raise ValueError(
                "Cannot bind the following unknown callback(s) {}.{}".format(
                    cls.__name__, bound_fields.keys()
            ))
        return cls(**fields)


class Union(ctypes.Union, AsDictMixin):
    pass





# UINT8 = unsigned char # macro
# UINT16 = unsigned short # macro
# UINT32 = unsigned int # macro
# UINT64 = unsigned long long # macro
# uint8_t = unsigned char # macro
# uint16_t = unsigned short # macro
# uint32_t = unsigned int # macro
# uint64_t = unsigned long long # macro
IGVM_MAGIC_VALUE = 0x4D564749 # macro
IGVM_SNP_PLATFORM_VERSION = 0x1 # macro
IGVM_VBS_PLATFORM_VERSION = 0x1 # macro
IGVM_TDX_PLATFORM_VERSION = 0x1 # macro
class struct__IGVM_FIXED_HEADER(Structure):
    pass

struct__IGVM_FIXED_HEADER._pack_ = 1 # source:False
struct__IGVM_FIXED_HEADER._fields_ = [
    ('Magic', ctypes.c_uint32),
    ('FormatVersion', ctypes.c_uint32),
    ('VariableHeaderOffset', ctypes.c_uint32),
    ('VariableHeaderSize', ctypes.c_uint32),
    ('TotalFileSize', ctypes.c_uint32),
    ('Checksum', ctypes.c_uint32),
]

IGVM_FIXED_HEADER = struct__IGVM_FIXED_HEADER

# values for enumeration 'IGVM_VARIABLE_HEADER_TYPES'
IGVM_VARIABLE_HEADER_TYPES__enumvalues = {
    1: 'IGVM_VHT_SUPPORTED_PLATFORM',
    257: 'IGVM_VHT_SNP_POLICY',
    769: 'IGVM_VHT_PARAMETER_AREA',
    770: 'IGVM_VHT_PAGE_DATA',
    771: 'IGVM_VHT_PARAMETER_INSERT',
    772: 'IGVM_VHT_VP_CONTEXT',
    773: 'IGVM_VHT_REQUIRED_MEMORY',
    774: 'IGVM_VHT_SHARED_BOUNDARY_GPA',
    775: 'IGVM_VHT_VP_COUNT_PARAMETER',
    776: 'IGVM_VHT_SRAT',
    777: 'IGVM_VHT_MADT',
    778: 'IGVM_VHT_MMIO_RANGES',
    779: 'IGVM_VHT_SNP_ID_BLOCK',
    780: 'IGVM_VHT_MEMORY_MAP',
    781: 'IGVM_VHT_ERROR_RANGE',
    782: 'IGVM_VHT_COMMAND_LINE',
    32769: 'IGVM_VHT_HCL_SGX_RANGES',
}
IGVM_VHT_SUPPORTED_PLATFORM = 1
IGVM_VHT_SNP_POLICY = 257
IGVM_VHT_PARAMETER_AREA = 769
IGVM_VHT_PAGE_DATA = 770
IGVM_VHT_PARAMETER_INSERT = 771
IGVM_VHT_VP_CONTEXT = 772
IGVM_VHT_REQUIRED_MEMORY = 773
IGVM_VHT_SHARED_BOUNDARY_GPA = 774
IGVM_VHT_VP_COUNT_PARAMETER = 775
IGVM_VHT_SRAT = 776
IGVM_VHT_MADT = 777
IGVM_VHT_MMIO_RANGES = 778
IGVM_VHT_SNP_ID_BLOCK = 779
IGVM_VHT_MEMORY_MAP = 780
IGVM_VHT_ERROR_RANGE = 781
IGVM_VHT_COMMAND_LINE = 782
IGVM_VHT_HCL_SGX_RANGES = 32769
IGVM_VARIABLE_HEADER_TYPES = ctypes.c_uint32 # enum
class struct__IGVM_VHS_VARIABLE_HEADER(Structure):
    pass

struct__IGVM_VHS_VARIABLE_HEADER._pack_ = 1 # source:False
struct__IGVM_VHS_VARIABLE_HEADER._fields_ = [
    ('Type', ctypes.c_uint32),
    ('Length', ctypes.c_uint32),
]

IGVM_VHS_VARIABLE_HEADER = struct__IGVM_VHS_VARIABLE_HEADER

# values for enumeration '_IGVM_VHE_SUPPORTED_PLATFORM'
_IGVM_VHE_SUPPORTED_PLATFORM__enumvalues = {
    1: 'IgvmPlatformVsmIsolation',
    2: 'IgvmPlatformSevSnp',
    3: 'IgvmPlatformTdx',
}
IgvmPlatformVsmIsolation = 1
IgvmPlatformSevSnp = 2
IgvmPlatformTdx = 3
_IGVM_VHE_SUPPORTED_PLATFORM = ctypes.c_uint32 # enum
class struct__IGVM_VHS_SUPPORTED_PLATFORM(Structure):
    pass

struct__IGVM_VHS_SUPPORTED_PLATFORM._pack_ = 1 # source:False
struct__IGVM_VHS_SUPPORTED_PLATFORM._fields_ = [
    ('CompatibilityMask', ctypes.c_uint32),
    ('HighestVtl', ctypes.c_ubyte),
    ('PlatformType', ctypes.c_ubyte),
    ('PlatformVersion', ctypes.c_uint16),
    ('SharedGPABoundary', ctypes.c_uint64),
]

IGVM_VHS_SUPPORTED_PLATFORM = struct__IGVM_VHS_SUPPORTED_PLATFORM
class struct__IGVM_VHS_SNP_POLICY(Structure):
    pass

struct__IGVM_VHS_SNP_POLICY._pack_ = 1 # source:False
struct__IGVM_VHS_SNP_POLICY._fields_ = [
    ('Policy', ctypes.c_uint64),
    ('CompatibilityMask', ctypes.c_uint32),
    ('Reserved', ctypes.c_uint32),
]

IGVM_VHS_SNP_POLICY = struct__IGVM_VHS_SNP_POLICY
class struct__IGVM_VHS_PARAMETER_AREA(Structure):
    pass

struct__IGVM_VHS_PARAMETER_AREA._pack_ = 1 # source:False
struct__IGVM_VHS_PARAMETER_AREA._fields_ = [
    ('NumberOfBytes', ctypes.c_uint64),
    ('ParameterAreaIndex', ctypes.c_uint32),
    ('FileOffset', ctypes.c_uint32),
]

IGVM_VHS_PARAMETER_AREA = struct__IGVM_VHS_PARAMETER_AREA
class struct__IGVM_VHS_PAGE_DATA(Structure):
    pass

struct__IGVM_VHS_PAGE_DATA._pack_ = 1 # source:False
struct__IGVM_VHS_PAGE_DATA._fields_ = [
    ('GPA', ctypes.c_uint64),
    ('CompatibilityMask', ctypes.c_uint32),
    ('FileOffset', ctypes.c_uint32),
    ('Flags', ctypes.c_uint32),
    ('DataType', ctypes.c_uint16),
    ('Reserved', ctypes.c_uint16),
]

IGVM_VHS_PAGE_DATA = struct__IGVM_VHS_PAGE_DATA

# values for enumeration 'IGVM_VHF_PAGE_DATA_FLAGS'
IGVM_VHF_PAGE_DATA_FLAGS__enumvalues = {
    1: 'IGVM_VHF_PAGE_DATA_2MB',
    2: 'IGVM_VHF_PAGE_DATA_UNMEASURED',
    4: 'IGVM_VHF_PAGE_DATA_GUEST_INVALID'
}
IGVM_VHF_PAGE_DATA_2MB = 1
IGVM_VHF_PAGE_DATA_UNMEASURED = 2
IGVM_VHF_PAGE_DATA_GUEST_INVALID = 4
IGVM_VHF_PAGE_DATA_FLAGS = ctypes.c_uint32 # enum

# values for enumeration 'IGVM_VHS_PAGE_DATA_TYPE'
IGVM_VHS_PAGE_DATA_TYPE__enumvalues = {
    0: 'IGVM_VHS_PAGE_DATA_TYPE_NORMAL',
    1: 'IGVM_VHS_PAGE_DATA_TYPE_SECRETS',
    2: 'IGVM_VHS_PAGE_DATA_TYPE_CPUID_DATA',
    3: 'IGVM_VHS_PAGE_DATA_TYPE_CPUID_XF',
}
IGVM_VHS_PAGE_DATA_TYPE_NORMAL = 0
IGVM_VHS_PAGE_DATA_TYPE_SECRETS = 1
IGVM_VHS_PAGE_DATA_TYPE_CPUID_DATA = 2
IGVM_VHS_PAGE_DATA_TYPE_CPUID_XF = 3
IGVM_VHS_PAGE_DATA_TYPE = ctypes.c_uint32 # enum
class struct__IGVM_VHS_PARAMETER_INSERT(Structure):
    pass

struct__IGVM_VHS_PARAMETER_INSERT._pack_ = 1 # source:False
struct__IGVM_VHS_PARAMETER_INSERT._fields_ = [
    ('GPA', ctypes.c_uint64),
    ('CompatibilityMask', ctypes.c_uint32),
    ('ParameterAreaIndex', ctypes.c_uint32),
]

IGVM_VHS_PARAMETER_INSERT = struct__IGVM_VHS_PARAMETER_INSERT
class struct__IGVM_VHS_PARAMETER(Structure):
    pass

struct__IGVM_VHS_PARAMETER._pack_ = 1 # source:False
struct__IGVM_VHS_PARAMETER._fields_ = [
    ('ParameterAreaIndex', ctypes.c_uint32),
    ('ByteOffset', ctypes.c_uint32),
]

IGVM_VHS_PARAMETER = struct__IGVM_VHS_PARAMETER
class struct__IGVM_VHS_VP_CONTEXT(Structure):
    pass

struct__IGVM_VHS_VP_CONTEXT._pack_ = 1 # source:False
struct__IGVM_VHS_VP_CONTEXT._fields_ = [
    ('GPA', ctypes.c_uint64),
    ('CompatibilityMask', ctypes.c_uint32),
    ('FileOffset', ctypes.c_uint32),
    ('VpIndex', ctypes.c_uint16),
    ('Reserved', ctypes.c_uint16),
]

IGVM_VHS_VP_CONTEXT = struct__IGVM_VHS_VP_CONTEXT
class struct__IGVM_VHS_REQUIRED_MEMORY(Structure):
    pass

struct__IGVM_VHS_REQUIRED_MEMORY._pack_ = 1 # source:False
struct__IGVM_VHS_REQUIRED_MEMORY._fields_ = [
    ('GPA', ctypes.c_uint64),
    ('CompatibilityMask', ctypes.c_uint32),
    ('NumberOfBytes', ctypes.c_uint32),
    ('Flags', ctypes.c_uint32),
    ('Reserved', ctypes.c_uint32),
]

IGVM_VHS_REQUIRED_MEMORY = struct__IGVM_VHS_REQUIRED_MEMORY

# values for enumeration 'IGVM_VHF_REQUIRED_MEMORY_FLAGS'
IGVM_VHF_REQUIRED_MEMORY_FLAGS__enumvalues = {
    1: 'IGVM_VHF_REQUIRED_MEMORY_VTL2_PROTECTABLE',
}
IGVM_VHF_REQUIRED_MEMORY_VTL2_PROTECTABLE = 1
IGVM_VHF_REQUIRED_MEMORY_FLAGS = ctypes.c_uint32 # enum
class struct__IGVM_VHS_MMIO_RANGES(Structure):
    pass

class struct__IGVM_VHS_MMIO_RANGES_0(Structure):
    pass

struct__IGVM_VHS_MMIO_RANGES_0._pack_ = 1 # source:False
struct__IGVM_VHS_MMIO_RANGES_0._fields_ = [
    ('StartingGpaPageNumber', ctypes.c_uint64),
    ('NumberOfPages', ctypes.c_uint64),
]

struct__IGVM_VHS_MMIO_RANGES._pack_ = 1 # source:False
struct__IGVM_VHS_MMIO_RANGES._fields_ = [
    ('MmioRanges', struct__IGVM_VHS_MMIO_RANGES_0 * 2),
]

IGVM_VHS_MMIO_RANGES = struct__IGVM_VHS_MMIO_RANGES
class struct__IGVM_VHS_MEMORY_MAP_ENTRY(Structure):
    pass

struct__IGVM_VHS_MEMORY_MAP_ENTRY._pack_ = 1 # source:False
struct__IGVM_VHS_MEMORY_MAP_ENTRY._fields_ = [
    ('StartingGpaPageNumber', ctypes.c_uint64),
    ('NumberOfPages', ctypes.c_uint64),
    ('Type', ctypes.c_uint16),
    ('Flags', ctypes.c_uint16),
    ('Reserved', ctypes.c_uint32),
]

IGVM_VHS_MEMORY_MAP_ENTRY = struct__IGVM_VHS_MEMORY_MAP_ENTRY
PIGVM_VHS_MEMORY_MAP_ENTRY = ctypes.POINTER(struct__IGVM_VHS_MEMORY_MAP_ENTRY)

# values for enumeration 'IGVM_VHS_MEMORY_MAP_ENTRY_TYPES'
IGVM_VHS_MEMORY_MAP_ENTRY_TYPES__enumvalues = {
    0: 'IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_MEMORY',
    1: 'IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED',
    2: 'IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_PERSISTENT',
    3: 'IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_VTL2_PROTECTABLE',
}
IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_MEMORY = 0
IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED = 1
IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_PERSISTENT = 2
IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_VTL2_PROTECTABLE = 3
IGVM_VHS_MEMORY_MAP_ENTRY_TYPES = ctypes.c_uint32 # enum
class struct__IGVM_VHS_SNP_ID_BLOCK_SIGNATURE(Structure):
    pass

struct__IGVM_VHS_SNP_ID_BLOCK_SIGNATURE._pack_ = 1 # source:False
struct__IGVM_VHS_SNP_ID_BLOCK_SIGNATURE._fields_ = [
    ('R', ctypes.c_ubyte * 72),
    ('S', ctypes.c_ubyte * 72),
]

class struct__IGVM_VHS_SNP_ID_BLOCK_PUBLIC_KEY(Structure):
    pass

struct__IGVM_VHS_SNP_ID_BLOCK_PUBLIC_KEY._pack_ = 1 # source:False
struct__IGVM_VHS_SNP_ID_BLOCK_PUBLIC_KEY._fields_ = [
    ('Curve', ctypes.c_uint32),
    ('Reserved', ctypes.c_uint32),
    ('Qx', ctypes.c_ubyte * 72),
    ('Qy', ctypes.c_ubyte * 72),
]

class struct__IGVM_VHS_SNP_ID_BLOCK(Structure):
    pass

struct__IGVM_VHS_SNP_ID_BLOCK._pack_ = 1 # source:False
struct__IGVM_VHS_SNP_ID_BLOCK._fields_ = [
    ('CompatibilityMask', ctypes.c_uint32),
    ('AuthorKeyEnabled', ctypes.c_ubyte),
    ('Reserved', ctypes.c_ubyte * 3),
    ('Ld', ctypes.c_ubyte * 48),
    ('FamilyId', ctypes.c_ubyte * 16),
    ('ImageId', ctypes.c_ubyte * 16),
    ('Version', ctypes.c_uint32),
    ('GuestSvn', ctypes.c_uint32),
    ('IdKeyAlgorithm', ctypes.c_uint32),
    ('AuthorKeyAlgorithm', ctypes.c_uint32),
    ('IdKeySignature', struct__IGVM_VHS_SNP_ID_BLOCK_SIGNATURE),
    ('IdPublicKey', struct__IGVM_VHS_SNP_ID_BLOCK_PUBLIC_KEY),
    ('AuthorKeySignature', struct__IGVM_VHS_SNP_ID_BLOCK_SIGNATURE),
    ('AuthorPublicKey', struct__IGVM_VHS_SNP_ID_BLOCK_PUBLIC_KEY),
]

IGVM_VHS_SNP_ID_BLOCK = struct__IGVM_VHS_SNP_ID_BLOCK
class struct__IGVM_VHS_ERROR_RANGE(Structure):
    pass

struct__IGVM_VHS_ERROR_RANGE._pack_ = 1 # source:False
struct__IGVM_VHS_ERROR_RANGE._fields_ = [
    ('GPA', ctypes.c_uint64),
    ('CompatibilityMask', ctypes.c_uint32),
    ('SizeBytes', ctypes.c_uint32),
]

IGVM_VHS_ERROR_RANGE = struct__IGVM_VHS_ERROR_RANGE
class struct_SNP_PAGE_INFO(Structure):
    pass

struct_SNP_PAGE_INFO._pack_ = 1 # source:False
struct_SNP_PAGE_INFO._fields_ = [
    ('DigestCurrent', ctypes.c_ubyte * 48),
    ('Contents', ctypes.c_ubyte * 48),
    ('Length', ctypes.c_uint16),
    ('PageType', ctypes.c_ubyte),
    ('ImiPageBit', ctypes.c_ubyte),
    ('LowerVmplPermissions', ctypes.c_uint32),
    ('Gpa', ctypes.c_uint64),
]

class struct_SNP_ID_BLOCK(Structure):
    pass

struct_SNP_ID_BLOCK._pack_ = 1 # source:False
struct_SNP_ID_BLOCK._fields_ = [
    ('Ld', ctypes.c_ubyte * 48),
    ('FamilyId', ctypes.c_ubyte * 16),
    ('ImageId', ctypes.c_ubyte * 16),
    ('Version', ctypes.c_uint32),
    ('GuestSvn', ctypes.c_uint32),
    ('Policy', ctypes.c_uint64),
]

__all__ = \
    ['IGVM_FIXED_HEADER', 'IGVM_MAGIC_VALUE',
    'IGVM_SNP_PLATFORM_VERSION', 'IGVM_TDX_PLATFORM_VERSION',
    'IGVM_VARIABLE_HEADER_TYPES', 'IGVM_VBS_PLATFORM_VERSION',
    'IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_MEMORY',
    'IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_PERSISTENT',
    'IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED',
    'IGVM_VHF_MEMORY_MAP_ENTRY_TYPE_VTL2_PROTECTABLE',
    'IGVM_VHF_PAGE_DATA_2MB', 'IGVM_VHF_PAGE_DATA_FLAGS',
    'IGVM_VHF_PAGE_DATA_UNMEASURED', 'IGVM_VHF_REQUIRED_MEMORY_FLAGS',
    'IGVM_VHF_REQUIRED_MEMORY_VTL2_PROTECTABLE',
    'IGVM_VHS_ERROR_RANGE', 'IGVM_VHS_MEMORY_MAP_ENTRY',
    'IGVM_VHS_MEMORY_MAP_ENTRY_TYPES', 'IGVM_VHS_MMIO_RANGES',
    'IGVM_VHS_PAGE_DATA', 'IGVM_VHS_PAGE_DATA_TYPE',
    'IGVM_VHS_PAGE_DATA_TYPE_CPUID_DATA',
    'IGVM_VHS_PAGE_DATA_TYPE_CPUID_XF',
    'IGVM_VHS_PAGE_DATA_TYPE_NORMAL',
    'IGVM_VHS_PAGE_DATA_TYPE_SECRETS', 'IGVM_VHS_PARAMETER',
    'IGVM_VHS_PARAMETER_AREA', 'IGVM_VHS_PARAMETER_INSERT',
    'IGVM_VHS_REQUIRED_MEMORY', 'IGVM_VHS_SNP_ID_BLOCK',
    'IGVM_VHS_SNP_POLICY', 'IGVM_VHS_SUPPORTED_PLATFORM',
    'IGVM_VHS_VARIABLE_HEADER', 'IGVM_VHS_VP_CONTEXT',
    'IGVM_VHT_COMMAND_LINE', 'IGVM_VHT_ERROR_RANGE',
    'IGVM_VHT_HCL_SGX_RANGES', 'IGVM_VHT_MADT', 'IGVM_VHT_MEMORY_MAP',
    'IGVM_VHT_MMIO_RANGES', 'IGVM_VHT_PAGE_DATA',
    'IGVM_VHT_PARAMETER_AREA', 'IGVM_VHT_PARAMETER_INSERT',
    'IGVM_VHT_REQUIRED_MEMORY', 'IGVM_VHT_SHARED_BOUNDARY_GPA',
    'IGVM_VHT_SNP_ID_BLOCK', 'IGVM_VHT_SNP_POLICY', 'IGVM_VHT_SRAT',
    'IGVM_VHT_SUPPORTED_PLATFORM', 'IGVM_VHT_VP_CONTEXT',
    'IGVM_VHT_VP_COUNT_PARAMETER', 'IgvmPlatformSevSnp',
    'IgvmPlatformTdx', 'IgvmPlatformVsmIsolation',
    'PIGVM_VHS_MEMORY_MAP_ENTRY', '_IGVM_VHE_SUPPORTED_PLATFORM',
    'struct_SNP_ID_BLOCK', 'struct_SNP_PAGE_INFO',
    'struct__IGVM_FIXED_HEADER', 'struct__IGVM_VHS_ERROR_RANGE',
    'struct__IGVM_VHS_MEMORY_MAP_ENTRY',
    'struct__IGVM_VHS_MMIO_RANGES', 'struct__IGVM_VHS_MMIO_RANGES_0',
    'struct__IGVM_VHS_PAGE_DATA', 'struct__IGVM_VHS_PARAMETER',
    'struct__IGVM_VHS_PARAMETER_AREA',
    'struct__IGVM_VHS_PARAMETER_INSERT',
    'struct__IGVM_VHS_REQUIRED_MEMORY',
    'struct__IGVM_VHS_SNP_ID_BLOCK',
    'struct__IGVM_VHS_SNP_ID_BLOCK_PUBLIC_KEY',
    'struct__IGVM_VHS_SNP_ID_BLOCK_SIGNATURE',
    'struct__IGVM_VHS_SNP_POLICY',
    'struct__IGVM_VHS_SUPPORTED_PLATFORM',
    'struct__IGVM_VHS_VARIABLE_HEADER', 'struct__IGVM_VHS_VP_CONTEXT', 'IGVM_VARIABLE_HEADER_TYPES__enumvalues']
