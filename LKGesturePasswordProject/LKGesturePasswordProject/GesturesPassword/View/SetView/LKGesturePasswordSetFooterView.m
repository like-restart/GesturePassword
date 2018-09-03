//
//  LKGesturePasswordSetFooterView.m
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/21.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "LKGesturePasswordSetFooterView.h"

#import "LKCodeTools.h"//tools

@implementation LKGesturePasswordSetFooterView
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
    //重设
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resetButton.frame = CGRectMake((self.frame.size.width-86*Standard)/2, 31*Standard, 86*Standard, 20*Standard);
    [resetButton addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton setTitle:@"重设手势密码" forState:UIControlStateNormal];
    resetButton.titleLabel.font = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:14*Standard];
    [resetButton setTitleColor:[UIColor colorWithHex:0x353B48] forState:UIControlStateNormal];
    [self addSubview:resetButton];
}

#pragma mark - - Click Action - -
/*!
 * 点击"重设手势密码"
 */
- (void)resetAction:(id)sender
{
    if ([self.clickProtocol respondsToSelector:@selector(footerView:withClickType:)]) {
        [self.clickProtocol footerView:self withClickType:FooterViewClickType_Reset];
    }
}
@end
