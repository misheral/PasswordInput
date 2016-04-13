//
//  PasswordAlert.h
//  PasswordInput
//
//  Created by Misheral on 16/4/13.
//  Copyright © 2016年 YDX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordAlert : UIViewController

@property (nonatomic,copy) void (^finish) (NSString *password);

- (void)show;

@end
