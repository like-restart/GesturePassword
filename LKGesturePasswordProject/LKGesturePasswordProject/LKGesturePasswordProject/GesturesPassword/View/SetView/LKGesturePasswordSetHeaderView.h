//
//  LKGesturePasswordSetHeaderView.h
//  融贝网
//
//  Created by like on 2018/8/21.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * 定义头部视图中的title展示文字的多种状态类型
 */
typedef NS_ENUM(NSInteger, SetHeaderTitleStateType) {
    /*! 文字状态-还未进行绘制 */
    SetHeaderTitleStateType_FrontDraw,
    /*! 文字状态-绘制数量少于4个 */
    SetHeaderTitleStateType_FrontLimitDraw,
    /*! 文字状态-绘制完成（待验证） */
    SetHeaderTitleStateType_FinishDraw,
    /*! 文字状态-二次设置（验证失败） */
    SetHeaderTitleStateType_verifyFailDraw,
    /*! 文字状态-设置成功（验证成功） */
    SetHeaderTitleStateType_SuccessDraw
};


@interface LKGesturePasswordSetHeaderView : UIView
@property (nonatomic, readwrite, assign) SetHeaderTitleStateType stateType;

#pragma mark - - Create UI - -
/*!
 * 创建header view中的控件，并设置初始值
 */
- (void)layoutSetHeaderViewControls;

/*!
 * 改变手势里面被选中的按钮的图片（图片：normal）
 */
//- (void)changeNormalStateTypeWithGestureButton;

#pragma mark - - Highlighted Gesture View - -
/*!
 * 改变传递参数数组内的按钮下标值所指向的按钮的图片(highlighted)
 * @param buttonIndex_array 存放按钮下标值的数组
 */
- (void)changeHighlightedStateWithArray:(NSArray *)buttonIndex_array;
@end
