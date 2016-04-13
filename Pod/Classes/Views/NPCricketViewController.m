#import "NPCricketViewController.h"
#import "UIView+NPStyle.h"
#import "UIColor+NPCricket.h"

@interface NPCricketViewController ()

@property (nonatomic) UIImage *screenshot;
@property (nonatomic) UIImage *annotatedScreenshot;
@property (nonatomic) NSString *message;
@property (nonatomic) UIAlertController *alertController;

@end

@implementation NPCricketViewController

#pragma mark - Initialization

- (instancetype)initWithScreenshot:(UIImage *)screenshot {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"NPCricket" withExtension:@"bundle"];
    self = [super initWithNibName:@"NPCricketViewController" bundle:[NSBundle bundleWithURL:bundleURL]];
    if (self) {
        self.screenshot = screenshot;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        self.alertController = [UIAlertController alertControllerWithTitle:@"说点什么让我们更容易找到问题:]"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [self.alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"例如：这个地方文字重叠了";
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 [self animateOutScreenshotImageView];
                                                             }];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"发送"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             UITextField *textField = [self.alertController.textFields firstObject];
                                                             self.message = textField.text;
                                                             [self submit];
                                                         }];
        [self.alertController addAction:cancelAction];
        [self.alertController addAction:okAction];
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.screenshotImageView.delegate = self;
    self.screenshotImageView.image = self.screenshot;
    self.screenshotImageView.hidden = YES;
    [self.screenshotImageView NP_applyShadow];

    self.headerLabel.text = @"点击或者画圈将问题标注出来";
    self.headerLabel.backgroundColor = [UIColor NP_cricketGreen];
    self.headerLabel.textColor = [UIColor whiteColor];
    [self.headerLabel NP_applyShadow];

    self.headerLabelYLayoutConstraint.constant = -CGRectGetHeight(self.headerLabel.frame);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self animateInOutHeaderLabel];
    [self animateInScreenshotImageView];
}

#pragma mark - Submitting

- (void)submit {
    [self.delegate cricketViewController:self
                        didSubmitMessage:self.message
                              screenshot:self.annotatedScreenshot];
}

#pragma mark - Animation Transitions

- (void)animateInOutHeaderLabel {
    self.headerLabel.alpha = 0;
    self.headerLabelYLayoutConstraint.constant = 0.0;

    [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{
        self.headerLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                self.headerLabel.alpha = 0;
            } completion:nil];
        });

    }];
}

- (void)animateInScreenshotImageView {
    self.screenshotImageView.alpha = 0.0;
    self.screenshotImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.screenshotImageView.hidden = NO;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:0 animations:^{
        self.screenshotImageView.alpha = 1.0;
        self.screenshotImageView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)animateOutScreenshotImageView {
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:0 animations:^{
        self.screenshotImageView.alpha = 0.0;
        self.screenshotImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self.delegate cricketViewControllerDidCancel:self];
    }];
}

#pragma mark - NPAnnotatedImageViewDelegate

- (void)annotatedImageView:(NPAnnotatedImageView *)annotatedImageView didFinishWithScreenshot:(UIImage *)screenshot {
    self.annotatedScreenshot = screenshot;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

@end
