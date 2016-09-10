include theos/makefiles/common.mk
export ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest

TWEAK_NAME = TickTock
TickTock_FILES = TickTock.xm
TickTock_FRAMEWORKS = UIKit AudioToolbox CoreFoundation Foundation AVFoundation

include $(THEOS_MAKE_PATH)/tweak.mk

include $(THEOS_MAKE_PATH)/aggregate.mk

internal-stage::
	mkdir -p $(THEOS_STAGING_DIR)/System/Library/Audio/UISounds/TickTock
	cp UISounds/*.caf $(THEOS_STAGING_DIR)/System/Library/Audio/UISounds/TickTock/

after-install::
	install.exec "killall -9 SpringBoard"
