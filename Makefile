ARCHS = armv7 arm64
TARGET = iphone::4.3

TWEAK_NAME = VideoPace
VideoPace_FILES = Tweak.x
VIdeoPace_FRAMEWORKS = UIKit

ADDITIONAL_CFLAGS = -std=c99

include theos/makefiles/common.mk
include theos/makefiles/tweak.mk
