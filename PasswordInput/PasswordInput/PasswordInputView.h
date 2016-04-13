//
//  PasswordInputView.h
//  PasswordInput
//
//  Created by Misheral on 16/4/11.
//  Copyright © 2016年 YDX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PasswordInputView;

@protocol PasswordInputViewDelegate <NSObject>

@optional
- (void)passwordInputView:(PasswordInputView *)view okBtnClick:(UIButton *)okBtn;
- (void)passwordInputView:(PasswordInputView *)view cancelBtnClick:(UIButton *)cancelBtn;

@end

@interface PasswordInputView : UIView

@property (nonatomic, weak) id<PasswordInputViewDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *password;

@property (nonatomic, copy) NSString *title;

@end
