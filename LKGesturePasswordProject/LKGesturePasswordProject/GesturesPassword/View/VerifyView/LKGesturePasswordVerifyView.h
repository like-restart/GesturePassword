//
//  LKGesturePasswordVerifyView.h
//  融贝网
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//
/*! 此类为手势密码验证界面的主View，此页面承载了GestureView、headerView、footerView */

#import <UIKit/UIKit.h>
#import "LKGesturePasswordViewModel.h"//view model

/*!
 * 手势密码验证结果返回的代理
 */
@protocol GesturePasswordVerifyResultProtocol <NSObject>
/*!
 * 代理方法，返回密码验证是否成功
 *
 * @param verifyView 当前view对象
 * @param verifyResult YES:验证成功  NO:验证失败
 */
- (void)gesturePassword:(id)verifyView withVerifyResult:(BOOL)verifyResult;
@end

@interface LKGesturePasswordVerifyView : UIView
@property (nonatomic, readwrite, strong) LKGesturePasswordViewModel *verifyViewModel;

@property (nonatomic, readwrite, assign) id<GesturePasswordVerifyResultProtocol> verifyResultProtocol;
/*!
 * 构建验证页面的所有控件
 */
- (void)layoutVerifyViewControls;

@end
