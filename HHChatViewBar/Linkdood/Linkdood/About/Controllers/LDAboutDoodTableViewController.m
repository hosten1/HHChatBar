//
//  LDAboutDoodTableViewController.m
//  Linkdood
//
//  Created by renxin-.- on 16/2/29.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDAboutDoodTableViewController.h"
#import "LDSysHeadAndFootView.h"

@interface LDAboutDoodTableViewController ()

@end

@implementation LDAboutDoodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于连豆豆";

    [self initView];

}

- (void)initView
{
    LDSysHeadAndFootView *head = [[LDSysHeadAndFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    [head aboutDoodHeadView];
    self.tableView.tableHeaderView = head;
    LDSysHeadAndFootView *foot = [[LDSysHeadAndFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-350)];
    [foot aboutDoodfootView];
    self.tableView.tableFooterView = foot;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    view.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"LDWebsiteViewController" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



@end
