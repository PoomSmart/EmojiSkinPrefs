PACKAGE_VERSION = 1.0.0

ifeq ($(SIMULATOR),1)
    TARGET = simulator:clang:latest:8.3
    ARCHS = arm64 x86_64 i386
else
ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
    TARGET = iphone:clang:16.5:15.0
else
    TARGET = iphone:clang:14.5:8.3
    export PREFIX = $(THEOS)/toolchain/Xcode11.xctoolchain/usr/bin/
endif
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EmojiSkinPrefs
$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_LIBRARIES = EmojiLibrary
$(TWEAK_NAME)_USE_SUBSTRATE = 1

include $(THEOS_MAKE_PATH)/tweak.mk

ifeq ($(SIMULATOR),1)
include ../preferenceloader/locatesim.mk
setup:: clean all
    @rm -f /opt/simject/$(TWEAK_NAME).dylib
    @cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject
    @cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
    @sudo cp -v $(PWD)/emojiskinsettings/entry.plist $(PL_SIMULATOR_PLISTS_PATH)/emojiskinSet.plist
    @sudo cp -vR $(THEOS_OBJ_DIR)/emojiskinSet.bundle $(PL_SIMULATOR_BUNDLES_PATH)/
else
endif
