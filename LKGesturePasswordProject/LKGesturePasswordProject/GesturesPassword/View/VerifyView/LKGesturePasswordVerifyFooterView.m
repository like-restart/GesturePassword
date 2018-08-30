//
//  LKGesturePasswordVerifyFooterView.m
//  融贝网
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "LKGesturePasswordVerifyFooterView.h"
#import "LKCodeTools.h"//tools

@implementation LKGesturePasswordVerifyFooterView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutFooterViewControls];
    }
    return self;
}

/*!
 * 加载footer view中的控件
 */
- (void)layoutFooterViewControls
{
    //退出
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(84*Standard, 50*Standard, 86*Standard, 20*Standard);
    [logoutButton addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setTitle:@"退出当前账户" forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:14*Standard];
    [logoutButton setTitleColor:[UIColor colorWithHex:0x353B48] forState:UIControlStateNormal];
    [self addSubview:logoutButton];
    
    CGFloat intervalLine_x = logoutButton.frame.origin.x+logoutButton.frame.size.width+19*Standard;
    UILabel *intervalLine = [[UILabel alloc] initWithFrame:CGRectMake(intervalLine_x, 52*Standard, 1*Standard, 16*Standard)];
    intervalLine.backgroundColor = [UIColor colorWithHex:0xD2D2D2];
    [self addSubview:intervalLine];
    
    //退出
    CGFloat forgetButton_x = intervalLine.frame.origin.x+intervalLine.frame.size.width+19*Standard;
    UIButton *forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPasswordButton.frame = CGRectMake(forgetButton_x, 50*Standard, 86*Standard, 20*Standard);
    [forgetPasswordButton addTarget:self action:@selector(forgetPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPasswordButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    forgetPasswordButton.titleLabel.font = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:14*Standard];
    [forgetPasswordButton setTitleColor:[UIColor colorWithHex:0x353B48] forState:UIControlStateNormal];
    [self addSubview:forgetPasswordButton];
    
    //some remind
    CGFloat remindLabel_y = forgetPasswordButton.frame.origin.y+forgetPasswordButton.frame.size.height+11*Standard;
    UILabel *remindLabel = [[UILabel alloc] init];
    remindLabel.frame = CGRectMake(0, remindLabel_y, self.frame.size.width, 17*Standard);
    remindLabel.text = @"验证次数有限，请小心绘制";
    remindLabel.font = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:12*Standard];
    remindLabel.textColor = [UIColor colorWithHex:0x999999];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:remindLabel];
}

#pragma mark - - Click Action - -
/*!
 * 点击退出当前用户按钮，
 */
- (void)logoutAction:(id)sender
{
    if ([self.clickProtocol respondsToSelector:@selector(footerView:withClickType:)]) {
        [self.clickProtocol footerView:self withClickType:FooterViewClickType_Logout];
    }
}

/*!
 * 点击忘记手势密码按钮，
 */
- (void)forgetPasswordAction:(id)sender
{
    if ([self.clickProtocol respondsToSelector:@selector(footerView:withClickType:)]) {
        [self.clickProtocol footerView:self withClickType:FooterViewClickType_Forget];
    }
}

@end
