//
//  LDMyQRViewController.m
//  Linkdood
//
//  Created by VRV2 on 16/8/17.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDMyQRViewController.h"
#import "HMScannerController.h"

@interface LDMyQRViewController()
@property (strong,nonatomic) UIImageView *imageView;
@end
@implementation LDMyQRViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"我的二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *avatarImageView = [[UIImageView alloc]init];
    avatarImageView.center = self.view.center;
    self.imageView  = avatarImageView;
    [self.view addSubview:avatarImageView];
    avatarImageView.bounds = CGRectMake(0, 0,200, 200);
    NSString *msgFrom = @"Unisex";
    if (MYSELF.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (MYSELF.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    WEAKSELF
   [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeGradient];
    [[LDClient sharedInstance] avatar:MYSELF.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        if (avatar) {
            [HMScannerController cardImageWithCardName:[NSString stringWithFormat:@"http://im.vrv.cn/user/getinfo?uid=%lld",MYSELF.ID] avatar:avatar contentSize:2000 completion:^(UIImage *image) {
                if (image) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        weakSelf.image = image;
                    });
                }
            }];
        }
    }];
    

    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.image&&!self.imageView.image) {
            self.imageView.image = self.image;
            [SVProgressHUD dismiss];
    }
}


-(void)didReceiveMemoryWarning{
    
}
@end
