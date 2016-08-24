//
//  LDModifyPasswordTableViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/3/3.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDModifyPasswordTableViewController.h"
#import "LDSysHeadAndFootView.h"

@interface LDModifyPasswordTableViewController ()<LDSysHeadAndFootViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@end

@implementation LDModifyPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self initView];
}

- (void)initView
{
    _oldPassword.delegate = self;
    _password.delegate = self;
    _confirmPassword.delegate = self;
    LDSysHeadAndFootView *foot = [[LDSysHeadAndFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,75)];
    [foot modifyPasswordFoot];
    foot.delegate = self;
    self.tableView.tableFooterView = foot;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopKeyboard)];
    [self.view addGestureRecognizer:tap];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark -LDSysHeadAndFootViewDelegate
- (void)modifyPassword
{
    if ([_oldPassword.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"原密码不能为空"];
        [_oldPassword resignFirstResponder];
        return;
    }
    
    if([_oldPassword.text length] < 6){
        [SVProgressHUD showErrorWithStatus:@"原密码长度不能小于6位"];
        [_oldPassword resignFirstResponder];
        return;
    }
    
    if ([_password.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"新密码不能为空"];
        [_password resignFirstResponder];
        return;
    }
    if([_password.text length] < 6){
        [SVProgressHUD showErrorWithStatus:@"新密码长度不能小于6位"];
        [_password resignFirstResponder];
        return;
    }
    
    if ([_confirmPassword.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"确认密码不能为空"];
        [_password resignFirstResponder];
        return;
    }
    if([_confirmPassword.text length] < 6){
        [SVProgressHUD showErrorWithStatus:@"确认密码长度不能小于6位"];
        [_confirmPassword resignFirstResponder];
        return;
    }
    
    if (![_password.text isEqualToString:_confirmPassword.text]) {
        [SVProgressHUD showErrorWithStatus:@"新密码和确认密码不相同"];
        [_confirmPassword resignFirstResponder];
        return;
    }
    [_oldPassword resignFirstResponder];
    [_confirmPassword resignFirstResponder];
    [_password resignFirstResponder];
    
    LDAuthModel *authModel = [[LDAuthModel alloc] init];
    authModel.password = _oldPassword.text;
    [authModel updatePassword:_password.text completion:^(NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showErrorWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)stopKeyboard
{
    [_oldPassword resignFirstResponder];
    [_password resignFirstResponder];
    [_confirmPassword resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
