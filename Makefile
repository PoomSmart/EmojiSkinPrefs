PACKAGE_VERSION = 0.0.6a

ifeq ($(SIMULATOR),1)
	TARGET = simulator:clang:latest:8.3
	ARCHS = x86_64 i386
else
	TARGET = iphone:clang:latest:8.3
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EmojiSkinPrefs
EmojiSkinPrefs_FILES = Tweak.xm
EmojiSkinPrefs_LIBRARIES = EmojiLibrary
EmojiSkinPrefs_USE_SUBSTRATE = 1

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += emojiskinsettings
include $(THEOS_MAKE_PATH)/aggregate.mk

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
