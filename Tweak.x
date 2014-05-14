#import <AVFoundation/AVFoundation.h>

static float rateFactor;
static float inverseRateFactor = 1.0f;

%hook AVPlayer

- (void)setRate:(float)rate
{
    %orig(rate * rateFactor);
}

- (float)rate
{
    return %orig() * inverseRateFactor;
}

%end

static void LoadSettings(void)
{
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.rpetrich.videopace.plist"];
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    if (bundleIdentifier) {
        id temp = [settings objectForKey:[@"VP-" stringByAppendingString:bundleIdentifier]];
        rateFactor = temp ? [temp floatValue] : 1.0f;
        inverseRateFactor = 1.0f / rateFactor;
    }
}

%ctor {
    @autoreleasepool {
        %init();
        LoadSettings();
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (void *)LoadSettings, CFSTR("com.rpetrich.videopace.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    }
}
