#import <Preferences/PSListController.h>

@interface emojiskinSetListController1 : PSListController
@end

@implementation emojiskinSetListController1
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"MLabelSettings1" target:self] retain];
    }
    return _specifiers;
}

- (void)refresh  {
}

static void RestartSpringBoard() {
    /*unlink("/User/Library/Caches/com.apple.springboard-imagecache-icons");
       unlink("/User/Library/Caches/com.apple.springboard-imagecache-icons.plist");
       unlink("/User/Library/Caches/com.apple.springboard-imagecache-smallicons");
       unlink("/User/Library/Caches/com.apple.springboard-imagecache-smallicons.plist");

       unlink("/User/Library/Caches/com.apple.SpringBoard.folderSwitcherLinen");
       unlink("/User/Library/Caches/com.apple.SpringBoard.notificationCenterLinen");

       unlink("/User/Library/Caches/com.apple.SpringBoard.folderSwitcherLinen.0");
       unlink("/User/Library/Caches/com.apple.SpringBoard.folderSwitcherLinen.1");
       unlink("/User/Library/Caches/com.apple.SpringBoard.folderSwitcherLinen.2");
       unlink("/User/Library/Caches/com.apple.SpringBoard.folderSwitcherLinen.3");

       system("rm -rf /User/Library/Caches/SpringBoardIconCache");
       system("rm -rf /User/Library/Caches/SpringBoardIconCache-small");
       system("rm -rf /User/Library/Caches/com.apple.IconsCache");
       system("rm -rf /User/Library/Caches/com.apple.newsstand");
       system("rm -rf /User/Library/Caches/com.apple.springboard.sharedimagecache");
       system("rm -rf /User/Library/Caches/com.apple.UIStatusBar");

       system("rm -rf /User/Library/Caches/BarDialer");
       system("rm -rf /User/Library/Caches/BarDialer_selected");
       system("rm -rf /User/Library/Caches/BarRecents");
       system("rm -rf /User/Library/Caches/BarRecents_selected");
       system("rm -rf /User/Library/Caches/BarVM");
       system("rm -rf /User/Library/Caches/BarVM_selected");

       system("killall -9 lsd");
       if (kCFCoreFoundationVersionNumber > 700) // XXX: iOS 6.x
        system("killall backboardd");
       else
        system("killall SpringBoard");*/
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

}

- (void)rightButtonPressed {
    [self.view endEditing:YES];
    RestartSpringBoard();

}

@end

// vim:ft=objc
