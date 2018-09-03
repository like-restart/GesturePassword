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

+ (void)alertControllerWithResultsBlock:(void(^)(BOOL isVerify, BOOL isSaveOfPassword))resultsBlock;
@end
