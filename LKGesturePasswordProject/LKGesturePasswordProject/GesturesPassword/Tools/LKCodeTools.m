//
//  LKCodeTools.m
//  LKGesturePasswordProject
//
//  Created by like on 2018/5/29.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "LKCodeTools.h"

@implementation LKCodeTools

/**
 get conversion font
 
 @param fontName font name
 @param fontSize font size
 @return UIFont
 */
+ (UIFont *)getContentFont:(NSString *)fontName withContentSize:(CGFloat)fontSize
{
    UIFont *conversionFont = [UIFont systemFontOfSize:fontSize];
    return conversionFont;
}

/**
 get visible viewController

 @return UIViewController
 */
+ (UIViewController *)getVisibleViewControler
{
    UIViewController *visibleViewCon = nil;
    visibleViewCon = [LKCodeTools traverseViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (visibleViewCon.presentedViewController) {
        visibleViewCon = [LKCodeTools traverseViewController:visibleViewCon.presentedViewController];
    }
    return visibleViewCon;
}

/**
 traverse controller

 @param viewCon current viewController
 @return UIViewController
 */
+ (UIViewController *)traverseViewController:(UIViewController *)viewCon
{
    if ([viewCon isKindOfClass:[UINavigationController class]]) {
        return [LKCodeTools traverseViewController:[(UINavigationController *)viewCon topViewController]];
    } else if ([viewCon isKindOfClass:[UITabBarController class]]) {
        return [LKCodeTools traverseViewController:[(UITabBarController *)viewCon selectedViewController]];
    } else {
        return viewCon;
    }
    return nil;
}
@end
