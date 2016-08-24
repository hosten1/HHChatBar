//
//  LDBindEmailTableViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/3/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDBindEmailTableViewController.h"
#import "LDSysHeadAndFootView.h"

@interface LDBindEmailTableViewController ()<LDSysHeadAndFootViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *identifyCode;
@property (strong, nonatomic) LDMyselfModel *myself;


@end

@implementation LDBindEmailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邮箱绑定";

    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initView
{
    _myself = [[LDMyselfModel alloc] init];
    _email.delegate = self;
    _identifyCode.delegate = self;
    LDSysHeadAndFootView *foot = [[LDSysHeadAndFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,75)];
    [foot bindEmailFoot];
    foot.delegate = self;
    self.tableView.tableFooterView = foot;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark -LDSysHeadAndFootViewDelegate
- (void)bindEmail
{
    [_myself bindEmail:_email.text callBack:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"请前往邮箱绑定" maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            [SVProgressHUD showSuccessWithStatus:@"绑定失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];

}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)stopKeyboard
{
    [_email resignFirstResponder];
    [_identifyCode resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
