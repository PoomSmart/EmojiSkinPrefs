#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../PSHeader/Misc.h"
#import "../EmojiLibrary/Header.h"
#import "../EmojiLibrary/PSEmojiUtilities.h"
#import "Header.h"
#import <dlfcn.h>

static NSMutableDictionary <NSString *, NSString *> *skinCache = nil;

int SkinNumber = 0;

static void loadPrefs() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:realPrefPath(tweakIdentifier)];
    if (prefs)
        SkinNumber = [[prefs objectForKey:@"SkinNum"] intValue];
    [prefs release];
}

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