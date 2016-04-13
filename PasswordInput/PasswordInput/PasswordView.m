//
//  PasswordView.m
//  PasswordInput
//
//  Created by Misheral on 16/4/11.
//  Copyright © 2016年 YDX. All rights reserved.
//

#import "PasswordView.h"
#import "PasswordInputView.h"

@interface PasswordView ()<UITextFieldDelegate,PasswordInputViewDelegate>

@property (nonatomic, weak) UIButton *cover;
@property (nonatomic, weak) UITextField *responsder;
@property (nonatomic, weak) PasswordInputView *inputView;

@property (nonatomic, copy) NSString *passWord;

@end

@implementation PasswordView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self setupNotifications];
        [self setupCover];
        [self setupInputView];
        [self setupResponsder];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupCover
{
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cover];
    self.cover = cover;
    [self.cover setBackgroundColor:[UIColor blackColor]];
    self.cover.alpha = 0.4;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
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
    [self addSubview:inputView];
}

- (void)setupResponsder
{
    UITextField *responsder = [[UITextField alloc] init];
    responsder.keyboardType = UIKeyboardTypeNumberPad;
    responsder.delegate = self;
    [self addSubview:responsder];
    self.responsder = responsder;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.cover.frame = self.bounds;
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
    [self showInView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = self.inputView.frame;
    rect.size.height = screenWidth * 0.5625;
    rect.size.width = screenWidth * 0.94375;
    rect.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(rect)) * 0.5;
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
    [self removeFromSuperview];
}

- (void)passwordInputView:(PasswordInputView *)view cancelBtnClick:(UIButton *)cancelBtn{
    [self removeFromSuperview];
}

@end
