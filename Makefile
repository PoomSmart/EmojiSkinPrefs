DEBUG = 0
PACKAGE_VERSION = 0.0.2

ifeq ($(SIMULATOR),1)
	TARGET = simulator:clang:latest
	ARCHS = x86_64 i386
else
	TARGET = iphone:clang:9.0:9.0
endif

THEOS_BUILD_DIR = Packages

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EmojiSkinPrefs
EmojiSkinPrefs_FILES = Tweak.xm
EmojiSkinPrefs_USE_SUBSTRATE = 1

include $(THEOS_MAKE_PATH)/tweak.mk

ifneq ($(SIMULATOR),1)
SUBPROJECTS += emojiskinsettings
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"

endif

ifeq ($(SIMULATOR),1)
all::
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
endif
