#define CHECK_TARGET
#import <PSHeader/Misc.h>
#import <PSHeader/PS.h>
#import <EmojiLibrary/Header.h>
#import <EmojiLibrary/PSEmojiUtilities.h>
#import <dlfcn.h>
#import "Header.h"

static NSMutableDictionary <NSString *, NSString *> *skinCache = nil;

int SkinNumber = 0;

static void loadPrefs() {
    NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:realPrefPath(tweakIdentifier)];
    if (prefs)
        SkinNumber = [[prefs objectForKey:@"SkinNum"] intValue];
}

%hook UIKeyboardEmojiCollectionInputView

- (BOOL)skinToneWasUsedForEmoji:(NSString *)emoji {
    return SkinNumber ? YES : %orig;
}

// Shouldn't go well with NoMoreSkinToneSuggestion
- (UIKeyboardEmojiCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIKeyboardEmojiCollectionViewCell *cell = %orig;
    if (!SkinNumber) return cell;
    NSString *emojiString = cell.emoji.emojiString;
    BOOL supportSkin = [cell isKindOfClass:NSClassFromString(@"UIKeyboardEmojiCollectionViewCell")] && ((cell.emoji.variantMask & PSEmojiTypeSkin) || [PSEmojiUtilities hasSkinToneVariants:emojiString]);
    if (!supportSkin) return cell;
    if (skinCache[emojiString] == nil) {
        NSString *skin = [PSEmojiUtilities skinModifiers][SkinNumber - 1];
        if ([PSEmojiUtilities hasSkin:emojiString])
            cell.emoji.emojiString = [PSEmojiUtilities changeEmojiSkin:emojiString toSkin:skin];
        else {
            NSArray <NSString *> *skinVariants = [PSEmojiUtilities skinToneVariantsForString:emojiString withSelf:NO];
            cell.emoji.emojiString = skinVariants[SkinNumber - 1];
        }
        skinCache[emojiString] = cell.emoji.emojiString;
    } else
        cell.emoji.emojiString = skinCache[emojiString];
    cell.emoji = cell.emoji;
    return cell;
}

%end

%ctor {
    if (isTarget(TargetTypeApps | TargetTypeGenericExtensions)) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.vxbakerxv.emojiskinSet/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        loadPrefs();
        skinCache = [NSMutableDictionary dictionary];
        %init;
    }
}
