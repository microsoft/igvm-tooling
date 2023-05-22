# -*- coding: utf-8 -*-
#
# TARGET arch is: ['-I/root/snp/igvm/../snplinux/arch/x86/include', '-DC_ASSERT(x)=', '-D__packed=', '-Du32=uint32_t', '-DUINT32=int', '-DUINT64=long', '-DUINT16=short', '-DUINT8=char', '-I/root/snp/igvm/../snplinux/include', '-DC_ASSERT(x)=', '-D__packed=', '-Du32=uint32_t', '-DUINT32=int', '-DUINT64=long', '-DUINT16=short', '-DUINT8=char', '-I/root/snp/igvm/../snplinux/', '-DC_ASSERT(x)=', '-D__packed=', '-Du32=uint32_t', '-DUINT32=int', '-DUINT64=long', '-DUINT16=short', '-DUINT8=char']
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






# values for enumeration 'e820_type'
e820_type__enumvalues = {
    1: 'E820_TYPE_RAM',
    2: 'E820_TYPE_RESERVED',
    3: 'E820_TYPE_ACPI',
    4: 'E820_TYPE_NVS',
    5: 'E820_TYPE_UNUSABLE',
    7: 'E820_TYPE_PMEM',
    12: 'E820_TYPE_PRAM',
    4026531839: 'E820_TYPE_SOFT_RESERVED',
    128: 'E820_TYPE_RESERVED_KERN',
}
E820_TYPE_RAM = 1
E820_TYPE_RESERVED = 2
E820_TYPE_ACPI = 3
E820_TYPE_NVS = 4
E820_TYPE_UNUSABLE = 5
E820_TYPE_PMEM = 7
E820_TYPE_PRAM = 12
E820_TYPE_SOFT_RESERVED = 4026531839
E820_TYPE_RESERVED_KERN = 128
e820_type = ctypes.c_uint32 # enum
class struct_vmcb_save_area(Structure):
    pass

class struct_vmcb_seg(Structure):
    pass

struct_vmcb_seg._pack_ = 1 # source:False
struct_vmcb_seg._fields_ = [
    ('selector', ctypes.c_uint16),
    ('attrib', ctypes.c_uint16),
    ('limit', ctypes.c_uint32),
    ('base', ctypes.c_uint64),
]

class union_vmcb_save_area_0(Union):
    pass

class struct_vmcb_save_area_0_0(Structure):
    pass

struct_vmcb_save_area_0_0._pack_ = 1 # source:False
struct_vmcb_save_area_0_0._fields_ = [
    ('sev_feature_snp', ctypes.c_uint64, 1),
    ('sev_feature_vtom', ctypes.c_uint64, 1),
    ('sev_feature_reflectvc', ctypes.c_uint64, 1),
    ('sev_feature_restrict_injection', ctypes.c_uint64, 1),
    ('sev_feature_alternate_injection', ctypes.c_uint64, 1),
    ('sev_feature_full_debug', ctypes.c_uint64, 1),
    ('sev_feature_reserved1', ctypes.c_uint64, 1),
    ('sev_feature_snpbtb_isolation', ctypes.c_uint64, 1),
    ('sev_feature_resrved2', ctypes.c_uint64, 56),
]

union_vmcb_save_area_0._pack_ = 1 # source:False
union_vmcb_save_area_0._fields_ = [
    ('sev_features', ctypes.c_uint64),
    ('vmcb_save_area_0_0', struct_vmcb_save_area_0_0),
]

