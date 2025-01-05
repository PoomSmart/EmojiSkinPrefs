#import <Preferences/PSListController.h>
#import <rootless.h>
#import "Header.h"
#import "../../PSPrefs/PSPrefs.x"

@interface EmojiSkinSettingsListController : PSListController
@end

@implementation EmojiSkinSettingsListController

- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Home" target:self];
    }
    return _specifiers;
}

- (void)loadView {
    [super loadView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    UIImage *bkIm = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:ROOT_PATH_NS(@"/Library/PreferenceBundles/EmojiSkinSettings.bundle")] pathForResource:@"Header" ofType:@"png"]];
    UIImageView *_background = [[UIImageView alloc] initWithImage:bkIm];
    _background.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [headerView addSubview:_background];

    CGRect frame = CGRectMake(0, 60, headerView.frame.size.width, 60);
    CGRect subFrame = CGRectMake(0, 120, headerView.frame.size.width, 40);

    UILabel *heading = [[UILabel alloc] initWithFrame:frame];
    heading.numberOfLines = 1;
    heading.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
    heading.text = @"EmojiSkinPrefs";
    heading.backgroundColor = UIColor.clearColor;
    heading.textColor = UIColor.yellowColor;
    heading.textAlignment = NSTextAlignmentCenter;

    UILabel *subtitle = [[UILabel alloc] initWithFrame:subFrame];
    subtitle.numberOfLines = 1;
    subtitle.backgroundColor = UIColor.clearColor;
    subtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    subtitle.text = @"By PoomSmart and vXBaKeRXv";

    subtitle.textColor = UIColor.labelColor; // TODO: Change
    subtitle.textAlignment = NSTextAlignmentCenter;

    heading.layer.shadowColor = UIColor.clearColor.CGColor;
    heading.layer.shadowOpacity = 1.0;
    heading.layer.shadowRadius = 1.5;
    heading.layer.shadowOffset = CGSizeMake(0.0, 2.0);

    subtitle.layer.shadowColor = UIColor.clearColor.CGColor;
    subtitle.layer.shadowOpacity = 1.0;
    subtitle.layer.shadowRadius = 1.5;
    subtitle.layer.shadowOffset = CGSizeMake(0.0, 2.0);

    [headerView addSubview:heading];
    [headerView addSubview:subtitle];
    self.table.tableHeaderView = headerView;
}

@end
