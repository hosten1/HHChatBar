//
//  LDLoginTableViewCell.m
//  Linkdood
//
//  Created by renxin-.- on 16/1/18.
//  Copyright © 2016年 VRV. All rights reserved.
//

#import "LDLoginTableViewCell.h"

@implementation LDLoginTableViewCell

- (void)awakeFromNib {
    self.server.delegate = self;
    self.account.delegate = self;
    self.password.delegate = self;
    [_server setValue:RGBACOLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_account setValue:RGBACOLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_password setValue:RGBACOLOR(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [self.server addTarget:self action:@selector(serverChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [self.account addTarget:self action:@selector(accountChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [self.password addTarget:self action:@selector(passwordChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginNotificationHandle:) name:@"changeLoginNotification" object:nil];//更改手机号或邮箱登陆状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboardNotificationHandle) name:@"hideKeyboardNotification" object:nil];//隐藏键盘
//    NSString *serverDefault  = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverDefault"];
//    NSString *accountDefault  = [[NSUserDefaults standardUserDefaults] stringForKey:@"accountDefault"];
//    NSString *passwordDefault  = [[NSUserDefaults standardUserDefaults] stringForKey:@"passwordDefault"];
//    if(serverDefault){
//        _server.text = serverDefault;
//    }
//    if(accountDefault){
//        _account.text = accountDefault;
//    }
//    if(passwordDefault){
//        _password.text = passwordDefault;
//    }

}

- (void) serverChangeAction:(id) sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(server:)]) {
        [self.delegate server:_server.text];
    }
}

- (void) accountChangeAction:(id) sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(account:)]) {
        [self.delegate account:_account.text];
    }
}

- (void) passwordChangeAction:(id) sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(password:)]) {
        [self.delegate password:_password.text];
    }
}

-(void) changeLoginNotificationHandle:(NSNotification *) notification{
    NSString *str = [notification object];
    if ([str isEqualToString:@"email"]) {
        _phoneOrEmail.text = @"邮箱";
        _account.placeholder = @"请填写邮箱号";
        _account.keyboardType = UIKeyboardTypeDefault;
    }
    else{
        _phoneOrEmail.text = @"+86";
        _account.placeholder = @"手机号";
        _account.keyboardType = UIKeyboardTypePhonePad;
    }
    _account.text = @"";
    _password.text = @"";
}

- (void)hideKeyboardNotificationHandle
{
    [_server resignFirstResponder];
    [_account resignFirstResponder];
    [_password resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
