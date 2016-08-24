//
//  LDLocationDetailsViewController.m
//  Linkdood
//
//  Created by VRV2 on 16/5/26.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDLocationDetailsViewController.h"
#import "HHLocationServiceView.h"

@interface LDLocationDetailsViewController ()

@end

@implementation LDLocationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"位置详情";
    
    UIButton *button = [NSString createGoBackButton:@"goback"];
    
    [button addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    HHLocationServiceView *location = [[HHLocationServiceView alloc]initWithFrame:self.view.frame inView:nil];
    location.latitude = self.locationMsg.latitude;
    location.longitude = self.locationMsg.longitude;
    location.address = self.locationMsg.address;
    NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"-operation-下载图片-%@",[NSThread currentThread]);
        [location getUserLocation];
        
    }];
    
    //创建队列
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    //把任务添加到队列中（自动执行，自动开线程）
    [queue addOperation:operation];
//    [location getUserLocation];
    [self.view addSubview:location];

}

-(void)dissmiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
