//
//  UIAlertController+LKTouchIDAlertController.m
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/22.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "UIAlertController+LKTouchIDAlertController.h"

#import <LocalAuthentication/LocalAuthentication.h>//Touch ID
#import "LKCodeTools.h"//tools

@implementation UIAlertController (LKTouchIDAlertController)

+ (void)alertControllerWithResultsBlock:(void(^)(BOOL isVerify, BOOL isSaveOfPassword))resultsBlock
{
    //init authentication class
    LAContext *context = [[LAContext alloc] init];
    //获取设备是否支持TouchID
    BOOL isSupportTouchID = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    //8.0版本以上支持TouchID
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_0 && isSupportTouchID) {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"手势密码设置成功" message:@"是否启用Touch ID指纹解锁?" preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //block返回-取消了TouchID 所以手势密码也同样不保存
            resultsBlock(NO, NO);
        }]];
        [alertCon addAction:[UIAlertAction actionWithTitle:@"启用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //处理指纹
            [self showTouchIdControlsWithContext:context withVerifyBlock:^(VerifyTouchIDState state) {
                switch (state) {
                    case VerifyTouchIDState_Success:
                    {
                        //TouchID 验证成功，保存手势密码，
                        resultsBlock(YES, YES);
                    }
                        break;
                    case VerifyTouchIDState_Fail:
                    {
                        //TouchID 验证失败，所以手势密码也同样不保存
                        resultsBlock(NO, NO);
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        }]];
        [[LKCodeTools getVisibleViewControler] presentViewController:alertCon animated:YES completion:^{
            
        }];
    }else {
        //不支持TouchId，直接返回，但是需要保存手势密码
        resultsBlock(NO, YES);
    }
}

+ (void)showTouchIdControlsWithContext:(LAContext *)context withVerifyBlock:(void(^)(VerifyTouchIDState state))verifyBlock
{
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
        //指纹密码验证成功
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"TouchID 验证成功");
                //回调，保存手势密码
                verifyBlock(VerifyTouchIDState_Success);
            });
        }else if(error){//发生错误
            verifyBlock(VerifyTouchIDState_Fail);
            
            switch (error.code) {
                case LAErrorAuthenticationFailed:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 验证失败");
                    });
                    break;
                }
                case LAErrorUserCancel:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 被用户手动取消");
                    });
                }
                    break;
                case LAErrorUserFallback:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"用户不使用TouchID,选择手动输入密码");
                    });
                }
                    break;
                case LAErrorSystemCancel:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                    });
                }
                    break;
                case LAErrorPasscodeNotSet:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                        //请先在系统设置－Touch ID与密码中开启
//#error 在这里进行设置中配置TouchId的弹框提示
                    });
                }
                    break;
                case LAErrorTouchIDNotEnrolled:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                        //请先在系统设置－Touch ID与密码中开启
//#error 在这里进行设置中配置TouchId的弹框提示
                    });
                }
                    break;
                case LAErrorTouchIDNotAvailable:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 无效");
                    });
                }
                    break;
                case LAErrorTouchIDLockout:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                    });
                }
                    break;
                case LAErrorAppCancel:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                    });
                }
                    break;
                case LAErrorInvalidContext:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                    });
                }
                    break;
                default:
                    break;
            }
        }
    }];
}
@end
