//
//  ViewController.m
//  PasswordInput
//
//  Created by Misheral on 16/4/11.
//  Copyright © 2016年 YDX. All rights reserved.
//

#import "ViewController.h"

#import "PasswordView.h"
#import "PasswordAlert.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
//两种处理的方法，都只要调用show方法即可
    
//第一方法：弹出试图
    
//    PasswordView *alert = [[PasswordView alloc] init];
//    alert.finish = ^(NSString *password){
//        NSLog(@"输入的密码为：%@",password);
//    };
//    [alert show];
    
//第二种方法，present vc
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PasswordAlert *alert = [[PasswordAlert alloc] init];
        alert.finish = ^(NSString *password){
            NSLog(@"%@",password);
        };
        [alert show];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
