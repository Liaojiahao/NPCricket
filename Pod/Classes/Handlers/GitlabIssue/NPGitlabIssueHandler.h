//
//  NPGitlabIssueHandler.h
//  Pods
//
//  Created by 周国勇 on 4/13/16.
//
//

#import <Foundation/Foundation.h>
#import "NPCricketHandlerProtocol.h"

@interface NPGitlabIssueHandler : NSObject<NPCricketHandler>

+ (instancetype)handlerWithPrivateKey:(NSString *)privateKey projectId:(NSString *)projectId baseUrl:(NSString *)baseUrl;

@end
