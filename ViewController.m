//
//  ViewController.m
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "ViewController.h"
#import "HHChatBarView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = @{};
    
    HHChatBarView *chat = [[HHChatBarView alloc]initWithDictionary:@{}];
    [self.view addSubview:chat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

 
}

@end
