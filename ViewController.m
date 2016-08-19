//
//  ViewController.m
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "ViewController.h"
#import "HHChatBarView.h"
@interface ViewController ()<HHChatBarDelegate>
@property(nonatomic,copy)NSDictionary *dic;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = @{@"menu":@[@{@"name":@"haha",@"sub":@[@"测试",@"测试3"]},@{@"name":@"帮助",@"sub":@[@"测试",@"测试3"]},@{@"name":@"详情",@"sub":@[@"测试"]},@{@"name":@"查看",@"sub":@[@"测试4",@"测试4",@"哈哈哈"]}]};
    self.dic = dic;
    
    HHChatBarView *chat = [[HHChatBarView alloc]initWithDictionary:dic];
    chat.ChatDelegate = self;
    [chat setupSubviewItems];
    [self.view addSubview:chat];
}
-(NSInteger)numberOfSectionWithchatBar:(HHChatBarView *)charBar{
    NSArray * arr = self.dic[@"menu"];
    return arr.count;
}
-(NSString*)chatBar:(HHChatBarView *)charBar sectionTitleWithIndexPath:(NSIndexPath *)indexPath{
    NSArray * arr = self.dic[@"menu"];
    NSString *name = arr[indexPath.section][@"name"];
    return name;
}
-(NSArray*)chatBar:(HHChatBarView *)charBar subPopViewTitleOfRowWithIndexPath:(NSIndexPath *)indexPath{
    NSArray * arr = self.dic[@"menu"];
    NSArray *sub = arr[indexPath.section][@"sub"];
    return sub;
}
-(void)chatBar:(HHChatBarView *)charBar didSelectIndex:(NSIndexPath *)indexPath{
    NSLog(@"section::%ld,row:::%ld",indexPath.section,indexPath.row);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

 
}

@end
