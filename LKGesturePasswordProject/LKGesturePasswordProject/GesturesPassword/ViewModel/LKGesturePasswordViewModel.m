//
//  LKGesturePasswordViewModel.m
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "LKGesturePasswordViewModel.h"
#import "NSMutableArray+LKCombinationMutableArray.h"//combination
#import "LKCodeTools.h"//tools

#define GESTURE_PASSWORD_LOGIN_VERIFY_KEY @"GESTURE_PASSWORD_LOGIN_VERIFY_KEY"//保存TouchId为激活状态，可用于登录时指纹验证，保存为YES，反之NO
#define GESTURE_PASSWORD_IS_FINGER @"GESTURE_PASSWORD_IS_FINGER"//是否开启了指纹
#define GESTURE_PASSWORD_KEY @"GESTURE_PASSWORD_KEY"//指纹密码保存

@interface LKGesturePasswordViewModel ()
{
    NSInteger isVerifyInput;//适用于set模式中 第二次录入密码即验证密码的判断 NO:第一次录入 YES:第二次录入
    NSInteger numsOfValidLogin;//有效的登录次数，默认为5次
    NSInteger minLimitOfGesturePassword;//密码个数的限制 个数最少为4个
}

@end

@implementation LKGesturePasswordViewModel
@synthesize gesturePasswordString = _gesturePasswordString;
@synthesize verifyGesturePasswordString = _verifyGesturePasswordString;

- (instancetype)init
{
    self = [super init];
    if (self) {
        isVerifyInput = NO;//默认值为NO，
        numsOfValidLogin = 5;//默认值为5次
        minLimitOfGesturePassword = 4;//最少为4个
    }
    return self;
}

#pragma mark - - Deal With Gesture Password - -
/*!
 * 对密码多次录入的逻辑处理
 *
 * @param gesture_type GesturePasswordType_Verify|GesturePasswordType_Set 区分密码模式，verify:第二次进行密码验证 set:第一次进行密码设置，第二次进行密码验证
 * @param button_index 所接触到的按钮的下标值，用作密码进行字符串拼接，最终拼接为下标值组成的密码字符串
 * @param isEnd 是否出发了TouchesEnded函数，结束了绘制
 * @param resultsBlock 每次执行密码逻辑处理的结果返回，view根据此状态进行UI处理
 */
