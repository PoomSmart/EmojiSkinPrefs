ifeq ($(SIMULATOR),1)
	TARGET = simulator:clang:latest:8.3
	ARCHS = x86_64 i386
else
	TARGET = iphone:clang:11.2:8.3
endif

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = emojiskinSet
emojiskinSet_FILES = emojiskinSet.mm
emojiskinSet_INSTALL_PATH = /Library/PreferenceBundles
emojiskinSet_FRAMEWORKS = UIKit
emojiskinSet_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

ifneq ($(SIMULATOR),1)
internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/emojiskinSet.plist$(ECHO_END)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) -name .DS_Store | xargs rm -rf$(ECHO_END)
endif
