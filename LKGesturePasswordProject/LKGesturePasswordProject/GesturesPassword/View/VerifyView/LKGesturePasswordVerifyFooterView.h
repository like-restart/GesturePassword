//
//  LKGesturePasswordVerifyFooterView.h
//  融贝网
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//
/*! 此类为手势密码验证页面的底部视图，主要处理退出和忘记事件 */

#import <UIKit/UIKit.h>

/*! 底部视图中的按钮点击事件类型 */
typedef NS_ENUM(NSInteger, FooterViewClickType) {
    /*! 退出当前账户模式 */
    FooterViewClickType_Logout,
    /*! 忘记手势密码模式 */
    FooterViewClickType_Forget
};

@protocol FooterViewClickProtocol <NSObject>

/*!
 * footerview的按钮点击处理回调
 *
 * @param footerView self
 * @param click_type 点击事件类型
 */
- (void)footerView:(UIView *)footerView withClickType:(FooterViewClickType)click_type;

@end

@interface LKGesturePasswordVerifyFooterView : UIView
//protocol
@property (nonatomic, readwrite, assign) id<FooterViewClickProtocol> clickProtocol;
@end
