//
//  UIColor+LKColorTools.h
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/28.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LKColorTools)
/*!
 * 根据颜色值的16进制数值来设置颜色
 *
 * @param hex 色值
 */
+ (id)colorWithHex:(unsigned int)hex;
@end
