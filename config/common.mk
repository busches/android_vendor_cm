PRODUCT_BRAND ?= cyanogenmod

ifneq ($(TARGET_BOOTANIMATION_NAME),)
    PRODUCT_COPY_FILES += \
        vendor/cm/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif

ifdef CM_NIGHTLY
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmodnightly
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmod
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/cm/CHANGELOG.mkdn:system/etc/CHANGELOG-CM.txt

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/cm/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/cm/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/cm/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# Compcache/Zram support
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/init.local.rc:system/etc/init.local.rc \
    vendor/cm/prebuilt/common/bin/compcache:system/bin/compcache \
    vendor/cm/prebuilt/common/bin/handle_compcache:system/bin/handle_compcache

PRODUCT_COPY_FILES +=  \
    vendor/cm/proprietary/RomManager.apk:system/app/RomManager.apk \
    vendor/cm/proprietary/Term.apk:system/app/Term.apk \
    vendor/cm/proprietary/lib/armeabi/libjackpal-androidterm4.so:system/lib/libjackpal-androidterm4.so

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/cm/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/cm/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# This is CM!
PRODUCT_COPY_FILES += \
    vendor/cm/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/mkshrc:system/etc/mkshrc

# T-Mobile theme engine
include vendor/cm/config/themes_common.mk

# Required CM packages
PRODUCT_PACKAGES += \
    Camera \
    Development \
    LatinIME \
    SpareParts \
    Superuser \
    Superuser.apk \
    su

# Optional CM packages
PRODUCT_PACKAGES += \
    VoiceDialer \
    SoundRecorder \
    SpeechRecorder \
    Basic

# Custom CM packages
PRODUCT_PACKAGES += \
    Trebuchet

PRODUCT_PACKAGE_OVERLAYS += vendor/cm/overlay/dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/cm/overlay/common

PRODUCT_VERSION_MAJOR = 9
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0-RC0

# Set CM_BUILDTYPE
ifdef CM_NIGHTLY
    CM_BUILDTYPE := NIGHTLY
    CM_EXTRAVERSION_DATESTAMP := TRUE
    CM_EXTRAVERSION_TIMESTAMP_UTC := TRUE
endif
ifdef CM_SNAPSHOT
    CM_BUILDTYPE := SNAPSHOT
    CM_EXTRAVERSION_DATESTAMP := TRUE
    CM_EXTRAVERSION_TIMESTAMP_UTC := TRUE
endif
ifdef CM_EXPERIMENTAL
    CM_BUILDTYPE := EXPERIMENTAL
    CM_EXTRAVERSION_DATESTAMP := TRUE
    CM_EXTRAVERSION_TIMESTAMP_UTC := TRUE
endif
ifdef CM_RELEASE
    CM_BUILDTYPE := RELEASE
    CM_EXTRAVERSION := NOTUSED
endif

# If CM_BUILDTYPE is not defined, set to UNOFFICIAL
ifndef CM_BUILDTYPE
    CM_BUILDTYPE := UNOFFICIAL
endif

ifndef CM_EXTRAVERSION
    ifdef CM_EXTRAVERSION_TIMESTAMP
        ifdef CM_EXTRAVERSION_TIMESTAMP_UTC
            CM_EXTRAVERSION_TIMESTAMP := $(shell date -u +%Y%m%d_%H%M)
        else
            CM_EXTRAVERSION_TIMESTAMP := $(shell date +%Y%m%d_%H%M)
        endif
    else ifdef CM_EXTRAVERSION_DATESTAMP
        ifdef CM_EXTRAVERSION_TIMESTAMP_UTC
            CM_EXTRAVERSION_TIMESTAMP := $(shell date -u +%Y%m%d)
        else
            CM_EXTRAVERSION_TIMESTAMP := $(shell date +%Y%m%d)
        endif
    endif
    ifdef CM_EXTRAVERSION_TAG
        ifdef CM_EXTRAVERSION_TIMESTAMP
            CM_EXTRAVERSION := $(CM_EXTRAVERSION_TIMESTAMP)-$(CM_EXTRAVERSION_TAG)
        else
            CM_EXTRAVERSION := $(CM_EXTRAVERSION_TAG)
        endif
    else
        ifdef CM_EXTRAVERSION_TIMESTAMP
            CM_EXTRAVERSION := $(CM_EXTRAVERSION_TIMESTAMP)
        endif
    endif
endif


ifdef CM_RELEASE
    CM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(CM_BUILD)
else
    ifdef CM_EXTRAVERSION
        CM_VERSION := $(PRODUCT_VERSION_MAJOR)-$(CM_BUILDTYPE)-$(CM_EXTRAVERSION)-$(CM_BUILD)
    else
        CM_VERSION := $(PRODUCT_VERSION_MAJOR)-$(CM_BUILDTYPE)-$(CM_BUILD)
    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.cm.version=$(CM_VERSION) \
  ro.modversion=$(CM_VERSION)