struct_vmcb_save_area._pack_ = 1 # source:False
struct_vmcb_save_area._fields_ = [
    ('es', struct_vmcb_seg),
    ('cs', struct_vmcb_seg),
    ('ss', struct_vmcb_seg),
    ('ds', struct_vmcb_seg),
    ('fs', struct_vmcb_seg),
    ('gs', struct_vmcb_seg),
    ('gdtr', struct_vmcb_seg),
    ('ldtr', struct_vmcb_seg),
    ('idtr', struct_vmcb_seg),
    ('tr', struct_vmcb_seg),
    ('reserved_1', ctypes.c_ubyte * 42),
    ('vmpl', ctypes.c_ubyte),
    ('cpl', ctypes.c_ubyte),
    ('reserved_2', ctypes.c_ubyte * 4),
    ('efer', ctypes.c_uint64),
    ('reserved_3', ctypes.c_ubyte * 104),
    ('xss', ctypes.c_uint64),
    ('cr4', ctypes.c_uint64),
    ('cr3', ctypes.c_uint64),
    ('cr0', ctypes.c_uint64),
    ('dr7', ctypes.c_uint64),
    ('dr6', ctypes.c_uint64),
    ('rflags', ctypes.c_uint64),
    ('rip', ctypes.c_uint64),
    ('reserved_4', ctypes.c_ubyte * 88),
    ('rsp', ctypes.c_uint64),
    ('reserved_5', ctypes.c_ubyte * 24),
    ('rax', ctypes.c_uint64),
    ('star', ctypes.c_uint64),
    ('lstar', ctypes.c_uint64),
    ('cstar', ctypes.c_uint64),
    ('sfmask', ctypes.c_uint64),
    ('kernel_gs_base', ctypes.c_uint64),
    ('sysenter_cs', ctypes.c_uint64),
    ('sysenter_esp', ctypes.c_uint64),
    ('sysenter_eip', ctypes.c_uint64),
    ('cr2', ctypes.c_uint64),
    ('reserved_6', ctypes.c_ubyte * 32),
    ('g_pat', ctypes.c_uint64),
    ('dbgctl', ctypes.c_uint64),
    ('br_from', ctypes.c_uint64),
    ('br_to', ctypes.c_uint64),
    ('last_excp_from', ctypes.c_uint64),
    ('last_excp_to', ctypes.c_uint64),
    ('reserved_7', ctypes.c_ubyte * 80),
    ('pkru', ctypes.c_uint32),
    ('reserved_7a', ctypes.c_ubyte * 20),
    ('reserved_8', ctypes.c_uint64),
    ('rcx', ctypes.c_uint64),
    ('rdx', ctypes.c_uint64),
    ('rbx', ctypes.c_uint64),
    ('reserved_9', ctypes.c_uint64),
    ('rbp', ctypes.c_uint64),
    ('rsi', ctypes.c_uint64),
    ('rdi', ctypes.c_uint64),
    ('r8', ctypes.c_uint64),
    ('r9', ctypes.c_uint64),
    ('r10', ctypes.c_uint64),
    ('r11', ctypes.c_uint64),
    ('r12', ctypes.c_uint64),
    ('r13', ctypes.c_uint64),
    ('r14', ctypes.c_uint64),
    ('r15', ctypes.c_uint64),
    ('reserved_10', ctypes.c_ubyte * 16),
    ('sw_exit_code', ctypes.c_uint64),
    ('sw_exit_info_1', ctypes.c_uint64),
    ('sw_exit_info_2', ctypes.c_uint64),
    ('sw_scratch', ctypes.c_uint64),
    ('vmcb_save_area_0', union_vmcb_save_area_0),
    ('vintr_ctrl', ctypes.c_uint64),
    ('guest_error_code', ctypes.c_uint64),
    ('virtual_tom', ctypes.c_uint64),
    ('tlb_id', ctypes.c_uint64),
    ('pcpu_id', ctypes.c_uint64),
    ('event_inject', ctypes.c_uint64),
    ('xcr0', ctypes.c_uint64),
    ('valid_bitmap', ctypes.c_ubyte * 16),
    ('x87_state_gpa', ctypes.c_uint64),
]

class struct_boot_params(Structure):
    pass

class struct_screen_info(Structure):
    pass

