//
//  LDChangeGroupNameViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/1/15.
//  Copyright © 2016年 VRV. All rights reserved.
//

#import "LDChangeGroupNameViewController.h"

@interface LDChangeGroupNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *changeName;

@end

@implementation LDChangeGroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"修改名称", nil);
    
    self.view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 24, 24);
    UIBarButtonItem *sbuttonGetUser = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = sbuttonGetUser;
    _changeName.text = _groupModel.groupName;

    
    [self initView];
}

- (void)initView
{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"保存" forState:UIControlStateNormal];
    [button1 setTitleColor:RGBACOLOR(0, 183, 238, 1) forState:UIControlStateNormal];
    [button1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button1 addTarget:self action:@selector(chooseDone) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(0, 0, 30, 24);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseDone{
    if ([_groupModel.groupName isEqualToString:_changeName.text]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [SVProgressHUD showWithStatus:NSLocalizedString(@"请稍等...", nil) maskType:SVProgressHUDMaskTypeClear];
        
        LDGroupModel *group = [[LDGroupModel alloc]init];
        group.ID = _groupModel.ID;
        group.groupName = _changeName.text;
        
        [group updateGroupInfo:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                _groupModel.groupName = group.groupName;
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"groupNameNotification" object:_changeName.text];//注册更改名称通知
            }else{
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
