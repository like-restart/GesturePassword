//
//  LKGesturePasswordVerifyView.m
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "LKGesturePasswordVerifyView.h"

#import "LKGesturePasswordView.h"//gesture view
#import "LKGesturePasswordVerifyHeaderView.h"//header view
#import "LKGesturePasswordVerifyFooterView.h"//footer view

#import "LKCodeTools.h"//tools

@interface LKGesturePasswordVerifyView ()<FooterViewClickProtocol, GesturePasswordInputProtocol>

@property (nonatomic, readwrite, strong) LKGesturePasswordView *gestureView;
@property (nonatomic, readwrite, strong) LKGesturePasswordVerifyHeaderView *verifyHeaderView;
@property (nonatomic, readwrite, strong) LKGesturePasswordVerifyFooterView *verifyFooterView;

@property (nonatomic, readwrite, strong) UIButton *closeButton;//关闭按钮

@end

@implementation LKGesturePasswordVerifyView

#pragma mark - - Create UI - -
/*!
* 构建验证页面的所有控件
*/
- (void)layoutVerifyViewControls
{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.closeButton setHidden:NO];
    //添加九个控件
    [self.gestureView layoutSingleButtonControls];
    self.verifyHeaderView.isWrong = NO;//设置为NO
    self.verifyFooterView.clickProtocol = self;//protocol
}

#pragma mark - - Gesture Password Protocol - -
- (void)gesturePasswordWithButtonIndex:(NSInteger)button_index withInputState:(BOOL)isEnd
{
    //view model 调用手势密码保存方法
    [self.verifyViewModel dealWithGesturePasswordWithType:GesturePasswordType_Verify withButtonIndex:button_index withInputState:isEnd withResultsBlock:^(NSDictionary * _Nonnull resultsDict) {
        
        NSNumber *stateType = resultsDict[gesture_stateType];
        NSNumber *resultsBool = resultsDict[results_bool];
        NSNumber *validNums = resultsDict[valid_nums];
        switch ([stateType integerValue]) {
            case GesturePasswordStateType_Verify:
            {
                if ([resultsBool boolValue]) {//验证成功
                    if ([self.verifyResultProtocol respondsToSelector:@selector(gesturePassword:withVerifyResult:)]) {
                        [self.verifyResultProtocol gesturePassword:self withVerifyResult:YES];
                    }
                }else {//验证失败，修改所有的绘制为error状态
                    if ([validNums integerValue] < 5) {//小于五次内，可重复绘制
                        [self.gestureView changeErrorStateTypeWithGestureButton];
                        [self.gestureView changeErrorColorWithShapeLayerLine];
                        
                        //头部区域显示错误状态
                        self.verifyHeaderView.numsOfValidLogin = [validNums integerValue];
                        self.verifyHeaderView.isWrong = YES;
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.gestureView changeNormalStateTypeWithGestureButton];
                            [self.gestureView removeShapeLayerFromView];
                            
                            self.verifyHeaderView.isWrong = NO;
                        });
                    }else {//超过五次，直接返回失败处理
                        if ([self.verifyResultProtocol respondsToSelector:@selector(gesturePassword:withVerifyResult:)]) {
                            [self.verifyResultProtocol gesturePassword:self withVerifyResult:NO];
                        }
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark - - Footer Protocol - -
- (void)footerView:(UIView *)footerView withClickType:(FooterViewClickType)click_type
{
    switch (click_type) {
        case FooterViewClickType_Forget:
        {
            //跳转到登录页面
//#error 在这里添加跳转到登录页面的代码
        }
            break;
        case FooterViewClickType_Logout:
        {
            //清空本地账户信息，进入到首页
            [self.verifyViewModel ClearUsersDataAndEnterAPP];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - - Click Action - -
/*!
 * 点击关闭按钮触发的事件
 */
- (void)clickCloseAction:(id)sender
{
    [self.verifyViewModel closeTheCurrentViewAction];
}

#pragma mark - - Setter and Getter - -
/*!
 * 中间手势密码区域view-gesture
 *
 * @return LKGesturePasswordView
 */
- (LKGesturePasswordView *)gestureView
{
    if (!_gestureView) {
        CGFloat gestureView_y = self.verifyHeaderView.frame.origin.y+self.verifyHeaderView.frame.size.height+47*Standard;
        CGFloat gestureView_wh = self.frame.size.width-67*Standard*2;
        _gestureView = [[LKGesturePasswordView alloc] init];
        _gestureView.frame = CGRectMake(67*Standard, gestureView_y, gestureView_wh, gestureView_wh);
        _gestureView.gestureInputProtocol = self;//protocol
        _gestureView.backgroundColor = [UIColor whiteColor];//设置白色背景用来解决重绘过程中会出现重影的问题
        [self addSubview:_gestureView];
    }
    return _gestureView;
}

/*!
 * 验证页面头部区域view-header
 *
 * @return LKGesturePasswordVerifyHeaderView
 */
- (LKGesturePasswordVerifyHeaderView *)verifyHeaderView
{
    if (!_verifyHeaderView) {
        _verifyHeaderView = [[LKGesturePasswordVerifyHeaderView alloc] initWithFrame:CGRectMake(0, NaviegationHeight, self.frame.size.width, 125*Standard)];
        [self addSubview:_verifyHeaderView];
    }
    return _verifyHeaderView;
}

/*!
 * 验证页面底部区域view-footer
 *
 * @return LKGesturePasswordVerifyFooterView
 */
- (LKGesturePasswordVerifyFooterView *)verifyFooterView
{
    if (!_verifyFooterView) {
        _verifyFooterView = [[LKGesturePasswordVerifyFooterView alloc] initWithFrame:CGRectMake(0, self.gestureView.frame.origin.y+self.gestureView.frame.size.height, self.frame.size.width, 100*Standard)];
        [self addSubview:_verifyFooterView];
    }
    return _verifyFooterView;
}

/*!
 * 添加页面关闭按钮
 */
- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setFrame:CGRectMake(10, NaviegationHeight-44, 40, 44)];
        [_closeButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    }
    return _closeButton;
}
@end
