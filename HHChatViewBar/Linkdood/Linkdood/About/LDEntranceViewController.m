//
//  LDEntranceViewController.m
//  Linkdood
//
//  Created by yue on 8/18/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "LDEntranceViewController.h"
#import "LDEntranceCell.h"
#import "LDSysMessageViewController.h"
#import "LDTaskViewController.h"
#import "LDBlacklistTableViewController.h"

@interface LDEntranceViewController ()

@end

@implementation LDEntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Console";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LDEntranceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"unit" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            cell.title.text = @"系统消息";
        }
            break;
        case 1:{
            cell.title.text = @"任务";
        }
            break;
        case 2:{
            cell.title.text = @"黑名单";
        }
            break;
        case 3:{
            cell.title.text = @"退出";
        }
        default:
            break;
    }
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LDSysMessageViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDSysMessageViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            LDTaskViewController *vc = [[LDTaskViewController alloc]initWithNibName:@"LDTaskViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
            LDBlacklistTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDBlacklistTableViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
            break;
        default:
            break;
    }
}
@end
