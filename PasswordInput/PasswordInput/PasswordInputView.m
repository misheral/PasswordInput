//
//  PasswordInputView.m
//  PasswordInput
//
//  Created by Misheral on 16/4/11.
//  Copyright © 2016年 YDX. All rights reserved.
//

#import "PasswordInputView.h"

@interface PasswordInputView ()

@property (nonatomic, weak) UIButton *okBtn;
@property (nonatomic, weak) UIButton *cancleBtn;

@property (nonatomic, strong) NSMutableArray *numbers;

@end

#define MaxNumCount 6

@implementation PasswordInputView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupNotifications];
        [self setupButtons];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNumber:) name:@"NumberChangedNotification" object:nil];
}

- (void)changeNumber:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *str = userInfo[@"InputNumber"];
    if (!str) {
        return;
    }
    if ([str isEqualToString:@""]) {
        [self delete];
        return;
    }
    if (self.numbers.count >= MaxNumCount) {
        return;
    }
    [self addNumber:str];
    
    if (self.numbers.count == MaxNumCount) {
        [self.okBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupButtons{
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.okBtn = okBtn;
  
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:253.0/255 green:84.0/255 blue:53.0/255 alpha:1] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn = cancelBtn;
}

- (void)okBtnSelected:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(passwordInputView:okBtnClick:)]) {
        [self.delegate passwordInputView:self okBtnClick:sender];
    }
}

- (void)cancelBtnSelected:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(passwordInputView:cancelBtnClick:)]) {
        [self.delegate passwordInputView:self cancelBtnClick:sender];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGRect okRect = self.okBtn.frame;
    CGRect cancelRect = self.cancleBtn.frame;
    
    cancelRect.size.width = screenWidth * 0.846875;
    cancelRect.size.height = screenWidth * 0.121875;
    cancelRect.origin.x = screenWidth * 0.05;
    cancelRect.origin.y = self.frame.size.height - (screenWidth * 0.05 + cancelRect.size.height);
    self.cancleBtn.frame = cancelRect;
    
    okRect = CGRectZero;
    self.okBtn.frame = okRect;
}

- (void)delete{
    [self.numbers removeLastObject];
    [self setNeedsDisplay];
}

- (void)addNumber:(NSString *)number{
    [self.numbers addObject:number];
    [self setNeedsDisplay];
}

- (NSMutableArray *)numbers{
    if (!_numbers) {
        _numbers = [NSMutableArray array];
    }
    return _numbers;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIImage *bg = [UIImage imageNamed:@"trade.bundle/pssword_bg"];
    UIImage *field = [UIImage imageNamed:@"trade.bundle/password_in"];
    
    [bg drawInRect:rect];
    
    CGFloat x = screenWidth * 0.096875 * 0.5;
    CGFloat y = screenWidth * 0.40625 * 0.5;
    CGFloat w = screenWidth * 0.846875;
    CGFloat h = screenWidth * 0.121875;
    [field drawInRect:CGRectMake(x, y, w, h)];
    
    NSString *title = self.title;
    if (!title) {
        title =  @"请输入密码";
    }
    
    NSDictionary *arrts = @{NSFontAttributeName:[UIFont systemFontOfSize:screenWidth * 0.053125]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
    CGFloat titleW = size.width;
    CGFloat titleH = size.height;
    CGFloat titleX = (CGRectGetWidth(self.frame) - titleW) * 0.5;
    CGFloat titleY = screenWidth * 0.03125;
    CGRect titleRect = CGRectMake(titleX, titleY, titleW, titleH);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:screenWidth * 0.053125];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    
    [title drawInRect:titleRect withAttributes:attr];
    
    UIImage *pointImage = [UIImage imageNamed:@"trade.bundle/spot"];
    CGFloat pointW = screenWidth * 0.05;
    CGFloat pointH = pointW;
    CGFloat pointY = screenWidth * 0.24;
    CGFloat pointX;
    CGFloat margin = screenWidth * 0.0484375;
    CGFloat padding = screenWidth * 0.045578125;
    for (int i = 0; i < self.numbers.count; i++) {
        pointX = margin + padding + i * (pointW + 2 * padding);
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }
    
    // 设置ok按钮状态，目前不显示ok按钮，但是输入数字达到MaxNumCount位，会自动发起ok按钮的点击事件
    BOOL status = NO;
    if (self.numbers.count == MaxNumCount) {
        status = YES;
    } else {
        status = NO;
    }
    self.okBtn.enabled = status;
}

- (NSString *)password{
    if (self.numbers.count >= MaxNumCount) {
        return [self.numbers componentsJoinedByString:@""];
    }
    return nil;
}

@end

