//
//  LDFeedbackViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/2/29.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDFeedbackViewController.h"

@interface LDFeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *feedbackMessage;
@property (strong,nonatomic) UIButton *navButton;
@property (strong,nonatomic) LDMessageListModel *messageList;
@end

@implementation LDFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    //解决偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    _feedbackMessage.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    _navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navButton setTitle:@"发送" forState:UIControlStateNormal];
    [_navButton setTitleColor:RGBACOLOR(0, 183, 238, 1) forState:UIControlStateNormal];
    [_navButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_navButton addTarget:self action:@selector(sendFeedback) forControlEvents:UIControlEventTouchUpInside];
    _navButton.frame = CGRectMake(0, 0, 30, 24);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navButton];
    [_navButton setHidden:YES];
}

//发送消息
-(void)sendFeedback
{
    [self.view hideKeyboard];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"提交中...", nil) maskType:SVProgressHUDMaskTypeBlack];
    //发送文本消息
    LDTextMessageModel *message = [[LDTextMessageModel alloc] initWithText:self.feedbackMessage.text];
    LDChatModel *chatModel = [[LDChatModel alloc] initWithID:Feedback];
    [chatModel sendMessage:message onStatus:^(msg_status status) {
        if (status == msg_normal) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if(status == msg_failure){
            [SVProgressHUD showErrorWithStatus:@"提交失败"];
        }else{
            [SVProgressHUD showWithStatus:@"提交中" maskType:SVProgressHUDMaskTypeClear];
        }
    }];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (_feedbackMessage.text.length == 0 && [_feedbackMessage.text isEqualToString:@""]) {
        [_navButton setHidden:YES];
    }
    else{
        [_navButton setHidden:NO];
    }
}

- (void)stopKeyboard
{
    [_feedbackMessage resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
