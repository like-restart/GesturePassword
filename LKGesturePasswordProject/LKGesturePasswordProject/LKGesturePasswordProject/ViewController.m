//
//  ViewController.m
//  LKGesturePasswordProject
//
//  Created by like on 2018/8/28.
//  Copyright © 2018年 No Company. All rights reserved.
//

#import "ViewController.h"

#import "LKGesturePasswordViewController.h"//view con

@interface ViewController ()
@property (nonatomic, readwrite, strong) UIButton *setPasswordButton;
@property (nonatomic, readwrite, strong) UIButton *verifyPasswordButton;
@property (nonatomic, readwrite, strong) UIButton *modifyPasswordButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //add subview
    [self.view addSubview:self.setPasswordButton];
    [self.view addSubview:self.verifyPasswordButton];
    [self.view addSubview:self.modifyPasswordButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - - Click Action - -
- (void)clickButtonAction:(id)sender
{
    //init
    LKGesturePasswordViewController *gestureViewCon = [[LKGesturePasswordViewController alloc] init];
    UIButton *clickButton = (UIButton *)sender;
    if ([clickButton isEqual:self.setPasswordButton]) {//set
        gestureViewCon.gestureType = GesturePasswordType_Set;//type
    }else if ([clickButton isEqual:self.verifyPasswordButton]) {//verify
        gestureViewCon.gestureType = GesturePasswordType_Verify;//type
    }else if ([clickButton isEqual:self.modifyPasswordButton]) {//modify
        gestureViewCon.gestureType = GesturePasswordType_Modify;//type
    }
    [self presentViewController:gestureViewCon animated:YES completion:nil];
}


#pragma mark - - Setter and Getter - -
- (UIButton *)setPasswordButton
{
    if (!_setPasswordButton) {
        _setPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setPasswordButton setFrame:CGRectMake(100, 100, 100, 40)];
        [_setPasswordButton setTitle:@"设置密码" forState:UIControlStateNormal];
        [_setPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_setPasswordButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setPasswordButton;
}

- (UIButton *)verifyPasswordButton
{
    if (!_verifyPasswordButton) {
        _verifyPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_verifyPasswordButton setFrame:CGRectMake(100, 150, 100, 40)];
        [_verifyPasswordButton setTitle:@"验证密码" forState:UIControlStateNormal];
        [_verifyPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_verifyPasswordButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyPasswordButton;
}

- (UIButton *)modifyPasswordButton
{
    if (!_modifyPasswordButton) {
        _modifyPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modifyPasswordButton setFrame:CGRectMake(100, 200, 100, 40)];
        [_modifyPasswordButton setTitle:@"修改密码" forState:UIControlStateNormal];
        [_modifyPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_modifyPasswordButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyPasswordButton;
}
@end
