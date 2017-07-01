#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#define EMOJI_SKIN_PREFS
#import "../EmojiLibrary/Emoji10.h"
#import "../EmojiLibrary/Functions.x"

static BOOL SkinPopNull = NO;
static BOOL TapSkinNull = NO;

int SkinNumber = 0;
static NSArray *skins = @[@"🏻", @"🏼", @"🏽", @"🏾", @"🏿"];

static void loadPrefs() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.vxbakerxv.emojiskinprefs.plist"];
    if (prefs) {
        SkinPopNull = [[prefs objectForKey:@"SkinPopBool"] boolValue];
        TapSkinNull = [[prefs objectForKey:@"TapSkinBool"] boolValue];
        SkinNumber = [[prefs objectForKey:@"SkinNum"] intValue];
    }
    [prefs release];
}

static NSString *skinnedEmoji(NSString *emoji, NSString *skin) {
    NSString *skinned = [NSString stringWithFormat:@"%@%@", emojiBaseString(emoji), skin];
    NSString *base = emojiBaseFirstCharacterString(skinned);
    NSString *trueSkinned = base.length == 1 ? skinned : [NSString stringWithFormat:@"%@%@%@", base, skin, [skinned substringWithRange:NSMakeRange(base.length, skinned.length - 4)]];
    return trueSkinned;
}

static NSMutableDictionary *fullSkinTone_cache = nil;
static NSMutableDictionary *fullSkinTone() {
    if (fullSkinTone_cache == nil) {
        fullSkinTone_cache = [[NSMutableDictionary dictionary] retain];
        NSString *skin = skins[SkinNumber - 1];
        for (NSString *base in SkinToneEmoji)
            fullSkinTone_cache[base] = skinnedEmoji(base, skin);
    }
    return fullSkinTone_cache;
}

%hook UIKeyboardEmojiCollectionInputView

- (id)tappedSkinToneEmoji {
    return TapSkinNull ? nil : %orig;
}

%end

%hook UIKeyboardEmoji

- (id)initWithString: (NSString *)string withVariantMask: (NSInteger)variantMask {
    return %orig(string, SkinPopNull ? 0 : variantMask);
}

%end


%hook UIKeyboardEmojiPreferences

- (NSDictionary *)skinToneBaseKeyPreferences {
    return SkinNumber != 0 ? fullSkinTone() : %orig;
}

%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.vxbakerxv.emojiskinSet/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
    dlopen("/Library/MobileSubstrate/DynamicLibraries/Emoji10WT.dylib", RTLD_LAZY);
    dlopen("/Library/MobileSubstrate/DynamicLibraries/Emoji10PS.dylib", RTLD_LAZY);
    dlopen("/Library/MobileSubstrate/DynamicLibraries/Emoji10Fix.dylib", RTLD_LAZY);
    %init;
}