struct_screen_info._pack_ = 1 # source:True
struct_screen_info._fields_ = [
    ('orig_x', ctypes.c_ubyte),
    ('orig_y', ctypes.c_ubyte),
    ('ext_mem_k', ctypes.c_uint16),
    ('orig_video_page', ctypes.c_uint16),
    ('orig_video_mode', ctypes.c_ubyte),
    ('orig_video_cols', ctypes.c_ubyte),
    ('flags', ctypes.c_ubyte),
    ('unused2', ctypes.c_ubyte),
    ('orig_video_ega_bx', ctypes.c_uint16),
    ('unused3', ctypes.c_uint16),
    ('orig_video_lines', ctypes.c_ubyte),
    ('orig_video_isVGA', ctypes.c_ubyte),
    ('orig_video_points', ctypes.c_uint16),
    ('lfb_width', ctypes.c_uint16),
    ('lfb_height', ctypes.c_uint16),
    ('lfb_depth', ctypes.c_uint16),
    ('lfb_base', ctypes.c_uint32),
    ('lfb_size', ctypes.c_uint32),
    ('cl_magic', ctypes.c_uint16),
    ('cl_offset', ctypes.c_uint16),
    ('lfb_linelength', ctypes.c_uint16),
    ('red_size', ctypes.c_ubyte),
    ('red_pos', ctypes.c_ubyte),
    ('green_size', ctypes.c_ubyte),
    ('green_pos', ctypes.c_ubyte),
    ('blue_size', ctypes.c_ubyte),
    ('blue_pos', ctypes.c_ubyte),
    ('rsvd_size', ctypes.c_ubyte),
    ('rsvd_pos', ctypes.c_ubyte),
    ('vesapm_seg', ctypes.c_uint16),
    ('vesapm_off', ctypes.c_uint16),
    ('pages', ctypes.c_uint16),
    ('vesa_attributes', ctypes.c_uint16),
    ('capabilities', ctypes.c_uint32),
    ('ext_lfb_base', ctypes.c_uint32),
    ('_reserved', ctypes.c_ubyte * 2),
]

class struct_olpc_ofw_header(Structure):
    pass

struct_olpc_ofw_header._pack_ = 1 # source:True
struct_olpc_ofw_header._fields_ = [
    ('ofw_magic', ctypes.c_uint32),
    ('ofw_version', ctypes.c_uint32),
    ('cif_handler', ctypes.c_uint32),
    ('irq_desc_table', ctypes.c_uint32),
]

class struct_apm_bios_info(Structure):
    pass

struct_apm_bios_info._pack_ = 1 # source:False
struct_apm_bios_info._fields_ = [
    ('version', ctypes.c_uint16),
    ('cseg', ctypes.c_uint16),
    ('offset', ctypes.c_uint32),
    ('cseg_16', ctypes.c_uint16),
    ('dseg', ctypes.c_uint16),
    ('flags', ctypes.c_uint16),
    ('cseg_len', ctypes.c_uint16),
    ('cseg_16_len', ctypes.c_uint16),
    ('dseg_len', ctypes.c_uint16),
]

class struct_sys_desc_table(Structure):
    pass

struct_sys_desc_table._pack_ = 1 # source:False
struct_sys_desc_table._fields_ = [
    ('length', ctypes.c_uint16),
    ('table', ctypes.c_ubyte * 14),
]

class struct_edid_info(Structure):
    pass

struct_edid_info._pack_ = 1 # source:False
struct_edid_info._fields_ = [
    ('dummy', ctypes.c_ubyte * 128),
]

class struct_edd_info(Structure):
    pass

class struct_edd_device_params(Structure):
    pass

class union_edd_device_params_1(Union):
    pass

class struct_edd_device_params_1_5(Structure):
    pass

struct_edd_device_params_1_5._pack_ = 1 # source:True
struct_edd_device_params_1_5._fields_ = [
    ('wwid', ctypes.c_uint64),
    ('lun', ctypes.c_uint64),
]

class struct_edd_device_params_1_0(Structure):
    pass

struct_edd_device_params_1_0._pack_ = 1 # source:True
struct_edd_device_params_1_0._fields_ = [
    ('device', ctypes.c_ubyte),
    ('reserved1', ctypes.c_ubyte),
    ('reserved2', ctypes.c_uint16),
    ('reserved3', ctypes.c_uint32),
    ('reserved4', ctypes.c_uint64),
]

