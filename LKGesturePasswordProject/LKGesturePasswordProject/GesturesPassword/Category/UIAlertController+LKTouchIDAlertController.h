//
//  UIAlertController+LKTouchIDAlertController.h
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/22.
//  Copyright © 2018年 No Company. All rights reserved.
//


#import <UIKit/UIKit.h>

/*! TouchID验证状态 */
typedef NS_ENUM(NSInteger, VerifyTouchIDState)
{
    /*! TouchID验证成功 */
    VerifyTouchIDState_Success,
    /*! TouchID验证失败 */
    VerifyTouchIDState_Fail
};

/*! TouchID状态和用户数据保存状态 */
typedef NS_ENUM(NSInteger, UsersTouchIDState)
{
    /*! TouchID被取消+用户数据不保存 */
    UsersTouchIDState_Cancel_Unsave,
    /*! TouchID验证失败+用户数据不保存 */
    UsersTouchIDState_VerifyFail_Unsave,
    /*! TouchID设备不支持+用户数据保存 */
    UsersTouchIDState_Unsupport_Save,
    /*! TouchID验证成功+用户数据保存 */
    UsersTouchIDState_VerifySuccess_Save
};

@interface UIAlertController (LKTouchIDAlertController)

/*!
 * 启用指纹功能来设置手势密码
 *
 * resultsBlock (isVerify:YES-TouchId验证成功|NO-失败 isSaveOfPassword:YES-保存手势密码|NO-不保存)
 */
+ (void)alertControllerWithResultsBlock:(void(^)(BOOL isVerify, BOOL isSaveOfPassword))resultsBlock;

/*!
 * 启用指纹功能来验证手势密码
 *
 * verifyBlock (isVerify:YES-TouchId验证成功|NO-失败)
 */
+ (void)alertControllerWithVerifyTouchIDWithBlock:(void(^)(BOOL isVerify))verifyBlock;
@end
