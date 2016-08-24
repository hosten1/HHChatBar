//
//  LDAutomaticLoginViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/1/12.
//  Copyright © 2016年 VRV. All rights reserved.
//

#import "LDAutomaticLoginViewController.h"
#import "LDAuthLoginViewController.h"
#import "LDAuthRegisterTableViewController.h"
#import "AppDelegate.h"

@interface LDAutomaticLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *identify;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIButton *identifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginLayout;

@property (assign, nonatomic) int num;
@property (assign, nonatomic) int loginNum;


@end

@implementation LDAutomaticLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    
    LDAuthModel *authModel = [LDClient sharedInstance].loginConfig;
    [[LDClient sharedInstance] avatar:authModel.avatar withDefault:@"MaleIcon" complete:^(UIImage *avatar) {
        [_avatar setImage:avatar];
    }];
    _avatar.layer.cornerRadius = 40;
    _avatar.layer.masksToBounds = YES;
    
    NSMutableString *name = [[NSMutableString alloc]initWithString:authModel.account];
    NSRange range = [name rangeOfString:authModel.nationalCode];
    if (range.location != NSNotFound) {
        [name deleteCharactersInRange:range];
    }
    _name.text = name;

    _loginBtn.layer.borderWidth = 1;
    _loginBtn.layer.borderColor = [RGBACOLOR(230, 230, 230, 1) CGColor];
    [_loginBtn.layer setCornerRadius:5];
    _password.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopKeyboard)];
    [self.view addGestureRecognizer:tap];
    [_identify setHidden:YES];
    [_lab setHidden:YES];
    [_identifyBtn setHidden:YES];
    [_lab1 setHidden:YES];
    _loginNum = 0;
    _loginLayout.constant = -30;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
}

- (IBAction)loginTap:(UIButton *)sender {
    NSString *password = [_password text];
    if ([password length] == 0)	{
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        [_password resignFirstResponder];
        return;
    }
    [self.view hideKeyboard];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"登录中...", nil) maskType:SVProgressHUDMaskTypeBlack];
    
    [[LDClient sharedInstance] autoLoginWithPassword:password completion:^(NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            [(AppDelegate*)SYS_DELEGATE  loginSuccess];
        }else{
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            if (_loginNum>4) {
                [_identify setHidden:NO];
                [_lab setHidden:NO];
                [_identifyBtn setHidden:NO];
                [_lab1 setHidden:NO];
                _loginLayout.constant = 42;
                
            }
            _loginNum++;
        }
    }];
}
- (void)fillView
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [(AppDelegate*)SYS_DELEGATE loginSuccessfulCompleteBlock:^{
//            
//        }];
//    });
}
- (IBAction)forgetPasswordTap:(id)sender {
    _num = 1;
    [self performSegueWithIdentifier:@"automaticToRegister" sender:nil];
}
- (IBAction)registerTap:(id)sender {
    _num = 2;
    [self performSegueWithIdentifier:@"automaticToRegister" sender:nil];
}

- (IBAction)changeAccountTap:(id)sender {
    _num = 0;
    [self performSegueWithIdentifier:@"automaticToLogin" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"automaticToRegister"]) {
        LDAuthRegisterTableViewController *vc = segue.destinationViewController;
        vc.authRegister = NO;
    }
    
    if (_num == 2) {
        LDAuthRegisterTableViewController *vc = segue.destinationViewController;
        vc.authRegister = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)stopKeyboard
{
    [_password resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