class struct_edd_device_params_1_1(Structure):
    pass

struct_edd_device_params_1_1._pack_ = 1 # source:True
struct_edd_device_params_1_1._fields_ = [
    ('device', ctypes.c_ubyte),
    ('lun', ctypes.c_ubyte),
    ('reserved1', ctypes.c_ubyte),
    ('reserved2', ctypes.c_ubyte),
    ('reserved3', ctypes.c_uint32),
    ('reserved4', ctypes.c_uint64),
]

class struct_edd_device_params_1_6(Structure):
    pass

struct_edd_device_params_1_6._pack_ = 1 # source:True
struct_edd_device_params_1_6._fields_ = [
    ('identity_tag', ctypes.c_uint64),
    ('reserved', ctypes.c_uint64),
]

class struct_edd_device_params_1_2(Structure):
    pass

struct_edd_device_params_1_2._pack_ = 1 # source:True
struct_edd_device_params_1_2._fields_ = [
    ('id', ctypes.c_uint16),
    ('lun', ctypes.c_uint64),
    ('reserved1', ctypes.c_uint16),
    ('reserved2', ctypes.c_uint32),
]

class struct_edd_device_params_1_4(Structure):
    pass

struct_edd_device_params_1_4._pack_ = 1 # source:True
struct_edd_device_params_1_4._fields_ = [
    ('eui', ctypes.c_uint64),
    ('reserved', ctypes.c_uint64),
]

class struct_edd_device_params_1_8(Structure):
    pass

struct_edd_device_params_1_8._pack_ = 1 # source:True
struct_edd_device_params_1_8._fields_ = [
    ('device', ctypes.c_ubyte),
    ('reserved1', ctypes.c_ubyte),
    ('reserved2', ctypes.c_uint16),
    ('reserved3', ctypes.c_uint32),
    ('reserved4', ctypes.c_uint64),
]

class struct_edd_device_params_1_7(Structure):
    pass

struct_edd_device_params_1_7._pack_ = 1 # source:True
struct_edd_device_params_1_7._fields_ = [
    ('array_number', ctypes.c_uint32),
    ('reserved1', ctypes.c_uint32),
    ('reserved2', ctypes.c_uint64),
]

class struct_edd_device_params_1_3(Structure):
    pass

struct_edd_device_params_1_3._pack_ = 1 # source:True
struct_edd_device_params_1_3._fields_ = [
    ('serial_number', ctypes.c_uint64),
    ('reserved', ctypes.c_uint64),
]

class struct_edd_device_params_1_9(Structure):
    pass

struct_edd_device_params_1_9._pack_ = 1 # source:True
struct_edd_device_params_1_9._fields_ = [
    ('reserved1', ctypes.c_uint64),
    ('reserved2', ctypes.c_uint64),
]

union_edd_device_params_1._pack_ = 1 # source:False
union_edd_device_params_1._fields_ = [
    ('ata', struct_edd_device_params_1_0),
    ('atapi', struct_edd_device_params_1_1),
    ('scsi', struct_edd_device_params_1_2),
    ('usb', struct_edd_device_params_1_3),
    ('i1394', struct_edd_device_params_1_4),
    ('fibre', struct_edd_device_params_1_5),
    ('i2o', struct_edd_device_params_1_6),
    ('raid', struct_edd_device_params_1_7),
    ('sata', struct_edd_device_params_1_8),
    ('unknown', struct_edd_device_params_1_9),
]

class union_edd_device_params_0(Union):
    pass

class struct_edd_device_params_0_0(Structure):
    pass

struct_edd_device_params_0_0._pack_ = 1 # source:True
struct_edd_device_params_0_0._fields_ = [
    ('base_address', ctypes.c_uint16),
    ('reserved1', ctypes.c_uint16),
    ('reserved2', ctypes.c_uint32),
]

class struct_edd_device_params_0_5(Structure):
    pass

struct_edd_device_params_0_5._pack_ = 1 # source:True
struct_edd_device_params_0_5._fields_ = [
    ('reserved', ctypes.c_uint64),
]

