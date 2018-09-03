//
//  CALayer+LKShakeAnimation.m
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/22.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "CALayer+LKShakeAnimation.h"

@implementation CALayer (LKShakeAnimation)

/*!
 *  设置layer抖动效果
 */
-(void)shakeOfAnimation
{
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];//keyPath:x方向移动 参数：x轴上的坐标
    
    CGFloat shake_x = 5;
    //设置关键帧，在duration设置的时长中，依次显示数组中的元素
    shakeAnimation.values = @[@(-shake_x),@(0),@(shake_x),@(0),@(-shake_x),@(0),@(shake_x),@(0)];
    
    //设置抖动时长，在设置的时间内完成values中的元素
    shakeAnimation.duration = 0.3f;
    
    [self addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}
@end
