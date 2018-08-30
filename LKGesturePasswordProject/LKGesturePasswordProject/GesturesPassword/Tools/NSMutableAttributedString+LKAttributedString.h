//
//  NSMutableAttributedString+LKAttributedString.h
//  融贝网
//
//  Created by like on 2018/8/9.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (LKAttributedString)
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
+ (NSMutableAttributedString *)decorateAttributedString:(NSDictionary *)paramDict;

/*!
 * layout attributed string
 *
 * @param valueStr real content
 * @return sttributed string
 */
+ (NSMutableAttributedString *)decorateAmountAttributedString:(NSString *)valueStr;

/*!
 * layout attributed string (8.00+0.5%)
 *
 * @param valueStr real content
 * @param isValid YES:0xFF7C00 NO:0x999999
 *
 * @return sttributed string
 */
+ (NSMutableAttributedString *)decorateInterestAttributedString:(NSString *)valueStr withIsValid:(BOOL)isValid;
@end