class struct_edd_device_params_0_2(Structure):
    pass

struct_edd_device_params_0_2._pack_ = 1 # source:True
struct_edd_device_params_0_2._fields_ = [
    ('reserved', ctypes.c_uint64),
]

class struct_edd_device_params_0_3(Structure):
    pass

struct_edd_device_params_0_3._pack_ = 1 # source:True
struct_edd_device_params_0_3._fields_ = [
    ('reserved', ctypes.c_uint64),
]

class struct_edd_device_params_0_1(Structure):
    pass

struct_edd_device_params_0_1._pack_ = 1 # source:True
struct_edd_device_params_0_1._fields_ = [
    ('bus', ctypes.c_ubyte),
    ('slot', ctypes.c_ubyte),
    ('function', ctypes.c_ubyte),
    ('channel', ctypes.c_ubyte),
    ('reserved', ctypes.c_uint32),
]

class struct_edd_device_params_0_4(Structure):
    pass

struct_edd_device_params_0_4._pack_ = 1 # source:True
struct_edd_device_params_0_4._fields_ = [
    ('reserved', ctypes.c_uint64),
]

union_edd_device_params_0._pack_ = 1 # source:False
union_edd_device_params_0._fields_ = [
    ('isa', struct_edd_device_params_0_0),
    ('pci', struct_edd_device_params_0_1),
    ('ibnd', struct_edd_device_params_0_2),
    ('xprs', struct_edd_device_params_0_3),
    ('htpt', struct_edd_device_params_0_4),
    ('unknown', struct_edd_device_params_0_5),
]

struct_edd_device_params._pack_ = 1 # source:True
struct_edd_device_params._fields_ = [
    ('length', ctypes.c_uint16),
    ('info_flags', ctypes.c_uint16),
    ('num_default_cylinders', ctypes.c_uint32),
    ('num_default_heads', ctypes.c_uint32),
    ('sectors_per_track', ctypes.c_uint32),
    ('number_of_sectors', ctypes.c_uint64),
    ('bytes_per_sector', ctypes.c_uint16),
    ('dpte_ptr', ctypes.c_uint32),
    ('key', ctypes.c_uint16),
    ('device_path_info_length', ctypes.c_ubyte),
    ('reserved2', ctypes.c_ubyte),
    ('reserved3', ctypes.c_uint16),
    ('host_bus_type', ctypes.c_ubyte * 4),
    ('interface_type', ctypes.c_ubyte * 8),
    ('interface_path', union_edd_device_params_0),
    ('device_path', union_edd_device_params_1),
    ('reserved4', ctypes.c_ubyte),
    ('checksum', ctypes.c_ubyte),
]

struct_edd_info._pack_ = 1 # source:True
struct_edd_info._fields_ = [
    ('device', ctypes.c_ubyte),
    ('version', ctypes.c_ubyte),
    ('interface_support', ctypes.c_uint16),
    ('legacy_max_cylinder', ctypes.c_uint16),
    ('legacy_max_head', ctypes.c_ubyte),
    ('legacy_sectors_per_track', ctypes.c_ubyte),
    ('params', struct_edd_device_params),
]

class struct_setup_header(Structure):
    pass

