#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a55

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

# Boot image
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_BOOT_HEADER_VERSION := 4
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_RAMDISK_USE_LZ4 := true
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_KERNEL_CMDLINE += bootopt=64S3,32N2,64N2
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_BASE := 0x3fff8000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x26f08000
BOARD_KERNEL_TAGS_OFFSET := 0x07c88000
BOARD_DTB_OFFSET := 0x07c88000

BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := X6837
TARGET_NO_BOOTLOADER := true

# Broken Rules
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Display
TARGET_SCREEN_DENSITY := 396

# DTB
BOARD_PREBUILT_DTBOIMAGE := $(KERNEL_PATH)/dtbo.img
BOARD_PREBUILT_DTBIMAGE_DIR := $(KERNEL_PATH)/dtb

# Kernel
TARGET_NO_KERNEL_OVERRIDE := true
LOCAL_KERNEL := $(KERNEL_PATH)/Image.gz
PRODUCT_COPY_FILES += \
	$(LOCAL_KERNEL):kernel

# Kernel modules
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/modules.load.vendor_ramdisk))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(addprefix $(KERNEL_PATH)/modules/, $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD))

# Also add recovery modules to vendor ramdisk
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/modules.load.recovery))
RECOVERY_MODULES := $(addprefix $(KERNEL_PATH)/modules/, $(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD))

# Prevent duplicated entries (to solve duplicated build rules problem)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(sort $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES) $(RECOVERY_MODULES))

BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/modules.load))
BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(KERNEL_PATH)/modules/*.ko)

# Workaround to make lineage's soong generator work
TARGET_KERNEL_SOURCE := $(KERNEL_PATH)/kernel-headers

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144 # BOARD_KERNEL_PAGESIZE * 64
BOARD_DTBOIMG_PARTITION_SIZE := 33554432
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864

BOARD_SUPER_PARTITION_SIZE := 8717107200
BOARD_SUPER_PARTITION_GROUPS := mtk_dynamic_partitions

BOARD_MTK_DYNAMIC_PARTITIONS_PARTITION_LIST := odm_dlkm product system system_ext vendor vendor_dlkm
BOARD_MTK_DYNAMIC_PARTITIONS_SIZE := 8712912896 # BOARD_SUPER_PARTITION_SIZE - 4MB

BOARD_EROFS_PCLUSTER_SIZE := 262144

BOARD_USES_METADATA_PARTITION := true
BOARD_USES_ODM_DLKIMAGE := true
BOARD_USES_VENDOR_DLKMIMAGE := true

BOARD_ODM_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4

TARGET_COPY_OUT_ODM_DLKM := odm_dlkm
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm

# Platform
TARGET_BOARD_PLATFORM := mt6789
BOARD_HAS_MTK_HARDWARE := true

# Power
TARGET_POWERHAL_MODE_EXT := $(COMMON_PATH)/power/power-mode.cpp

# Properties
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/configs/properties/product.prop
TARGET_SYSTEM_PROP += $(CONFIGS_PATH)/configs/properties/system.prop
TARGET_VENDOR_PROP += $(CONFIGS_PATH)/configs/properties/vendor.prop

# Recovery
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab.mt6789
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_USERIMAGES_USE_F2FS := true

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# SEPolicy
include device/mediatek/sepolicy_vndr/SEPolicy.mk

# Vendor Security Patch
VENDOR_SECURITY_PATCH := 2024-05-05

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag

BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA2048
BOARD_AVB_BOOT_ROLLBACK_INDEX := 1
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 1

BOARD_AVB_VBMETA_SYSTEM := product system system_ext
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := 1
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

BOARD_AVB_VBMETA_VENDOR := vendor
BOARD_AVB_VBMETA_VENDOR_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_VENDOR_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := 1
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 3

# VNDK
BOARD_VNDK_VERSION := current

# VINTF
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(COMMON_PATH)/configs/vintf/framework_compatibility_matrix.xml
DEVICE_MANIFEST_FILE := $(COMMON_PATH)/configs/vintf/manifest.xml
DEVICE_MATRIX_FILE := $(COMMON_PATH)/configs/vintf/compatibility_matrix.xml

# Wi-Fi
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_HOSTAPD_DRIVER := NL80211
WIFI_DRIVER_FW_PATH_PARAM := /dev/wmtWifi
WIFI_DRIVER_FW_PATH_STA := STA
WIFI_DRIVER_FW_PATH_AP := AP
WIFI_DRIVER_FW_PATH_P2P := P2P
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true

# Inherit the proprietary files
include vendor/infinix/X6837/BoardConfigVendor.mk
