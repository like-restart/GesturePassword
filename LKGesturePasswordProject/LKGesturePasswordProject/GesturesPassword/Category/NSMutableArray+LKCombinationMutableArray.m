//
//  NSMutableArray+LKCombinationMutableArray.m
//  融贝网
//
//  Created by like on 2018/8/22.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "NSMutableArray+LKCombinationMutableArray.h"

@implementation NSMutableArray (LKCombinationMutableArray)
/*!
 * 把字符串中的数字进行分割组成数组
 *
 * @param string 需要被切割的字符串
 */
+ (NSMutableArray *)combinationArrayWithString:(NSString *)string
{
    if (string && string.length > 0) {
        NSMutableArray *combinationArray = [[NSMutableArray alloc] initWithCapacity:string.length];
        for (int i = 0; i < string.length-1; i ++) {
            [combinationArray addObject:[string substringWithRange:NSMakeRange(i, 1)]];
        }
        return combinationArray;
    }
    return [NSMutableArray new];
}
@end
