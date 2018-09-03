//
//  NSMutableAttributedString+LKAttributedString.m
//  融贝网
//
//  Created by like on 2018/8/9.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "NSMutableAttributedString+LKAttributedString.h"

#import "LKCodeTools.h"//tools

@implementation NSMutableAttributedString (LKAttributedString)
/*!
 * layout attributed string
 * 
 * @param paramDict
 * content : LKAttributedOfValue
 * rangeString : LKAttributedOfRange
 * size : LKAttributedOfFirstFont|LKAttributedOfSecondFont
 * color : LKAttributedOfFirstColor|LKAttributedOfSecondColor
 *
 * @return sttributed string
 */
+ (NSMutableAttributedString *)decorateAttributedString:(NSDictionary *)paramDict
{
    
    NSMutableAttributedString *rewardsValuestring = [[NSMutableAttributedString alloc] initWithString:paramDict[@"LKAttributedOfValue"]];
    NSMutableDictionary *valueAttributes = [NSMutableDictionary dictionary];
    //font
    valueAttributes[NSFontAttributeName] = [LKCodeTools getContentFont:@"PingFangSC-Medium" withContentSize:[paramDict[@"LKAttributedOfFirstFont"] intValue]*Standard];
    //color
    valueAttributes[NSForegroundColorAttributeName] = paramDict[@"LKAttributedOfFirstColor"];
    [rewardsValuestring setAttributes:valueAttributes range:NSMakeRange(0, rewardsValuestring.length-1)];
    
    //judgment contains units
    if ([rewardsValuestring.string rangeOfString:paramDict[@"LKAttributedOfRange"]].location != NSNotFound) {
        //set units style
        NSMutableDictionary *unitsAttributes = [NSMutableDictionary dictionary];
        //font
        unitsAttributes[NSFontAttributeName] = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:[paramDict[@"LKAttributedOfSecondFont"] intValue]*Standard];
        //color
        unitsAttributes[NSForegroundColorAttributeName] = paramDict[@"LKAttributedOfSecondColor"];
        
        NSInteger index = [rewardsValuestring.string rangeOfString:paramDict[@"LKAttributedOfRange"]].location;
        [rewardsValuestring setAttributes:unitsAttributes range:NSMakeRange(index, rewardsValuestring.length-index)];
    }
    return rewardsValuestring;
}

/*!
 * layout attributed string
 *
 * @param valueStr real content
 * @return sttributed string
 */
+ (NSMutableAttributedString *)decorateAmountAttributedString:(NSString *)valueStr
{
    NSMutableAttributedString *rewardsValuestring = [[NSMutableAttributedString alloc] initWithString:valueStr];
    NSMutableDictionary *valueAttributes = [NSMutableDictionary dictionary];
    valueAttributes[NSFontAttributeName] = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:14*Standard];
    valueAttributes[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x999999];
    [rewardsValuestring setAttributes:valueAttributes range:NSMakeRange(0, 7)];
    [rewardsValuestring setAttributes:valueAttributes range:NSMakeRange(valueStr.length-1, 1)];
    
    //set value style
    NSMutableDictionary *unitsAttributes = [NSMutableDictionary dictionary];
    unitsAttributes[NSFontAttributeName] = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:14*Standard];
    unitsAttributes[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xFF7C00];
    [rewardsValuestring setAttributes:unitsAttributes range:NSMakeRange(7, valueStr.length-7)];
    return rewardsValuestring;
}

/*!
 * layout attributed string (8.00+0.5%)
 *
 * @param valueStr real content
 * @param isValid YES:0xFF7C00 NO:0x999999
 *
 * @return sttributed string
 */
+ (NSMutableAttributedString *)decorateInterestAttributedString:(NSString *)valueStr withIsValid:(BOOL)isValid
{
    UIColor *textColor = nil;
    if (isValid) {
        textColor = [UIColor colorWithHex:0xFF7C00];
    }else {
        textColor = [UIColor colorWithHex:0x999999];
    }
    
    NSMutableAttributedString *rewardsValuestring = [[NSMutableAttributedString alloc] initWithString:valueStr];
    NSMutableDictionary *valueAttributes = [NSMutableDictionary dictionary];
    valueAttributes[NSFontAttributeName] = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:40*Standard];
    valueAttributes[NSForegroundColorAttributeName] = textColor;
    //search +
    NSUInteger plusLocation = [valueStr rangeOfString:@"+"].location;
    if (plusLocation != NSNotFound) {
        [rewardsValuestring setAttributes:valueAttributes range:NSMakeRange(0, plusLocation)];
        //set +
        valueAttributes[NSFontAttributeName] = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:18*Standard];
        [rewardsValuestring setAttributes:valueAttributes range:NSMakeRange(plusLocation, 1)];
        
        //set 0.5
        valueAttributes[NSFontAttributeName] = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:24*Standard];
        [rewardsValuestring setAttributes:valueAttributes range:NSMakeRange(plusLocation+1, valueStr.length-plusLocation-2)];
        
        //set %
        valueAttributes[NSFontAttributeName] = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:14*Standard];
        [rewardsValuestring setAttributes:valueAttributes range:NSMakeRange(valueStr.length-1, 1)];
    }
    return rewardsValuestring;
}
@end
