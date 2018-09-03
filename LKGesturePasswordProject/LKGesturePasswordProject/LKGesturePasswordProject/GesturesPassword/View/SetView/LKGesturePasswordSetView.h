//
//  LKGesturePasswordSetView.h
//  融贝网
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//
/*! 此类为手势密码设置页面的主View类 */

#import <UIKit/UIKit.h>
#import "LKGesturePasswordViewModel.h"//view model

@interface LKGesturePasswordSetView : UIView
@property (nonatomic, readwrite, strong) LKGesturePasswordViewModel *setViewModel;

#pragma mark - - Create UI - -
/*!
 * 构建验证页面的所有控件
 */
- (void)layoutSetViewControls;
@end
