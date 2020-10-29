export ARCHS = arm64
export TARGET = iphone:clang:14.0:13.0
# export PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

INSTALL_TARGET_PROCESSES = Grapher

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = Grapher

Grapher_XCODE_SCHEME = Grapher
Grapher_CODESIGN_FLAGS = -SgrapherEntitlements.xml

include $(THEOS_MAKE_PATH)/xcodeproj.mk

purge::
	$(ECHO_BEGIN)$(PRINT_FORMAT_RED) "Purging"$(ECHO_END); $(ECHO_PIPEFAIL)
	find . -name '.theos' -exec rm -rf {} \; -o -name 'packages' -exec rm -rf {} \; -o -name '.dragon' -exec rm -rf {} \; -o -name '*.ninja' -exec rm -rf {} \; -o -name '.DS_Store' -exec rm -rf {} \; 2>&1 | grep -v 'find' ; echo -n ""
