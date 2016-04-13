//
//  PasswordView.h
//  PasswordInput
//
//  Created by Misheral on 16/4/11.
//  Copyright © 2016年 YDX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordView : UIView

@property (nonatomic,copy) void (^finish) (NSString *password);

- (void)show;
- (void)showInView:(UIView *)view;

@end
