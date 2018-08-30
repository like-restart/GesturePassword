//
//  LKGesturePasswordVerifyHeaderView.h
//  融贝网
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//
/*! 此类为手势密码验证页面的头部视图，主要处理用户显示和信息提示处理 */

#import <UIKit/UIKit.h>

@interface LKGesturePasswordVerifyHeaderView : UIView
@property (nonatomic, readwrite, assign) BOOL isWrong;//YES:展示错误提示 NO:展示正常账户信息
@property (nonatomic, readwrite, assign) NSInteger numsOfValidLogin;//剩余录入密码的次数
@end
