#define CHECK_TARGET
#import <Foundation/NSUserDefaults+Private.h>
#import <PSHeader/Misc.h>
#import <PSHeader/PS.h>
#import <EmojiLibrary/Header.h>
#import <EmojiLibrary/PSEmojiUtilities.h>
#import <dlfcn.h>

static NSMutableDictionary <NSString *, NSString *> *skinCache = nil;

int SkinNumber = 0;

static void loadPrefs() {
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:@"SkinNum" inDomain:@"com.apple.UIKit"];
    SkinNumber = value ? [value intValue] : 0;
    [skinCache removeAllObjects];
}

%hook UIKeyboardEmojiCollectionInputView

- (BOOL)skinToneWasUsedForEmoji:(NSString *)emoji {
    return SkinNumber ? YES : %orig;
}

// Shouldn't go well with NoMoreSkinToneSuggestion
- (UIKeyboardEmojiCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIKeyboardEmojiCollectionViewCell *cell = %orig;
    if (!SkinNumber) return cell;
    if (![cell isKindOfClass:NSClassFromString(@"UIKeyboardEmojiCollectionViewCell")]) return cell;
    NSString *emojiString = cell.emoji.emojiString;
    if (!(cell.emoji.variantMask & PSEmojiTypeSkin) && ![PSEmojiUtilities hasSkinToneVariants:emojiString]) return cell;
    if (skinCache[emojiString] == nil) {
        NSString *baseString = [PSEmojiUtilities emojiBaseString:emojiString];
        BOOL isMultiSkin = [PSEmojiUtilities isCoupleMultiSkinToneEmoji:baseString];
        NSArray <NSString *> *skinVariants = [PSEmojiUtilities skinToneVariantsForString:emojiString withSelf:NO];
        skinCache[emojiString] = cell.emoji.emojiString = skinVariants[(SkinNumber - 1) * (isMultiSkin ? 6 : 1)];
    } else
        cell.emoji.emojiString = skinCache[emojiString];
    cell.emoji = cell.emoji;
    return cell;
}

%end

%ctor {
    if (isTarget(TargetTypeApps | TargetTypeGenericExtensions)) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.apple.UIKit/esp.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        loadPrefs();
        skinCache = [NSMutableDictionary dictionary];
        %init;
    }
}
