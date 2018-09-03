//
//  LKGesturePasswordVerifyHeaderView.m
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "LKGesturePasswordVerifyHeaderView.h"

#import "LKCodeTools.h"//tools

@interface LKGesturePasswordVerifyHeaderView ()

@property (nonatomic, readwrite, strong) UIImageView *headerImageView;
@property (nonatomic, readwrite, strong) UILabel *headerTitleLabel;

@end

@implementation LKGesturePasswordVerifyHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.headerImageView setHighlighted:NO];
    }
    return self;
}


#pragma mark - - Setter and Getter - -
/*!
 * 当手势处于正常或者错误状态的时候修改此变量的值，利用setter方法来改变控件的值
 *
 * @param isWrong YES:展示错误提示 NO:展示正常账户信息
 */
- (void)setIsWrong:(BOOL)isWrong
{
    if (!isWrong) {
        //show the content
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userName = [defaults objectForKey:@"name"];
        if (userName && userName.length > 0) {
            self.headerTitleLabel.text = [NSString stringWithFormat:@"您好，%@",userName];
        }
        [self.headerImageView setHighlighted:NO];
    }else {
        NSMutableDictionary *titleParamDict = [[NSMutableDictionary alloc] init];
        [titleParamDict setObject:[NSString stringWithFormat:@"解锁图案错误，还可以输入 %ld次",self.numsOfValidLogin] forKey:@"LKAttributedOfValue"];
        [titleParamDict setObject:@" " forKey:@"LKAttributedOfRange"];
        [titleParamDict setObject:@14 forKey:@"LKAttributedOfFirstFont"];
        [titleParamDict setObject:@14 forKey:@"LKAttributedOfSecondFont"];
        [titleParamDict setObject:self.headerTitleLabel.textColor forKey:@"LKAttributedOfFirstColor"];
        [titleParamDict setObject:[UIColor colorWithHex:0xFF5E5B] forKey:@"LKAttributedOfSecondColor"];
        
        self.headerTitleLabel.attributedText = [NSMutableAttributedString decorateAttributedString:titleParamDict];
        [self.headerImageView setHighlighted:YES];
    }
}
/*!
 * 头部区域的图片控件（normal:默认图片 highlighted:使用在错误的情况下显示error图片）
 *
 * @return UIImageView
 */
- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-80*Standard)/2, 15*Standard, 80*Standard, 80*Standard)];
        [_headerImageView setImage:[UIImage imageNamed:@"gesture_password_header_normal_icon.png"]];//normal
        [_headerImageView setHighlightedImage:[UIImage imageNamed:@"gesture_password_header_error_icon.png"]];//error
        [self addSubview:_headerImageView];
    }
    return _headerImageView;
}

/*!
 * 头部区域的文字控件（normal:展示用户的账号 error:解锁图案错误，请重新绘制）
 *
 * @return UILabel
 */
- (UILabel *)headerTitleLabel
{
    if (!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.headerImageView.frame.origin.y+self.headerImageView.frame.size.height+10*Standard, self.frame.size.width, 20*Standard)];
        _headerTitleLabel.font = [LKCodeTools getContentFont:@"PingFangSC-Regular" withContentSize:14*Standard];
        _headerTitleLabel.textColor = [UIColor colorWithHex:0x353B48];
        _headerTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_headerTitleLabel];
    }
    return _headerTitleLabel;
}


@end
