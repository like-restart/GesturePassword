//
//  LKGesturePasswordSetHeaderView.m
//  融贝网
//
//  Created by like on 2018/8/21.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "LKGesturePasswordSetHeaderView.h"

#import "LKGesturePasswordView.h"//gesture view

#import "LKCodeTools.h"//tools
#import "CALayer+LKShakeAnimation.h"//shake animation

@interface LKGesturePasswordSetHeaderView ()
@property (nonatomic, readwrite, strong) LKGesturePasswordView *gestureView;

/*!
 * 头部视图中的title控件，此控件内容有多种状态
 *
 * 未绘制之前：设置手势密码（黑色）
 * 连接点少于四个：最少连接点4个点，请重新输入（红色）
 * 绘制完成（验证）：再次绘制解锁图案（红色）
 * 绘制完成：设置成功（红色）
 */
@property (nonatomic, readwrite, strong) UILabel *headerTitleLabel;
@end

@implementation LKGesturePasswordSetHeaderView

#pragma mark - - Create UI - -
/*!
 * 创建header view中的控件，并设置初始值
 */
- (void)layoutSetHeaderViewControls
{
    [self.gestureView layoutLittleSingleButtonControls];
    self.stateType = SetHeaderTitleStateType_FrontDraw;//默认值
}

#pragma mark - - Highlighted Gesture View - -
/*!
 * 改变传递参数数组内的按钮下标值所指向的按钮的图片(highlighted)
 * @param buttonIndex_array 存放按钮下标值的数组
 */
- (void)changeHighlightedStateWithArray:(NSArray *)buttonIndex_array
{
    [self.gestureView changeButtonStateWithStateType:GesturePasswordButtonStateType_Highlighted withArray:buttonIndex_array];
}

#pragma mark - - Setter and Getter - -
/*!
 * 头部视图中用于展示密码效果的键盘view-gesture
 *
 * @return LKGesturePasswordView
 */
- (LKGesturePasswordView *)gestureView
{
    if (!_gestureView) {
        _gestureView = [[LKGesturePasswordView alloc] init];
        _gestureView.frame = CGRectMake((self.frame.size.width-36*Standard)/2, 20*Standard, 36*Standard, 36*Standard);
        _gestureView.userInteractionEnabled = NO;//这个小型键盘只用于展示，不可操作
        [self addSubview:_gestureView];
    }
    return _gestureView;
}

/*!
 * 头部视图中用于展示密码锁状态的文字提示
 *
 * @return UILabel
 */
- (UILabel *)headerTitleLabel
{
    if (!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.gestureView.frame.origin.y+self.gestureView.frame.size.height+21*Standard, self.frame.size.width, 20*Standard)];
        _headerTitleLabel.font = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:14*Standard];
        _headerTitleLabel.textColor = [UIColor colorWithHex:0x999999];
        _headerTitleLabel.highlightedTextColor = [UIColor colorWithHex:0xFF5E5B];
        _headerTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_headerTitleLabel];
    }
    return _headerTitleLabel;
}

/*!
 * 设置头部视图中的文字提示的状态，并且修改提示的文字内容
 */
- (void)setStateType:(SetHeaderTitleStateType)stateType
{
    _stateType = stateType;
    //先预置为YES，表示字体颜色为红色
    self.headerTitleLabel.highlighted = YES;
    switch (stateType) {
        case SetHeaderTitleStateType_FrontDraw:
        {
            [self.headerTitleLabel setText:@"设置手势密码"];
            self.headerTitleLabel.highlighted = NO;
        }
            break;
        case SetHeaderTitleStateType_FrontLimitDraw:
        {
            [self.headerTitleLabel setText:@"最少连接点4个点，请重新输入"];
            [self.headerTitleLabel.layer shakeOfAnimation];
        }
            break;
        case SetHeaderTitleStateType_FinishDraw:
        {
            [self.headerTitleLabel setText:@"再次绘制解锁图案"];
        }
            break;
        case SetHeaderTitleStateType_verifyFailDraw:
        {
            [self.headerTitleLabel setText:@"与上次绘制不一致，请重新绘制"];
            [self.headerTitleLabel.layer shakeOfAnimation];
        }
            break;
        case SetHeaderTitleStateType_SuccessDraw:
        {
            [self.headerTitleLabel setText:@"设置成功"];
        }
            break;
            
        default:
            break;
    }
}
@end
