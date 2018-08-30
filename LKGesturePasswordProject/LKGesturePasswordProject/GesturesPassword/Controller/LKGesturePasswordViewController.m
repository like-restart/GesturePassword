//
//  LKGesturePasswordVerifyViewController.m
//  融贝网
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "LKGesturePasswordViewController.h"

#import "LKCodeTools.h"//tools

#import "LKGesturePasswordVerifyView.h"//verify view
#import "LKGesturePasswordSetView.h"//set view

@interface LKGesturePasswordViewController () <GesturePasswordVerifyResultProtocol>

@property (nonatomic, readwrite, strong) LKGesturePasswordVerifyView *verifyView;
@property (nonatomic, readwrite, strong) LKGesturePasswordSetView *setView;
@property (nonatomic, readwrite, strong) LKGesturePasswordViewModel *viewModel;
@end

@implementation LKGesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - - Verify Protocol - -
- (void)gesturePassword:(id)verifyView withVerifyResult:(BOOL)verifyResult
{
    NSLog(@"verify result = %d",verifyResult);
    if (GesturePasswordType_Modify == _gestureType) {
        //enter set view
        [self.verifyView removeFromSuperview];
        self.verifyView = nil;
        
        [self.setView layoutSetViewControls];
    }else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - - Setter and Getter - -
/*!
 * 创建确认页面view控件
 */
- (LKGesturePasswordVerifyView *)verifyView
{
    if (!_verifyView) {
        _verifyView = [[LKGesturePasswordVerifyView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-bottomXHeight)];
        _verifyView.verifyViewModel = self.viewModel;
        _verifyView.verifyResultProtocol = self;
        [self.view addSubview:_verifyView];
    }
    return _verifyView;
}

/*!
 * 创建设置密码页面view控件
 */
- (LKGesturePasswordSetView *)setView
{
    if (!_setView) {
        _setView = [[LKGesturePasswordSetView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-bottomXHeight)];
        _setView.setViewModel = self.viewModel;
        [self.view addSubview:_setView];
    }
    return _setView;
}

/*!
 * view model
 */
- (LKGesturePasswordViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[LKGesturePasswordViewModel alloc] init];
        _viewModel.gestureType = self.gestureType;
    }
    return _viewModel;
}

/*!
 * 设置手势页面的类型
 */
- (void)setGestureType:(GesturePasswordType)gestureType
{
    _gestureType = gestureType;
    switch (gestureType) {
        case GesturePasswordType_Set://设置
        {
            [self.setView layoutSetViewControls];
        }
            break;
        case GesturePasswordType_Verify://验证
        {
            //view model赋值
            [self.verifyView layoutVerifyViewControls];
        }
            break;
        case GesturePasswordType_Modify:
        {
            //1. verify
            [self.verifyView layoutVerifyViewControls];
            //2. set - protocol
        }
            break;
        default:
            break;
    }
}
@end
