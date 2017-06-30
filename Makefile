DEBUG = 0

ifeq ($(SIMULATOR),1)
	TARGET = simulator:clang:latest
	ARCHS = x86_64 i386
else
	TARGET = iphone:clang:latest:9.0
endif

THEOS_BUILD_DIR = Packages

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EmojiSkinPrefs
EmojiSkinPrefs_FILES = Tweak.xm
EmojiSkinPrefs_USE_SUBSTRATE = 1
EmojiSkinPrefs_FRAMEWORKS = UIKit Foundation
EmojiSkinPrefs_PRIVATE_FRAMEWORKS = SpringBoardUI

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += emojiskinsettings
include $(THEOS_MAKE_PATH)/aggregate.mk

internal-stage::


after-install::
	install.exec "killall -9 SpringBoard"

all::
ifeq ($(SIMULATOR),1)
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
endif