struct_setup_header._pack_ = 1 # source:True
struct_setup_header._fields_ = [
    ('setup_sects', ctypes.c_ubyte),
    ('root_flags', ctypes.c_uint16),
    ('syssize', ctypes.c_uint32),
    ('ram_size', ctypes.c_uint16),
    ('vid_mode', ctypes.c_uint16),
    ('root_dev', ctypes.c_uint16),
    ('boot_flag', ctypes.c_uint16),
    ('jump', ctypes.c_uint16),
    ('header', ctypes.c_uint32),
    ('version', ctypes.c_uint16),
    ('realmode_swtch', ctypes.c_uint32),
    ('start_sys_seg', ctypes.c_uint16),
    ('kernel_version', ctypes.c_uint16),
    ('type_of_loader', ctypes.c_ubyte),
    ('loadflags', ctypes.c_ubyte),
    ('setup_move_size', ctypes.c_uint16),
    ('code32_start', ctypes.c_uint32),
    ('ramdisk_image', ctypes.c_uint32),
    ('ramdisk_size', ctypes.c_uint32),
    ('bootsect_kludge', ctypes.c_uint32),
    ('heap_end_ptr', ctypes.c_uint16),
    ('ext_loader_ver', ctypes.c_ubyte),
    ('ext_loader_type', ctypes.c_ubyte),
    ('cmd_line_ptr', ctypes.c_uint32),
    ('initrd_addr_max', ctypes.c_uint32),
    ('kernel_alignment', ctypes.c_uint32),
    ('relocatable_kernel', ctypes.c_ubyte),
    ('min_alignment', ctypes.c_ubyte),
    ('xloadflags', ctypes.c_uint16),
    ('cmdline_size', ctypes.c_uint32),
    ('hardware_subarch', ctypes.c_uint32),
    ('hardware_subarch_data', ctypes.c_uint64),
    ('payload_offset', ctypes.c_uint32),
    ('payload_length', ctypes.c_uint32),
    ('setup_data', ctypes.c_uint64),
    ('pref_address', ctypes.c_uint64),
    ('init_size', ctypes.c_uint32),
    ('handover_offset', ctypes.c_uint32),
    ('kernel_info_offset', ctypes.c_uint32),
]

class struct_boot_e820_entry(Structure):
    pass

struct_boot_e820_entry._pack_ = 1 # source:True
struct_boot_e820_entry._fields_ = [
    ('addr', ctypes.c_uint64),
    ('size', ctypes.c_uint64),
    ('type', ctypes.c_uint32),
]

class struct_ist_info(Structure):
    pass

struct_ist_info._pack_ = 1 # source:False
struct_ist_info._fields_ = [
    ('signature', ctypes.c_uint32),
    ('command', ctypes.c_uint32),
    ('event', ctypes.c_uint32),
    ('perf_level', ctypes.c_uint32),
]

class struct_efi_info(Structure):
    pass

struct_efi_info._pack_ = 1 # source:False
struct_efi_info._fields_ = [
    ('efi_loader_signature', ctypes.c_uint32),
    ('efi_systab', ctypes.c_uint32),
    ('efi_memdesc_size', ctypes.c_uint32),
    ('efi_memdesc_version', ctypes.c_uint32),
    ('efi_memmap', ctypes.c_uint32),
    ('efi_memmap_size', ctypes.c_uint32),
    ('efi_systab_hi', ctypes.c_uint32),
    ('efi_memmap_hi', ctypes.c_uint32),
]

struct_boot_params._pack_ = 1 # source:True
struct_boot_params._fields_ = [
    ('screen_info', struct_screen_info),
    ('apm_bios_info', struct_apm_bios_info),
    ('_pad2', ctypes.c_ubyte * 4),
    ('tboot_addr', ctypes.c_uint64),
    ('ist_info', struct_ist_info),
    ('acpi_rsdp_addr', ctypes.c_uint64),
    ('_pad3', ctypes.c_ubyte * 8),
    ('hd0_info', ctypes.c_ubyte * 16),
    ('hd1_info', ctypes.c_ubyte * 16),
    ('sys_desc_table', struct_sys_desc_table),
    ('olpc_ofw_header', struct_olpc_ofw_header),
    ('ext_ramdisk_image', ctypes.c_uint32),
    ('ext_ramdisk_size', ctypes.c_uint32),
    ('ext_cmd_line_ptr', ctypes.c_uint32),
    ('_pad4', ctypes.c_ubyte * 112),
    ('cc_blob_address', ctypes.c_uint32),
    ('edid_info', struct_edid_info),
    ('efi_info', struct_efi_info),
    ('alt_mem_k', ctypes.c_uint32),
    ('scratch', ctypes.c_uint32),
    ('e820_entries', ctypes.c_ubyte),
    ('eddbuf_entries', ctypes.c_ubyte),
    ('edd_mbr_sig_buf_entries', ctypes.c_ubyte),
    ('kbd_status', ctypes.c_ubyte),
    ('secure_boot', ctypes.c_ubyte),
    ('_pad5', ctypes.c_ubyte * 2),
    ('sentinel', ctypes.c_ubyte),
    ('_pad6', ctypes.c_ubyte * 1),
    ('hdr', struct_setup_header),
    ('_pad7', ctypes.c_ubyte * 36),
    ('edd_mbr_sig_buffer', ctypes.c_uint32 * 16),
    ('e820_table', struct_boot_e820_entry * 128),
    ('_pad8', ctypes.c_ubyte * 48),
    ('eddbuf', struct_edd_info * 6),
    ('_pad9', ctypes.c_ubyte * 276),
]

