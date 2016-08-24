//
//  LDFindPasswordTableViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/1/5.
//  Copyright © 2016年 VRV. All rights reserved.
//

#import "LDFindPasswordTableViewController.h"

@interface LDFindPasswordTableViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UILabel *passwordLab;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *confirmPasswordLab;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@end

@implementation LDFindPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    [self initView];
}

- (void)initView
{
    if (_authRegister == YES) {
        self.title = @"注册";
    }else{
        self.title = @"找回密码";
        _nameLab.text = @"密码";
        _passwordLab.text = @"确认密码";
    }
    LDFindPasswordFootView *foot = [[LDFindPasswordFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    [foot footView];
    foot.delegate = self;
    self.tableView.tableFooterView = foot;
    _name.delegate=self;
    _password.delegate=self;
    _confirmPassword.delegate=self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - LDFindPasswordFootViewDelegate
-(void)findPassword
{
    if ([_name.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"名称不能为空"];
        [_name resignFirstResponder];
        return;
    }
    if ([_password.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [_password resignFirstResponder];
        return;
    }
    if ([_confirmPassword.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"确认密码不能为空"];
        [_confirmPassword resignFirstResponder];
        return;
    }
    
    if (![_confirmPassword.text isEqualToString:_password.text]) {
        [SVProgressHUD showErrorWithStatus:@"2次输入密码不一致"];
        [_confirmPassword resignFirstResponder];
        return;
    }
    if (_authRegister) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"注册中...", nil) maskType:SVProgressHUDMaskTypeBlack];
        LDRegisterModel *registerModel = [LDClient sharedInstance].overallRegisterModel;
        [registerModel registeryWithPassword:_password.text nickName:_name.text verifyCode:nil completion:^(NSError *error) {
            if (!error) {
                [SVProgressHUD dismiss];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }];
    }else{
        [SVProgressHUD showWithStatus:NSLocalizedString(@"找回中...", nil) maskType:SVProgressHUDMaskTypeBlack];
        LDRegisterModel *registerModel = [LDClient sharedInstance].overallRegisterModel;
        [registerModel resetPassword:_password.text nickName:_name.text verifyCode:nil completion:^(NSError *error) {
            if (!error) {
                [SVProgressHUD dismiss];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }];
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)stopKeyboard
{
    [_name resignFirstResponder];
    [_password resignFirstResponder];
    [_confirmPassword resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
