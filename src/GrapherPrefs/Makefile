include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = GrapherPrefs

GrapherPrefs_FILES = $(wildcard *.m)
GrapherPrefs_INSTALL_PATH = /Library/PreferenceBundles
GrapherPrefs_FRAMEWORKS = UIKit
GrapherPrefs_PRIVATE_FRAMEWORKS = Preferences
GrapherPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/GrapherPrefs.plist$(ECHO_END)