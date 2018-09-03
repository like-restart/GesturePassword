//
//  NSMutableArray+LKCombinationMutableArray.h
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/22.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (LKCombinationMutableArray)
/*!
 * 把字符串中的数字进行分割组成数组
 *
 * @param string 需要被切割的字符串
 */
+ (NSMutableArray *)combinationArrayWithString:(NSString *)string;
@end
