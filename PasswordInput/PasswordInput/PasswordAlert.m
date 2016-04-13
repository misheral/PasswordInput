//
//  PasswordAlert.m
//  PasswordInput
//
//  Created by Misheral on 16/4/13.
//  Copyright © 2016年 YDX. All rights reserved.
//

#import "PasswordAlert.h"

#import "PasswordInputView.h"

@interface PasswordAlert ()<UITextFieldDelegate,PasswordInputViewDelegate>

@property (nonatomic, weak) UITextField *responsder;
@property (nonatomic, weak) PasswordInputView *inputView;

@property (nonatomic, copy) NSString *passWord;

@end

@implementation PasswordAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNotifications];
    [self setupEffect];
    [self setupInputView];
    [self setupResponsder];
    [self layoutViews];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)setupEffect
{
    UIVisualEffectView *effect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effect.frame = self.view.bounds;
    effect.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:effect];
}

- (void)coverClick
{
    if ((0)) {
        if(self.responsder.isEditing){
            [self hiddenKeyboard];
        }else{
            [self showKeyboard];
        }
    }
}

- (void)setupInputView
{
    PasswordInputView *inputView = [[PasswordInputView alloc] init];
    inputView.delegate = self;
    inputView.title = @"请输入提现密码";
    self.inputView = inputView;
    [self.view addSubview:inputView];
}

- (void)setupResponsder
{
    UITextField *responsder = [[UITextField alloc] init];
    responsder.keyboardType = UIKeyboardTypeNumberPad;
    responsder.delegate = self;
    [self.view addSubview:responsder];
    self.responsder = responsder;
}

- (void)showKeyboard{
    [self.responsder becomeFirstResponder];
}

- (void)hiddenKeyboard{
    [self.responsder resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputView.transform = CGAffineTransformMakeTranslation(0, (CGRectGetMinX(self.inputView.frame)-height+100));
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)show{
    UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [vc presentViewController:self animated:YES completion:^{}];
}

- (void)layoutViews{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = self.inputView.frame;
    rect.size.height = screenWidth * 0.5625;
    rect.size.width = screenWidth * 0.94375;
    rect.origin.y = (CGRectGetHeight(self.view.frame) - CGRectGetHeight(rect)) * 0.5;
    rect.origin.x = (screenWidth - CGRectGetWidth(rect)) * 0.5;
    self.inputView.frame = rect;
    [self showKeyboard];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSDictionary *userfo = @{@"InputNumber":string};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NumberChangedNotification" object:self userInfo:userfo];
    return YES;
}

- (void)passwordInputView:(PasswordInputView *)view okBtnClick:(UIButton *)okBtn{
    NSString *password = view.password;
    if (self.finish) {
        self.finish(password);
    }
    [self hiddenKeyboard];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)passwordInputView:(PasswordInputView *)view cancelBtnClick:(UIButton *)cancelBtn{
    [self hiddenKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
