#import "NPCricketMailgunHandler.h"
#import <mailgun/Mailgun.h>
#import <mailgun/MGMessage.h>
#import "NSString+NPEmail.h"

@interface NPCricketMailgunHandler ()

@property (nonatomic) NSString *toEmailAddress;
@property (nonatomic) NSString *subjectPrefix;
@property (nonatomic) Mailgun *mailgun;

@end

@implementation NPCricketMailgunHandler

+ (instancetype)handlerWithToEmailAddress:(NSString *)toEmailAddress
                            subjectPrefix:(NSString *)subjectPrefix
                                   domain:(NSString *)domain
                                   apiKey:(NSString *)apiKey {
    NPCricketMailgunHandler *handler = [[NPCricketMailgunHandler alloc] init];
    handler.subjectPrefix = subjectPrefix;
    handler.toEmailAddress = toEmailAddress;
    handler.mailgun = [Mailgun clientWithDomain:domain apiKey:apiKey];
    return handler;
}

#pragma mark - NPCricketHandler

- (void)NPCricket_processMessage:(NSString *)message screenshot:(UIImage *)screenshot {
    MGMessage *mailgunMessage = [MGMessage messageFrom:@"Cricket"
                                                    to:[NSString stringWithFormat:@"<%@>", self.toEmailAddress]
                                               subject:[message NP_subjectWithPrefix:self.subjectPrefix]
                                                  body:message];
    [mailgunMessage addImage:screenshot withName:@"screenshot.jpeg" type:JPEGFileType];
    [self.mailgun sendMessage:mailgunMessage];
}

@end
