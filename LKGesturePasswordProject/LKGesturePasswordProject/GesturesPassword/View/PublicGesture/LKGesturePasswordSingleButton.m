//
//  LKGesturePasswordSingleButton.m
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "LKGesturePasswordSingleButton.h"

@interface LKGesturePasswordSingleButton ()

/*! 图片名称设置 */
@property (nonatomic, readwrite, strong) NSString *normalImageName;
@property (nonatomic, readwrite, strong) NSString *highlightedImageName;
@property (nonatomic, readwrite, strong) NSString *errorImageName;
@end

@implementation LKGesturePasswordSingleButton

#pragma mark - - Create UI - -
/*!
 * 设置手势密码按钮的图片等属性
 */
- (void)layoutSingleButtonControls
{
    self.userInteractionEnabled = NO;//不可点击
    [self setImage:[UIImage imageNamed:self.normalImageName] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:self.highlightedImageName] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:self.errorImageName] forState:UIControlStateSelected];
    //default
    self.stateType = GesturePasswordButtonStateType_Normal;
}

#pragma mark - - Setter and Getter - -
- (void)setStateType:(GesturePasswordButtonStateType)stateType
{
    _stateType = stateType;
    switch (stateType) {
        case GesturePasswordButtonStateType_Normal:
        {
            self.selected = NO;
            self.highlighted = NO;
        }
            break;
        case GesturePasswordButtonStateType_Highlighted:
        {
            self.selected = NO;
            self.highlighted = YES;
        }
            break;
        case GesturePasswordButtonStateType_Error:
        {
            self.selected = YES;
            self.highlighted = NO;
        }
            break;
            
        default:
            break;
    }
}

/*!
 * 普通状态的按钮图标图片名称设置 Getter
 */
- (NSString *)normalImageName
{
    if (!_normalImageName) {
        _normalImageName = @"gesture_password_normal_icon.png";
    }
    return _normalImageName;
}

/*!
 * 被Touch状态的按钮图标图片名称设置 Getter（使用highlighted属性来标记）
 */
- (NSString *)highlightedImageName
{
    if (!_highlightedImageName) {
        _highlightedImageName = @"gesture_password_highlighted_icon.png";
    }
    return _highlightedImageName;
}

/*!
 * 密码设置错误状态的按钮图标图片名称设置 Getter （使用Selected 属性来标记）
 */
- (NSString *)errorImageName
{
    if (!_errorImageName) {
        _errorImageName = @"gesture_password_error_icon.png";
    }
    return _errorImageName;
}
@end
