#import <Foundation/Foundation.h>
#import "NPCricketViewController.h"
#import "NPCricketHandlerProtocol.h"
#import "NPGitlabIssueHandler.h"

@interface NPCricket : NSObject <NPCricketViewControllerDelegate>

+ (void)useHandler:(id<NPCricketHandler>)handler;
+ (void)show;

@end
