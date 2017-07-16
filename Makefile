PACKAGE_VERSION = 0.0.3
ifeq ($(SIMULATOR),1)
export SYSROOT = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk
endif

ifeq ($(SIMULATOR),1)
	TARGET = simulator:clang:latest:8.3
	ARCHS = x86_64 i386
else
	TARGET = iphone:clang:9.0:8.3
endif

THEOS_BUILD_DIR = Packages

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EmojiSkinPrefs
EmojiSkinPrefs_FILES = Tweak.xm
EmojiSkinPrefs_LIBRARIES = EmojiLibrary
EmojiSkinPrefs_USE_SUBSTRATE = 1

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += emojiskinsettings
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"

ifeq ($(SIMULATOR),1)
include ../preferenceloader/locatesim.mk
setup:: clean all
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
	$(ECHO_NOTHING)find $(PWD) -name .DS_Store | xargs rm -rf$(ECHO_END)
	@sudo cp -v $(PWD)/emojiskinsettings/entry.plist $(PL_SIMULATOR_PLISTS_PATH)/emojiskinSet.plist
	@sudo cp -vR $(THEOS_OBJ_DIR)/emojiskinSet.bundle $(PL_SIMULATOR_BUNDLES_PATH)/
endif
