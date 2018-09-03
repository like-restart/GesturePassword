//
//  LKGesturePasswordView.h
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//
/*! 此类为承载所有的手势密码按钮的view类，并且承载Touch事件和手势状态处理 */


#import <UIKit/UIKit.h>
#import "LKGesturePasswordSingleButton.h"//single button

/*! 密码路径绘制代理，回调到主View中进行相关逻辑处理，本类不做复杂逻辑处理，只提供方法 */
@protocol GesturePasswordInputProtocol <NSObject>
/*!
 * 传递当前手指触碰的按钮
 *
 * @param button_index 当前按钮的下标值
 * @param isEnd 是否出发了TouchesEnded函数，结束了绘制
 */
- (void)gesturePasswordWithButtonIndex:(NSInteger)button_index withInputState:(BOOL)isEnd;
@end

@interface LKGesturePasswordView : UIView
@property (nonatomic, readwrite, assign) id<GesturePasswordInputProtocol> gestureInputProtocol;


#pragma mark - - Create UI - -
/*!
 * 添加9个手势按钮
 */
- (void)layoutSingleButtonControls;

/*!
 * 添加9个手势按钮-缩小版
 */
- (void)layoutLittleSingleButtonControls;

#pragma mark - - Highlighted Gesture View - -
/*!
 * 改变传递参数数组内的按钮下标值所指向的按钮的图片
 * @param state_type 将要改变的按钮的状态
 * @param buttonIndex_array 存放按钮下标值的数组
 */
- (void)changeButtonStateWithStateType:(GesturePasswordButtonStateType)state_type withArray:(NSArray *)buttonIndex_array;

#pragma mark - - Error Gesture View - -
/*!
 * 改变手势里面所有连接线的颜色（红色：error）
 */
- (void)changeErrorColorWithShapeLayerLine;

/*!
 * 改变手势里面被选中的按钮的图片（图片：error）
 */
- (void)changeErrorStateTypeWithGestureButton;

#pragma mark - - Clear Gesture View - -
/*!
 * 移除所有的Layer（绘制的所有线段）
 */
- (void)removeShapeLayerFromView;

/*!
 * 改变手势里面被选中的按钮的图片（图片：normal）
 */
- (void)changeNormalStateTypeWithGestureButton;
@end
