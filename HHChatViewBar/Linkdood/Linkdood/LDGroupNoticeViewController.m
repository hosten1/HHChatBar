//
//  Linkdood
//
//  Created by VRV on 15/12/10. c
//  Copyright © 2015年 VRV. All rights reserved.

#import "LDGroupNoticeViewController.h"

@interface LDGroupNoticeViewController ()

@end

@implementation LDGroupNoticeViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"群公告", nil);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}

- (void)initView
{
    _textView.text = self.groupModel.bulletin;
    LDGroupMemberModel *member = (LDGroupMemberModel *)[[LDClient sharedInstance].groupMembers itemWithID:MYSELF.ID];
    if (member.userType > 1) {
        _textView.editable = YES;
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setTitle:@"保存" forState:UIControlStateNormal];
        [button1 setTitleColor:RGBACOLOR(0, 183, 238, 1) forState:UIControlStateNormal];
        [button1.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button1 addTarget:self action:@selector(chooseDone) forControlEvents:UIControlEventTouchUpInside];
        button1.frame = CGRectMake(0, 0, 30, 24);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    }else{
        _textView.editable = NO;
    }
}

- (void)chooseDone
{
    if ([_groupModel.bulletin isEqualToString:_textView.text]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupNoticeNotification" object:_textView.text];//注册更改公告称通知
        [SVProgressHUD showWithStatus:NSLocalizedString(@"请稍等...", nil) maskType:SVProgressHUDMaskTypeClear];
        
        LDGroupModel *group = [[LDGroupModel alloc] initWithID:_groupModel.ID];
        group.bulletin = _textView.text;
        [group updateGroupInfo:^(NSError *error) {
                [SVProgressHUD dismiss];
                if(!error){
                    [self.navigationController popViewControllerAnimated:YES];
                    _groupModel.bulletin = _textView.text;
                }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
