//
//  LKGesturePasswordSetFooterView.h
//  融贝网
//
//  Created by like on 2018/8/21.
//  Copyright © 2018年 No Company. All rights reserved.
//
/*! 此类为手势密码设置页面的底部视图，主要处理重置密码事件 */


#import <UIKit/UIKit.h>

/*! 底部视图中的按钮点击事件类型 */
typedef NS_ENUM(NSInteger, FooterViewClickType) {
    /*! 重置手势密码 */
    FooterViewClickType_Reset
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

@interface LKGesturePasswordSetFooterView : UIView
//protocol
@property (nonatomic, readwrite, assign) id<FooterViewClickProtocol> clickProtocol;
@end
