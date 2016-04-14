#import "NPAppDelegate.h"
#import <NPCricket/NPCricket.h>
#import <NPCricket/NPNativeEmailHandler.h>
#import <NPCricket/NPGitlabIssueHandler.h>
#import "NPHomeViewController.h"

@implementation NPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NPGitlabIssueHandler *handler = [NPGitlabIssueHandler handlerWithPrivateKey:@"xxx" projectId:@"iOS/xxx" baseUrl:@"https://gitlab.xxxx.com"];
    [NPCricket useHandler:handler];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NPHomeViewController *viewController = [[NPHomeViewController alloc] init];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [NPCricket show];
    }
}

@end
