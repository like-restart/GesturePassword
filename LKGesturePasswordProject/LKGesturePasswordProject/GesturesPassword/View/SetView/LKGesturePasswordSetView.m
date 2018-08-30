//
//  LKGesturePasswordSetView.m
//  融贝网
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "LKGesturePasswordSetView.h"

#import "LKGesturePasswordView.h"//gesture view
#import "LKGesturePasswordSetHeaderView.h"//header view
#import "LKGesturePasswordSetFooterView.h"//footer view

#import "LKCodeTools.h"//tools
#import "UIAlertController+LKTouchIDAlertController.h"//alert con

@interface LKGesturePasswordSetView () <GesturePasswordInputProtocol, FooterViewClickProtocol>
@property (nonatomic, readwrite, strong) LKGesturePasswordView *gestureView;
@property (nonatomic, readwrite, strong) LKGesturePasswordSetHeaderView *setHeaderView;
@property (nonatomic, readwrite, strong) LKGesturePasswordSetFooterView *setFooterView;

@property (nonatomic, readwrite, strong) UIButton *closeButton;//关闭按钮

@end

@implementation LKGesturePasswordSetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.closeButton setHidden:NO];
    }
    return self;
}

#pragma mark - - Create UI - -
/*!
 * 构建验证页面的所有控件
 */
- (void)layoutSetViewControls
{
    //添加九个控件
    [self.gestureView layoutSingleButtonControls];
    [self.setHeaderView layoutSetHeaderViewControls];
    self.setFooterView.clickProtocol = self;//protocol
}

#pragma mark - - Gesture Password Protocol - -
- (void)gesturePasswordWithButtonIndex:(NSInteger)button_index withInputState:(BOOL)isEnd
{
    __weak typeof(self) weakSelf = self;
    //view model 调用手势密码保存方法
    [self.setViewModel dealWithGesturePasswordWithType:GesturePasswordType_Set withButtonIndex:button_index withInputState:isEnd withResultsBlock:^(NSDictionary * _Nonnull resultsDict) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSNumber *stateType = resultsDict[gesture_stateType];
        NSNumber *resultsBool = resultsDict[results_bool];
        NSNumber *conformMinLimit = resultsDict[conform_minLimit];
        switch ([stateType integerValue]) {
            case GesturePasswordStateType_First:
            {
                if ([resultsBool boolValue]) {//第一次设置成功
                    if ([conformMinLimit boolValue]) {
                        //清空所有的绘制
                        [self.gestureView changeNormalStateTypeWithGestureButton];
                        [self.gestureView removeShapeLayerFromView];
                        
                        //在头部视图中的缩小版本的手势图中展示出所绘制的按钮
                        [self.setHeaderView changeHighlightedStateWithArray:resultsDict[highlightedIndex_array]];
                        //修改头部视图中的title文字状态样式
                        self.setHeaderView.stateType = SetHeaderTitleStateType_FinishDraw;
                    }else {//不符合长度
                        [self.gestureView changeErrorStateTypeWithGestureButton];
                        [self.gestureView changeErrorColorWithShapeLayerLine];
                        //1s后恢复正常状态
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.gestureView changeNormalStateTypeWithGestureButton];
                            [self.gestureView removeShapeLayerFromView];
                        });
                        
                        //修改头部视图中的title文字状态样式
                        self.setHeaderView.stateType = SetHeaderTitleStateType_FrontLimitDraw;
                    }
                }
            }
                break;
            case GesturePasswordStateType_Second:
            {
                if ([resultsBool boolValue]) {//验证成功
                    //修改头部视图中的title文字状态样式
                    self.setHeaderView.stateType = SetHeaderTitleStateType_SuccessDraw;
                    
                    /*!
                     * 调用系统指纹
                     * 同意-最终执行保存手势密码，且和指纹密码进行绑定，然后跳出页面，下次打开APP的时候要启用密码验证环节
                     * 不同意-跳出密码设置页面
                     */
                    [UIAlertController alertControllerWithResultsBlock:^(BOOL isVerify, BOOL isSaveOfPassword) {
                        /*!
                         * touchId取消+不保存 NO:NO
                         * 验证成功+保存 YES:YES
                         * 验证失败+不保存 NO:NO
                         * TouchId不支持+保存 NO:YES
                         */
                        [strongSelf.setViewModel saveTouchId:isVerify withGesturePassword:isSaveOfPassword];
                    }];
                    
                }else {//验证失败
                    [self.gestureView changeErrorStateTypeWithGestureButton];
                    [self.gestureView changeErrorColorWithShapeLayerLine];
                    //1s后恢复正常状态
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.gestureView changeNormalStateTypeWithGestureButton];
                        [self.gestureView removeShapeLayerFromView];
                    });
                    //修改头部视图中的title文字状态样式
                    self.setHeaderView.stateType = SetHeaderTitleStateType_verifyFailDraw;
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
        case FooterViewClickType_Reset:
        {
            //重置手势密码
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
    [self.setViewModel closeTheCurrentViewAction];
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
        CGFloat gestureView_y = self.setHeaderView.frame.origin.y+self.setHeaderView.frame.size.height+47*Standard;
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
 * 设置页面头部区域view-header
 *
 * @return LKGesturePasswordVerifyHeaderView
 */
- (LKGesturePasswordSetHeaderView *)setHeaderView
{
    if (!_setHeaderView) {
        _setHeaderView = [[LKGesturePasswordSetHeaderView alloc] initWithFrame:CGRectMake(0, NaviegationHeight, self.frame.size.width, 203*Standard)];
        [self addSubview:_setHeaderView];
    }
    return _setHeaderView;
}

/*!
 * 设置手势密码页面底部区域view-footer
 *
 * @return LKGesturePasswordSetFooterView
 */
- (LKGesturePasswordSetFooterView *)setFooterView
{
    if (!_setFooterView) {
        _setFooterView = [[LKGesturePasswordSetFooterView alloc] initWithFrame:CGRectMake(0, self.gestureView.frame.origin.y+self.gestureView.frame.size.height, self.frame.size.width, 100*Standard)];
        [self addSubview:_setFooterView];
    }
    return _setFooterView;
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
