//
//  LKGesturePasswordSingleButton.h
//  融贝网
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//
/*! 此类为手势密码中单个密码项控件 */

#import <UIKit/UIKit.h>

/*! 手势密码按钮的状态类型 */
typedef NS_ENUM(NSInteger, GesturePasswordButtonStateType) {
    /*! 手势密码按钮普通状态模式 */
    GesturePasswordButtonStateType_Normal,
    /*! 手势密码按钮选中状态模式 */
    GesturePasswordButtonStateType_Highlighted,
    /*! 手势密码按钮错误状态模式 */
    GesturePasswordButtonStateType_Error
};

@interface LKGesturePasswordSingleButton : UIButton
@property (nonatomic, readwrite, assign) GesturePasswordButtonStateType stateType;

/*!
 * 设置手势密码按钮的图片等属性
 */
- (void)layoutSingleButtonControls;
@end
