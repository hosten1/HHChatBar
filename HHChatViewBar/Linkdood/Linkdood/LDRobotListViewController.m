//
//  LDRobotListViewController.m
//  Linkdood
//
//  Created by 王越 on 16/3/4.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDRobotListViewController.h"
#import "LDRobotChatViewController.h"
#import "LDRobotCell.h"

@interface LDRobotListViewController () <MJNIndexViewDataSource>{
    LDRobotListModel *robotList;
}

@end

@implementation LDRobotListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    robotList = [LDClient sharedInstance].robotListModel;
    if ([robotList numberOfSections] == 0) {
        [robotList assembleData];
    }
    self.title = @"机器人";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.indexView removeFromSuperview];
    self.indexView = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadIndexView];
}

- (void)loadIndexView
{
    if (!self.indexView) {
        self.indexView = [[MJNIndexView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height)];
        self.indexView.dataSource = self;
        self.indexView.font = [UIFont systemFontOfSize:13];
        self.indexView.fontColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        [self.navigationController.view addSubview:self.indexView];
    }
}
#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return [robotList sectionIndexTitles];
}
- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [robotList numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [robotList numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LDRobotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDRobotCell"];
    LDRobotModel *robot = (LDRobotModel*)[robotList itemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    [cell setRobot:robot];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LDRobotModel *robot = (LDRobotModel *)[robotList itemAtIndexPath:indexPath];
    if (self.qrCodeBlock) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"普通名片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.backContactBlock) {
                self.backContactBlock(robot);
            } ;
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"二维码名片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.qrCodeBlock) {
                self.qrCodeBlock(robot);
            } ;
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:actionOne];
        [alertController addAction:actionTwo];
        [self presentViewController:alertController animated:YES completion:nil];

        return;
    }else if (self.backContactBlock){
        self.backContactBlock(robot);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    LDRobotChatViewController *chatView = [[LDRobotChatViewController alloc] initWithTarget:robot.ID];
    [chatView setSenderDisplayName:robot.appName];
    [self.navigationController pushViewController:chatView animated:YES];   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc] initWithFrame:(CGRect){0,0,[APP_WINDOW width],30}];
    [header setText: [NSString stringWithFormat:@"   %@",[robotList sectionIndexTitle:section]]];
    [header setBackgroundColor:[UIColor clearColor]];
    [header setTextColor:[UIColor grayColor]];
    [header setFont:[UIFont systemFontOfSize:14]];
    return  header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
@end
