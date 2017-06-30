#define KILL_PROCESS
#import "../../PS.h"
#import <Preferences/PSListController.h>

@interface emojiskinSetListController : PSListController
@end

@implementation emojiskinSetListController

- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Home" target:self] retain];
    }
    return _specifiers;
}

- (void)refresh {
}

static void RestartSpringBoard() {
    killProcess("SpringBoard");
}

- (void)viewWillAppear:(BOOL)animated {
    //[self clearCache];
    [self reload];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed)] autorelease];
    [self.navigationItem setRightBarButtonItem:rightButton];

    [self HeaderCell];
}

- (void)rightButtonPressed {
    [self.view endEditing:YES];
    RestartSpringBoard();

}

- (void)HeaderCell {
    @autoreleasepool {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 60)];
        UIImage *bkIm = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/emojiskinSet.bundle"] pathForResource:@"Header" ofType:@"png"]];
        UIImageView *_background = [[UIImageView alloc] initWithImage:bkIm];
        _background.frame = CGRectMake((0 / 2) - (bkIm.size.width / 2), (60 / 2) - (bkIm.size.height / 2), bkIm.size.width, bkIm.size.height);
        [_background setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [headerView addSubview:_background];


        int width = [[UIScreen mainScreen] bounds].size.width;

        CGRect frame = CGRectMake(0, 10, width, 60);
        CGRect subFrame = CGRectMake(0, 70, width, 40);

        UILabel *heading = [[UILabel alloc] initWithFrame:frame];
        [heading setNumberOfLines:1];
        heading.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
        [heading setText:@"EmojiSkinPrefs"];
        [heading setBackgroundColor:[UIColor clearColor]];
        heading.textColor = [UIColor yellowColor];
        heading.textAlignment = NSTextAlignmentCenter;

        UILabel *subtitle = [[UILabel alloc] initWithFrame:subFrame];
        [subtitle setNumberOfLines:1];
        subtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        [subtitle setText:@"By vXBaKeRXv"];

        subtitle.textColor = [UIColor brownColor];
        subtitle.textAlignment = NSTextAlignmentCenter;

        [heading.layer setShadowColor:[UIColor clearColor].CGColor];
        [heading.layer setShadowOpacity:1.0];
        [heading.layer setShadowRadius:1.5];
        [heading.layer setShadowOffset:CGSizeMake(0.0, 2.0)];

        [subtitle.layer setShadowColor:[UIColor clearColor].CGColor];
        [subtitle.layer setShadowOpacity:1.0];
        [subtitle.layer setShadowRadius:1.5];
        [subtitle.layer setShadowOffset:CGSizeMake(0.0, 2.0)];

        [self.table addSubview:heading];
        [self.table addSubview:subtitle];
        [self.table setTableHeaderView:headerView];
        [self.table sendSubviewToBack:headerView];


    }
}

- (void)vxbakerxvTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/vxbakerxv"]];
}

@end

// vim:ft=objc
