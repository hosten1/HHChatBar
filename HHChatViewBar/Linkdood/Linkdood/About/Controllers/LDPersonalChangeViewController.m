//
//  LDPersonalChangeViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/3/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDPersonalChangeViewController.h"

@interface LDPersonalChangeViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *changeLB;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextView *sign;

@end

@implementation LDPersonalChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:_changeName];
    _changeLB.text = _changeName;
    if([_changeName isEqualToString:@"昵称"]){
        [_sign setHidden:YES];
        _name.text = MYSELF.name;
        [_name becomeFirstResponder];
    }else if ([_changeName isEqualToString:@"豆豆号"]){
        [_sign setHidden:YES];
        _name.text = MYSELF.nickID;
        [_name becomeFirstResponder];
    }else{
        [_name setHidden:YES];
        _sign.text = MYSELF.sign;
        [_sign becomeFirstResponder];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:RGBACOLOR(0, 183, 238, 1) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(chooseDone) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 24);
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(chooseDone)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    _name.delegate = self;
    _sign.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)chooseDone{
    
    LDMyselfModel *mySelf = MYSELF;
    LDMyselfModel *selfModel = [[LDMyselfModel alloc] initWithID:mySelf.ID];
    if([_changeName isEqualToString:@"昵称"]){
        if (![_name.text isEqualToString:MYSELF.name]) {
            selfModel.name = _name.text;
            [self setMySelf:selfModel];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if ([_changeName isEqualToString:@"豆豆号"]){
        if (_name.text.length == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            selfModel.nickID = _name.text;
            [self setMySelf:selfModel];
        }
    }else{
        if (![_sign.text isEqualToString:MYSELF.sign]) {
            selfModel.sign = _sign.text;
            [self setMySelf:selfModel];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)setMySelf:(LDMyselfModel*)mySelf
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"修改中...", nil) maskType:SVProgressHUDMaskTypeBlack];
    [mySelf modifyMyselfBasicInfo:^(NSError *error, LDMyselfModel *myself) {
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)stopKeyboard
{
    [_name resignFirstResponder];
    [_sign resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
