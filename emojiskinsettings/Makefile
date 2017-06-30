include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = emojiskinSet
emojiskinSet_FILES = emojiskinSet.mm emojiskinSet1.mm
emojiskinSet_INSTALL_PATH = /Library/PreferenceBundles
emojiskinSet_FRAMEWORKS = UIKit Foundation
emojiskinSet_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/emojiskinSet.plist$(ECHO_END)
