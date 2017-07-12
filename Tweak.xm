#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#define EMOJI_SKIN_PREFS
#import "../EmojiLibrary/Emoji10.h"
#import "../EmojiLibrary/Header.h"
#import "../EmojiLibrary/Functions.x"

static BOOL SkinPopNull = NO;
static BOOL TapSkinNull = NO;

int SkinNumber = 1;

static void loadPrefs() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.vxbakerxv.emojiskinprefs.plist"];
    if (prefs) {
        SkinPopNull = [[prefs objectForKey:@"SkinPopBool"] boolValue];
        TapSkinNull = [[prefs objectForKey:@"TapSkinBool"] boolValue];
        SkinNumber = [[prefs objectForKey:@"SkinNum"] intValue];
    }
    [prefs release];
}

static NSMutableDictionary *fullSkinTone_cache = nil;
static NSMutableDictionary *fullSkinTone() {
    if (fullSkinTone_cache == nil) {
        fullSkinTone_cache = [[NSMutableDictionary dictionary] retain];
        NSString *skin = skinModifiers[SkinNumber - 1];
        for (UIKeyboardEmoji *emoji in ((UIKeyboardEmojiCategory *)[NSClassFromString(@"UIKeyboardEmojiCategory") categoryForType:0]).emoji) {
            NSString *emojiString = emoji.emojiString;
            if (hasVariantsForEmoji(emojiString) >= 2) {
                NSString *_emojiBaseString = emojiBaseString(emojiString);
                fullSkinTone_cache[_emojiBaseString] = skinToneVariant(_emojiBaseString, nil, nil, skin);
            }
        }
        for (UIKeyboardEmoji *emoji in ((UIKeyboardEmojiCategory *)[NSClassFromString(@"UIKeyboardEmojiCategory") categoryForType:1]).emoji) {
            NSString *emojiString = emoji.emojiString;
            if (hasVariantsForEmoji(emojiString) >= 2) {
                NSString *_emojiBaseString = emojiBaseString(emojiString);
                fullSkinTone_cache[_emojiBaseString] = skinToneVariant(_emojiBaseString, nil, nil, skin);
            }

        }
        for (UIKeyboardEmoji *emoji in ((UIKeyboardEmojiCategory *)[NSClassFromString(@"UIKeyboardEmojiCategory") categoryForType:4]).emoji) {
            NSString *emojiString = emoji.emojiString;
            if (hasVariantsForEmoji(emojiString) >= 2) {
                NSString *_emojiBaseString = emojiBaseString(emojiString);
                fullSkinTone_cache[_emojiBaseString] = skinToneVariant(_emojiBaseString, nil, nil, skin);
            }
        }
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
    %init;
}
