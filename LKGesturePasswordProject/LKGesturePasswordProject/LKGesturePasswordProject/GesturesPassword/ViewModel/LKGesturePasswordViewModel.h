//
//  LKGesturePasswordViewModel.h
//  融贝网
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//
/*! 手势密码模块的viewModel类，用于处理view与model的逻辑处理，和页面跳转 */

//resultsBlock 集合成为字典，收集所有的返回数据，定义宏变量进行说明
#define gesture_stateType @"gesture_stateType"//GesturePasswordStateType
#define results_bool @"results_bool"//处理结果 YES|NO
#define valid_nums @"valid_nums"//验证密码的时候 有效的录入验证次数
#define highlightedIndex_array @"highlightedIndex_array"//被触摸选中的按钮的下标值数组
#define conform_minLimit @"conform_minLimit"//设置密码的时候，密码长度需要大于4

#import <Foundation/Foundation.h>

/*! 手势密码模块的样式类型 */
typedef NS_ENUM(NSInteger, GesturePasswordType) {
    /*! 手势密码验证模式 */
    GesturePasswordType_Verify,
    /*! 手势密码设置模式 */
    GesturePasswordType_Set,
    /*! 手势密码修改模式 */
    GesturePasswordType_Modify
};

/*! 手势密码所处状态的样式类型 */
typedef NS_ENUM(NSInteger, GesturePasswordStateType) {
    /*! 手势密码-第一次密码设置 */
    GesturePasswordStateType_First,
    /*! 手势密码-第二次密码设置 */
    GesturePasswordStateType_Second,
    /*! 手势密码-验证 */
    GesturePasswordStateType_Verify,
};

@interface LKGesturePasswordViewModel : NSObject
@property (nonatomic, readwrite, strong) NSString *gesturePasswordString;//手势密码字符串（按钮的下标值拼接而成）- 正确密码保存
@property (nonatomic, readwrite, strong) NSString *verifyGesturePasswordString;//手势密码字符串（按钮的下标值拼接而成）- 验证密码保存
@property (nonatomic, readwrite, assign) GesturePasswordType gestureType;//密码模式类型


#pragma mark - - Deal With Gesture Password - -
/*!
 * 对密码多次录入的逻辑处理
 *
 * @param gesture_type GesturePasswordType_Verify|GesturePasswordType_Set 区分密码模式，verify:第二次进行密码验证 set:第一次进行密码设置，第二次进行密码验证
 * @param button_index 所接触到的按钮的下标值，用作密码进行字符串拼接，最终拼接为下标值组成的密码字符串
 * @param isEnd 是否出发了TouchesEnded函数，结束了绘制
 * @param resultsBlock 每次执行密码逻辑处理的结果返回，view根据此状态进行UI处理
 */
- (void)dealWithGesturePasswordWithType:(GesturePasswordType)gesture_type withButtonIndex:(NSInteger)button_index withInputState:(BOOL)isEnd withResultsBlock:(void(^)(NSDictionary * _Nonnull resultsDict))resultsBlock;

/*!
 * 验证完成，保存手势密码到UserDefaults
 *
 * @param isTouchId YES:登录验证的时候直接启动TouchId NO:不启动
 * @param isGesture YES:登录的时候启动手势密码验证 NO:不启动
 */
- (void)saveTouchId:(BOOL)isTouchId withGesturePassword:(BOOL)isGesture;

#pragma mark - - Clear Login Data - -
/*!
 * 清空用户数据，并进入应用首页
 */
- (void)ClearUsersDataAndEnterAPP;

#pragma mark - - Close Current View - -
/*!
 * 关闭当前页面，返回到上一个页面
 */
- (void)closeTheCurrentViewAction;
@end
