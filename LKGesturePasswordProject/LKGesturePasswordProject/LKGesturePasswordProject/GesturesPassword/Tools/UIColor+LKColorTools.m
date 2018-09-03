//
//  UIColor+LKColorTools.m
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/28.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "UIColor+LKColorTools.h"

@implementation UIColor (LKColorTools)
/*!
 * 根据颜色值的16进制数值来设置颜色
 *
 * @param hex 色值
 */
+ (id)colorWithHex:(unsigned int)hex
{
    return [UIColor colorWithHex:hex alpha:1];
}

/*!
 * 转化16进制的色值为red、green、blue模式
 *
 * @param hex 0x......
 * @param alpha 默认为1，不透明（最好设置为不透明，否则会增加颜色渲染的效率）
 */
+ (id)colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
}
@end
