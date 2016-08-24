//
//  LDLoginViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/1/18.
//  Copyright © 2016年 VRV. All rights reserved.
//

#import "LDAuthLoginViewController.h"
#import "LDLoginTableViewCell.h"
#import "AppDelegate.h"
#import "LDAuthRegisterTableViewController.h"

@interface LDAuthLoginViewController ()<UITextFieldDelegate,LDLoginTableViewCellDelegate>
{
    int num;
    NSMutableString *nation;
}

@property (weak, nonatomic) IBOutlet UITableView *loginTableView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeLoginName;
@property (strong, nonatomic) NSString *server;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *changeLogin;

@end

@implementation LDAuthLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    nation = [[NSMutableString alloc]initWithString:@"+86"];
    self.view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.loginTableView.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.navigationController.navigationBar.translucent = YES;
    
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)initView
{
    _loginBtn.layer.borderWidth = 1;
    _loginBtn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    [_loginBtn.layer setCornerRadius:5];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    _changeLogin = @"email";
    num = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (num > 4) {
        return 5;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LDLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryCell" forIndexPath:indexPath];
        cell.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSelectCountry)];
        [cell addGestureRecognizer:tap];
        return cell;
    }
    if (indexPath.row == 1) {
        LDLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serverCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row == 2) {
        LDLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row == 3) {
        LDLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"passwordCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row == 4) {
        LDLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifyCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    return nil;
    
//    switch (indexPath.row) {
//        case 0:
//            return [tableView dequeueReusableCellWithIdentifier:@"countryCell" forIndexPath:indexPath];
//        case 1:
//            return [tableView dequeueReusableCellWithIdentifier:@"serverCell" forIndexPath:indexPath];
//        case 2:
//            return [tableView dequeueReusableCellWithIdentifier:@"AccountCell" forIndexPath:indexPath];
//        case 3:
//            return [tableView dequeueReusableCellWithIdentifier:@"passwordCell" forIndexPath:indexPath];
//        case 4:
//            return [tableView dequeueReusableCellWithIdentifier:@"identifyCell" forIndexPath:indexPath];
//        default:
//            return nil;
//    }    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LDAuthRegisterTableViewController *auth = segue.destinationViewController;
    auth.authRegister = NO;
}

- (IBAction)loginTap:(UIButton *)sender {
    NSString *server = _server;
    NSString *account = _account;
    NSString *password = _password;
    
    if ([server length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"服务器不能为空"];
//        [cell.serve resignFirstResponder];
        return;
    }
    if ([account length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
//        [cell.phone resignFirstResponder];
        return;
    }
    if ([password length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
//        [cell.password resignFirstResponder];
        return;
    }
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"登录中...", nil) maskType:SVProgressHUDMaskTypeBlack];
    [self.view hideKeyboard];
    [[LDClient sharedInstance] loginWithAccount:account
                                       password:password
                                      loginType:user_type_phone
                                         region:[self getNationCode]
                                         domain:server
                                     completion:^(NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            num = 0;
            [(AppDelegate*)SYS_DELEGATE loginSuccess];
        }else{
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            if (num>4) {
                [_loginTableView reloadData];
            }
            num++;
        }
        
    }];
}
- (IBAction)forgetPasswordTap:(UIButton *)sender {
    [self performSegueWithIdentifier:@"loginToFindPassword" sender:nil];
}
- (IBAction)emailLoginTap:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLoginNotification" object:_changeLogin];//注册切换邮箱与电话登录通知
    if ([_changeLogin isEqualToString:@"email"]) {
        _changeLogin = @"phone";
        [_changeLoginName setTitle:@"手机号登录" forState:UIControlStateNormal];
    }
    else{
        _changeLogin = @"email";
        [_changeLoginName setTitle:@"邮箱登录" forState:UIControlStateNormal];
        LDLoginTableViewCell *cell2 = [_loginTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell2.phoneOrEmail.text = nation;
    }
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

#pragma mark SelectCountryDelegate
- (void)choiceCountry:(NSDictionary*)country{
    LDLoginTableViewCell *cell1 = [_loginTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell1.nationLabel.text = [[country allValues] lastObject];
    
    nation = [NSMutableString stringWithFormat:@"%@",[[country allKeys] lastObject]];
    if(![_changeLogin isEqualToString:@"phone"]){
        LDLoginTableViewCell *cell2 = [_loginTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell2.phoneOrEmail.text = [NSString stringWithFormat:@"%@",[[country allKeys] lastObject]];
    }
}

#pragma mark - LDLoginTableViewCellDelegate
- (void)server:(NSString *)server
{
    _server = server;
}
- (void)account:(NSString *)account
{
    _account = account;
}
- (void)password:(NSString *)password
{
    _password = password;
}

- (void)stopKeyboard
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideKeyboardNotification" object:nil];//注册隐藏键盘通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