CC_BLOB_SEV_HDR_MAGIC = 0x45444d41


class struct_cc_blob_sev_info(Structure):
    pass


struct_cc_blob_sev_info._pack_ = 1
struct_cc_blob_sev_info._fields_ = [('magic', ctypes.c_uint32),
                                    ('version', ctypes.c_uint16),
                                    ('reserved', ctypes.c_uint16),
                                    ('secrets_phys', ctypes.c_uint64),
                                    ('secrets_len', ctypes.c_uint32),
                                    ('rsvd1', ctypes.c_uint32),
                                    ('cpuid_phys', ctypes.c_uint64),
                                    ('cpuid_len', ctypes.c_uint32),
                                    ('rsvd2', ctypes.c_uint32)]


class struct_desc_struct(Structure):
    pass

struct_desc_struct._pack_ = 1 # source:True
struct_desc_struct._fields_ = [
    ('limit0', ctypes.c_uint16),
    ('base0', ctypes.c_uint16),
    ('base1', ctypes.c_uint16, 8),
    ('type', ctypes.c_uint16, 4),
    ('s', ctypes.c_uint16, 1),
    ('dpl', ctypes.c_uint16, 2),
    ('p', ctypes.c_uint16, 1),
    ('limit1', ctypes.c_uint16, 4),
    ('avl', ctypes.c_uint16, 1),
    ('l', ctypes.c_uint16, 1),
    ('d', ctypes.c_uint16, 1),
    ('g', ctypes.c_uint16, 1),
    ('base2', ctypes.c_uint16, 8),
]

__all__ = \
    ['E820_TYPE_ACPI', 'E820_TYPE_NVS', 'E820_TYPE_PMEM',
    'E820_TYPE_PRAM', 'E820_TYPE_RAM', 'E820_TYPE_RESERVED',
    'E820_TYPE_RESERVED_KERN', 'E820_TYPE_SOFT_RESERVED',
    'E820_TYPE_UNUSABLE', 'e820_type', 'struct_apm_bios_info',
    'struct_boot_e820_entry', 'struct_boot_params',
    'struct_desc_struct', 'struct_edd_device_params',
    'struct_edd_device_params_0_0', 'struct_edd_device_params_0_1',
    'struct_edd_device_params_0_2', 'struct_edd_device_params_0_3',
    'struct_edd_device_params_0_4', 'struct_edd_device_params_0_5',
    'struct_edd_device_params_1_0', 'struct_edd_device_params_1_1',
    'struct_edd_device_params_1_2', 'struct_edd_device_params_1_3',
    'struct_edd_device_params_1_4', 'struct_edd_device_params_1_5',
    'struct_edd_device_params_1_6', 'struct_edd_device_params_1_7',
    'struct_edd_device_params_1_8', 'struct_edd_device_params_1_9',
    'struct_edd_info', 'struct_edid_info', 'struct_efi_info',
    'struct_ist_info', 'struct_olpc_ofw_header', 'struct_screen_info',
    'struct_setup_header', 'struct_sys_desc_table',
    'struct_vmcb_save_area', 'struct_vmcb_save_area_0_0',
    'struct_vmcb_seg', 'union_edd_device_params_0',
    'union_edd_device_params_1', 'union_vmcb_save_area_0']
