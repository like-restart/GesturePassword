//
//  LKCodeTools.h
//  融贝网
//
//  Created by like on 2018/5/29.
//  Copyright © 2018年 No Company. All rights reserved.
//

#define Standard [UIScreen mainScreen].bounds.size.width/375

#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define NaviegationHeight  (iPhoneX? 88 : 64)
#define bottomXHeight  (iPhoneX? 20 : 0)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UIColor+LKColorTools.h"//color
#import "NSMutableAttributedString+LKAttributedString.h"//attributed

@interface LKCodeTools : NSObject

/**
 get conversion font

 @param fontName font name
 @param fontSize font size
 @return UIFont
 */
+ (UIFont *)getContentFont:(NSString *)fontName withContentSize:(CGFloat)fontSize;


#pragma mark - - view controller related area - -
/**
 get visible viewController
 
 @return UIViewController
 */
+ (UIViewController *)getVisibleViewControler;

@end
