#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../PSHeader/Misc.h"
#import "../EmojiLibrary/Header.h"
#import "../EmojiLibrary/PSEmojiUtilities.h"
#import "Header.h"
#import <dlfcn.h>

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

%hook UIKeyboardEmojiInputController

- (void)updateSkinToneBaseKey: (NSString *)base variantUsed: (NSString *)variant {
    if (UpdateToneOff)
        return;
    %orig;
}

%end

%hook UIKeyboardEmojiCollectionInputView

- (UIKeyboardEmojiCollectionViewCell *)collectionView: (UICollectionView *)collectionView cellForItemAtIndexPath: (NSIndexPath *)indexPath {
    UIKeyboardEmojiCollectionViewCell *cell = %orig;
    if (cell.emoji.variantMask >= 2 && SkinNumber) {
        cell.emoji.emojiString = [PSEmojiUtilities changeEmojiSkin:cell.emoji.emojiString toSkin:[PSEmojiUtilities skinModifiers][SkinNumber]];
        cell.emoji = cell.emoji;
    }
    return cell;
}

%end

%hook UIKeyboardEmoji

- (id)initWithString: (NSString *)string withVariantMask: (NSInteger)variantMask {
    return %orig(string, SkinKeyOff ? 0 : variantMask);
}

%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.vxbakerxv.emojiskinSet/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
    %init;
}
