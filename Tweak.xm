#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../PSHeader/Misc.h"
#import "../EmojiLibrary/Header.h"
#import "../EmojiLibrary/PSEmojiUtilities.h"
#import "Header.h"
#import <dlfcn.h>

static NSMutableDictionary <NSString *, NSString *> *skinCache = nil;

BOOL SkinKeyOff = NO;
BOOL UpdateToneOff = NO;

int SkinNumber = 0;

static void loadPrefs() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:realPrefPath(tweakIdentifier)];
    if (prefs) {
        SkinKeyOff = [[prefs objectForKey:@"SkinKeyOff"] boolValue];
        UpdateToneOff = [[prefs objectForKey:@"UpdateToneOff"] boolValue];
        SkinNumber = [[prefs objectForKey:@"SkinNum"] intValue];
    }
    [prefs release];
}

%hook UIKeyboardEmojiInputController // iOS < 11

- (void)updateSkinToneBaseKey:(NSString *)base variantUsed:(NSString *)variant {
    if (UpdateToneOff)
        return;
    %orig;
}

%end

%hook UIKeyboardEmojiCollectionInputView

- (BOOL)skinToneWasUsedForEmoji:(NSString *)emoji {
    return SkinNumber ? YES : %orig;
}

// Shouldn't go well with NoMoreSkinToneSuggestion
- (UIKeyboardEmojiCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIKeyboardEmojiCollectionViewCell *cell = %orig;
    if ((cell.emoji.variantMask & PSEmojiTypeSkin) && SkinNumber) {
        NSString *emojiString = cell.emoji.emojiString;
        if (skinCache[emojiString] == nil) {
            NSString *skin = [PSEmojiUtilities skinModifiers][SkinNumber - 1];
            if ([PSEmojiUtilities hasSkin:emojiString])
                cell.emoji.emojiString = [PSEmojiUtilities changeEmojiSkin:emojiString toSkin:skin];
            else
                cell.emoji.emojiString = [PSEmojiUtilities skinToneVariant:emojiString skin:skin];
            skinCache[emojiString] = cell.emoji.emojiString;
        } else
            cell.emoji.emojiString = skinCache[emojiString];
        cell.emoji = cell.emoji;
    }
    return cell;
}

%end

// Don't see the point of hooking this
/*%hook UIKeyboardEmoji

- (id)initWithString:(NSString *)string withVariantMask:(NSInteger)variantMask {
    return %orig(string, SkinKeyOff ? (variantMask & ~2) : variantMask);
}

%end*/

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.vxbakerxv.emojiskinSet/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
    skinCache = [[NSMutableDictionary dictionary] retain];
    %init;
}

%dtor {
    if (skinCache)
        [skinCache release];
}