- (void)dealWithGesturePasswordWithType:(GesturePasswordType)gesture_type withButtonIndex:(NSInteger)button_index withInputState:(BOOL)isEnd withResultsBlock:(void (^)(NSDictionary * _Nonnull))resultsBlock
{
    switch (gesture_type) {
        case GesturePasswordType_Set://密码设置
        {
            if (!isVerifyInput) {//first
                [self saveGesturePasswordWithButtonIndex:button_index];
            }else {
                [self saveVerifyGesturePasswordWithButtonIndex:button_index];
            }
            /*！
             * 录入结束，当结束之后第一次录入密码进行保存，并返回第一次密码处理完成
             * 第二次录入密码模式：和第一次密码进行验证，并返回验证结果：成功|失败
             */
            if (isEnd) {
                if (!isVerifyInput) {
                    NSMutableArray *gestureArray = [NSMutableArray combinationArrayWithString:self.gesturePasswordString];
                    
                    //the resultsDict of need to return
                    NSMutableDictionary *resultsDict = [[NSMutableDictionary alloc] initWithCapacity:4];
                    [resultsDict setObject:[NSNumber numberWithInteger:GesturePasswordStateType_First] forKey:gesture_stateType];
                    [resultsDict setObject:[NSNumber numberWithBool:YES] forKey:results_bool];
                    [resultsDict setObject:gestureArray forKey:highlightedIndex_array];
                    [resultsDict setObject:[NSNumber numberWithBool:YES] forKey:conform_minLimit];
                    
                    //判断密码长度是否符合限制
                    if ([gestureArray count] >= minLimitOfGesturePassword) {
                        //1. 设置值为YES，进入验证录入模式
                        isVerifyInput = YES;
                        //2. 保存密码到NSUsersDefaults中
                        
                    }else {//不符合
                        [resultsDict setObject:[NSNumber numberWithBool:NO] forKey:conform_minLimit];
                        
                        //设置密码如果不符合长度限制，则清空
                        self.gesturePasswordString = @"";
                    }
                    
                    //3. 返回结果：第一次密码设置完成，可进入第二步验证工作
                    resultsBlock(resultsDict);
                }else {
                    //1. 验证
                    BOOL verify_bool = [self verifyGesturePassword];
                    //2. 验证失败，清空原始密码
                    if (!verify_bool) {
                        self.verifyGesturePasswordString = @"";
                    }else {//验证成功
                        //3. 恢复默认值
                        isVerifyInput = NO;
                        
                    }
                    //4. 返回结果：验证已完成
                    NSMutableDictionary *resultsDict = [[NSMutableDictionary alloc] initWithCapacity:4];
                    [resultsDict setObject:[NSNumber numberWithInteger:GesturePasswordStateType_Second] forKey:gesture_stateType];
                    [resultsDict setObject:[NSNumber numberWithBool:verify_bool] forKey:results_bool];
                    [resultsDict setObject:[NSNumber numberWithInt:0] forKey:valid_nums];
                    resultsBlock(resultsDict);
                }
            }
        }
            break;
        case GesturePasswordType_Verify://密码验证
        {
            [self saveVerifyGesturePasswordWithButtonIndex:button_index];
            if (isEnd) {
                //在屏幕上触摸了很久，但是一个按钮都没有触发，所以字符串应该是空的，排除此情况
                if (self.verifyGesturePasswordString.length == 0) {
                    NSMutableDictionary *resultsDict = [[NSMutableDictionary alloc] initWithCapacity:4];
                    [resultsDict setObject:[NSNumber numberWithInteger:GesturePasswordStateType_Verify] forKey:gesture_stateType];
                    [resultsDict setObject:[NSNumber numberWithBool:NO] forKey:results_bool];
                    [resultsDict setObject:[NSNumber numberWithInt:5] forKey:valid_nums];
                    //设置特定的条件来判断是否是此条件NO+5
                    resultsBlock(resultsDict);
                }else {
                    //1. 验证
                    BOOL verify_bool = [self verifyGesturePassword];
                    //2. 清空验证的密码数据
                    self.verifyGesturePasswordString = @"";
                    
                    //3. 返回结果：验证已完成
                    NSMutableDictionary *resultsDict = [[NSMutableDictionary alloc] initWithCapacity:4];
                    [resultsDict setObject:[NSNumber numberWithInteger:GesturePasswordStateType_Verify] forKey:gesture_stateType];
                    [resultsDict setObject:[NSNumber numberWithBool:verify_bool] forKey:results_bool];
                    [resultsDict setObject:[NSNumber numberWithInteger:(--numsOfValidLogin)] forKey:valid_nums];
                    resultsBlock(resultsDict);
                    //4. 判断剩余验证次数，次数为0时，则直接清空账户信息，进入APP首页（未登录状态）
                    if (numsOfValidLogin > 0) {
                    }else {
                        [self ClearUsersDataAndEnterAPP];
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
}

/*!
 * 组合原始密码字符串（处理下标值）
 */
- (void)saveGesturePasswordWithButtonIndex:(NSInteger)button_index
{
    //判断是否为9，代表触摸离开屏幕的时候并没有触碰到按钮，需要截取字符串的最后一位重复添加
    if (9 == button_index) {
        if (self.gesturePasswordString && self.gesturePasswordString.length > 0) {
            self.gesturePasswordString = [self.gesturePasswordString substringFromIndex:self.gesturePasswordString.length-1];
        }
    }else {
        self.gesturePasswordString = [NSString stringWithFormat:@"%ld",button_index];
    }
}

/*!
 * 组合验证密码字符串（处理下标值）
 */
- (void)saveVerifyGesturePasswordWithButtonIndex:(NSInteger)button_index
{
    //判断是否为9，代表触摸离开屏幕的时候并没有触碰到按钮，需要截取字符串的最后一位重复添加
    if (9 == button_index) {
        if (self.verifyGesturePasswordString && self.verifyGesturePasswordString.length > 0) {
            self.verifyGesturePasswordString = [self.verifyGesturePasswordString substringFromIndex:self.verifyGesturePasswordString.length-1];
        }
    }else {
        self.verifyGesturePasswordString = [NSString stringWithFormat:@"%ld",button_index];
    }
}

/*!
 * 把录入的验证密码与原始密码进行对比验证
 */
- (BOOL)verifyGesturePassword
{
    return [self.gesturePasswordString isEqualToString:self.verifyGesturePasswordString];
}

/*!
 * 验证完成，保存手势密码到UserDefaults
 *
 * @param isTouchId YES:登录验证的时候直接启动TouchId NO:不启动
 * @param isGesture YES:登录的时候启动手势密码验证 NO:不启动
 */
- (void)saveTouchId:(BOOL)isTouchId withGesturePassword:(BOOL)isGesture
{
    //保存TouchId为激活状态，可用于登录时指纹验证，保存为YES，反之NO
    if (isTouchId) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GESTURE_PASSWORD_LOGIN_VERIFY_KEY];
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:GESTURE_PASSWORD_LOGIN_VERIFY_KEY];
    }
    //对密码进行保存
    if (isGesture) {
        //是否启用了手势密码
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GESTURE_PASSWORD_IS_FINGER];
        [[NSUserDefaults standardUserDefaults] setObject:_gesturePasswordString forKey:GESTURE_PASSWORD_KEY];
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:GESTURE_PASSWORD_IS_FINGER];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:GESTURE_PASSWORD_KEY];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //保存之后可以挑转了
//#error 在这里设置跳转进入APP首页（点击登录-登录页面-登录成功-密码页面-设置成功-APP首页）
    [[LKCodeTools getVisibleViewControler] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - - Clear Login Data - -
/*!
 * 清空用户数据，并进入应用首页
 */
- (void)ClearUsersDataAndEnterAPP
{
//#error 在这里清空用户登录数据
    [self saveTouchId:NO withGesturePassword:NO];
}

#pragma mark - - Close Current View - -
/*!
 * 关闭当前页面，返回到上一个页面
 */
- (void)closeTheCurrentViewAction
{
    [[LKCodeTools getVisibleViewControler] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - - Setter and Getter - -
/*!
 * 对原始密码进行拼接处理，并随时进行保存（保存写在这里，为了省事儿）
 */
- (void)setGesturePasswordString:(NSString *)gesturePasswordString
{
    if (gesturePasswordString && gesturePasswordString.length > 0) {
        if (!_gesturePasswordString) {
            _gesturePasswordString = @"";
        }
        _gesturePasswordString = [_gesturePasswordString stringByAppendingString:gesturePasswordString];
    }else {
        _gesturePasswordString = @"";
    }
}

/*!
 * 获取原始的密码，如果保存原始密码的字符串无值，则从NSUserDefaults中进行获取
 */
- (NSString *)gesturePasswordString
{
    if (self.gestureType == GesturePasswordType_Verify || self.gestureType == GesturePasswordType_Modify) {
        if (!_gesturePasswordString || _gesturePasswordString.length == 0) {
            return [[NSUserDefaults standardUserDefaults] objectForKey:GESTURE_PASSWORD_KEY];
        }
    }
    return _gesturePasswordString;
}

/*!
 * 对验证密码进行拼接处理
 */
- (void)setVerifyGesturePasswordString:(NSString *)verifyGesturePasswordString
{
    if (verifyGesturePasswordString && verifyGesturePasswordString.length > 0) {
        if (!_verifyGesturePasswordString) {
            _verifyGesturePasswordString = @"";
        }
        _verifyGesturePasswordString = [_verifyGesturePasswordString stringByAppendingString:verifyGesturePasswordString];
    }else {
        _verifyGesturePasswordString = @"";
    }
}

@end
