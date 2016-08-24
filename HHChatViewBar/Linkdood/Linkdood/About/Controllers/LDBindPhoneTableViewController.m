//
//  LDBindPhoneTableViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/3/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDBindPhoneTableViewController.h"
#import "LDSysHeadAndFootView.h"

@interface LDBindPhoneTableViewController ()<LDSysHeadAndFootViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *identifyCode;
@property (strong, nonatomic) LDMyselfModel *myself;
@property (assign, nonatomic) int time;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation LDBindPhoneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号绑定";

    [self initView];
}

- (void)initView
{
    _time = 60;
    _myself = [[LDMyselfModel alloc] init];
    _phone.delegate = self;
    _identifyCode.delegate = self;
    LDSysHeadAndFootView *foot = [[LDSysHeadAndFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,75)];
    [foot bindPhoneFoot];
    foot.delegate = self;
    self.tableView.tableFooterView = foot;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark -LDSysHeadAndFootViewDelegate
- (void)bindPhone
{
    if ([_identifyCode.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        [_identifyCode resignFirstResponder];
        [_phone resignFirstResponder];
        return;
    }
    [_myself bindPhone:_identifyCode.text completion:^(NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"绑定成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            [SVProgressHUD showSuccessWithStatus:@"绑定失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

- (IBAction)getIdentifyCode:(UIButton *)sender {
    if ([_phone.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        [_phone resignFirstResponder];
        [_identifyCode resignFirstResponder];
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(backTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    _getCodeBtn.userInteractionEnabled = NO;
    [_myself getVerifyCode:_phone.text onRegion:@"0086" completion:^(NSError *error) {
        
    }];
}

-(void)backTime{
    if (_time < 0) {
        _time = 60;
        _getCodeBtn.userInteractionEnabled = YES;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];

    }else{
        [_getCodeBtn setTitle:[NSString stringWithFormat:@"%d",_time] forState:UIControlStateNormal];
        _time = _time-1;
    }
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
    [_phone resignFirstResponder];
    [_identifyCode resignFirstResponder];
}

#pragma mark - Table view data source



@end
