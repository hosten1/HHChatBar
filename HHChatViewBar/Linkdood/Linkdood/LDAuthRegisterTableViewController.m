//
//  Linkdood
//
//  Created by VRV on 15/12/24.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "LDAuthRegisterTableViewController.h"
#import "LDAuthRegisterView.h"
#import "LDFindPasswordTableViewController.h"
#import "LDServeAndPrivacyViewController.h"

@interface LDAuthRegisterTableViewController () <LDLoginRegisterDelegate,UITextFieldDelegate>{
    NSMutableString *nation;
    NSTimer *timer;
    int num;
    LDAuthModel *authModel;
}
@property(nonatomic,strong)NSString *registryID;
@property(nonatomic,assign) int judge;
@end

@implementation LDAuthRegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_authRegister == YES) {
        self.title = NSLocalizedString(@"注册", nil);
    }
    else{
        self.title = NSLocalizedString(@"找回密码", nil);
    }
    nation = [NSMutableString stringWithString:_phoneHeader.text];
    self.view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    
    _server.delegate=self;
    _account.delegate=self;
    _identifyCode.delegate=self;
    
    self.tableView.scrollEnabled = NO;

    [self initView];
    authModel = [[LDAuthModel alloc]init];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSelectCountry)];
    [cell addGestureRecognizer:tap];
}

- (void)initView
{
    [_server setValue:RGBACOLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_account setValue:RGBACOLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_identifyCode setValue:RGBACOLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];

    LDAuthRegisterView *foot = [[LDAuthRegisterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [foot nextBtn:_authRegister];
    foot.delegate = self;
    self.tableView.tableFooterView = foot;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - LDLoginRegisterDelegate

- (void)next
{
    if ([_server.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"服务器不能为空"];
        [_server resignFirstResponder];
        return;
    }
    if ([_account.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
        [_account resignFirstResponder];
        return;
    }
    
    if ([_identifyCode.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        [_identifyCode resignFirstResponder];
        return;
    }
    _judge = 0;
    
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"请稍等...", nil) maskType:SVProgressHUDMaskTypeBlack];
    LDRegisterModel *registerModel = [[LDClient sharedInstance] overallRegisterModel];
    if (_authRegister){
        [registerModel registeryWithPassword:nil nickName:nil verifyCode:_identifyCode.text completion:^(NSError *error) {
            if (!error) {
                [SVProgressHUD dismiss];
                [self performSegueWithIdentifier:@"findPasswordToFindPassword" sender:nil];
            }else{
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }];
    }else{
        [registerModel resetPassword:nil nickName:nil verifyCode:_identifyCode.text completion:^(NSError *error) {
            if (!error) {
                [SVProgressHUD dismiss];
                [self performSegueWithIdentifier:@"findPasswordToFindPassword" sender:nil];
            }else{
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }];
    }
}

- (void)serveTap
{
    _judge = 1;
    [self performSegueWithIdentifier:@"registerToPrivacy" sender:nil];
}

- (void)privacyTap
{
    _judge = 2;
    [self performSegueWithIdentifier:@"registerToPrivacy" sender:nil];
}

#pragma mark SelectCountryDelegate
- (void)choiceCountry:(NSDictionary*)country{
    _nationLabel.text = [[country allValues] lastObject];
    
    nation = [NSMutableString stringWithFormat:@"%@",[[country allKeys] lastObject]];

    _phoneHeader.text = [NSString stringWithFormat:@"%@",[[country allKeys] lastObject]];
}

- (void)showSelectCountry{
    SelectCountryViewController *selectCountryViewController = [[SelectCountryViewController alloc]initWithNibName:@"SelectCountryViewController" bundle:nil];
    [selectCountryViewController setDelegate:self];
    [self.navigationController pushViewController:selectCountryViewController animated:YES];
}

- (NSString *)getNationCode{
    NSMutableString *code = [[NSMutableString alloc]initWithString:nation];
    NSRange range = [code rangeOfString:@"+"];
    if (range.location != NSNotFound) {
        [code deleteCharactersInRange:range];
    }
    
    while ([code length]<4) {
        [code insertString:@"0" atIndex:0];
    }
    return code;
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (IBAction)getIdentifyCode:(UIButton *)sender {
    if ([_server.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"服务器不能为空"];
        [_server resignFirstResponder];
        return;
    }
    if ([_account.text length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
        [_account resignFirstResponder];
        return;
    }
    [[LDClient sharedInstance] getVerificationCodeWithAccount:_account.text accountType:user_type_phone getCodeType:_authRegister?get_code_register:get_code_resetpwd region:[self getNationCode] domain:_server.text completion:^(NSError *error, LDRegisterModel *callRegister) {
        if (!error) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
            [timer fire];
        }
    }];
//    if (_authRegister == YES) {
//        LDRegisterModel *model = [[LDRegisterModel alloc]init];
//        model.account = _account.text;
//        model.nationalCode = [self getNationCode];
//        model.domain = _server.text;
//        model.usertype = user_type_phone;
//        [model registery1:^(NSError *error, NSDictionary *info) {
//            if (!error) {
//                self.registryID = [info objectForKey:@"registryID"];
//                [SVProgressHUD showSuccessWithStatus:@"获取验证码成功"];
//                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
//                
//                [timer fire];
//            }else{
//                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
//            }
//        }];
//    }
//    else{
//        [SVProgressHUD showWithStatus:NSLocalizedString(@"获取中...", nil) maskType:SVProgressHUDMaskTypeBlack];
//        LDRegisterModel *model = [[LDRegisterModel alloc]init];
//        model.account = _account.text;
//        model.nationalCode = [self getNationCode];
//        model.domain = _server.text;
//        model.usertype = user_type_phone;
//        [model resetPwd1:^(NSError *error, NSDictionary *info) {
//            if (!error) {
//                self.registryID = [info objectForKey:@"registryID"];
//                [SVProgressHUD showSuccessWithStatus:@"获取验证码成功"];
//                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
//                
//                [timer fire];
//            }else{
//                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
//            }
//        }];
//    }
}

- (void)updateTimer{
    if(_identifyBtn.isEnabled == YES){
        _identifyBtn.enabled = NO;
        [_identifyBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
        num = 60;
    }
    num --;
    if (num == 0) {
        [_identifyBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        _identifyBtn.enabled = YES;
        [_identifyBtn setTitleColor:[UIColor colorWithRed:17/255.0 green:133/255.0 blue:181/255.0 alpha:1]forState:UIControlStateNormal];
        [timer invalidate];
        return;
    }
    
    [_identifyBtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",num] forState:UIControlStateNormal];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (_judge == 0) {
        LDFindPasswordTableViewController *find = segue.destinationViewController;
        find.authRegister = _authRegister;
        find.registryID = self.registryID;
        find.identifyCode = _identifyCode.text;
        authModel.nationalCode = [self getNationCode];
        authModel.account = _account.text;
        authModel.entArea = _server.text;
        authModel.loginType = 1;
        find.authModel = authModel;
    }
    else{
        LDServeAndPrivacyViewController *serve = segue.destinationViewController;
        serve.judge = _judge;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)stopKeyboard
{
    [_server resignFirstResponder];
    [_account resignFirstResponder];
    [_identifyCode resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
