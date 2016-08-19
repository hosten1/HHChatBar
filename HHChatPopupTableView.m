//
//  HHChatPopupTableView.m
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHChatPopupTableView.h"
#import "HHChatPopupCell.h"
#define KCellHeight 30
#define cellid  @"HHChatPopupTableCell"

@interface HHChatPopupTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@end
@implementation HHChatPopupTableView
-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray{
    if (self == [super initWithFrame:frame]) {
        _titleArray = titleArray;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 30*3);
        self.backgroundColor = [UIColor whiteColor];
        [self initTableView];
    }
    return self;
}
-(void)initTableView{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
    tableView.backgroundColor = [UIColor greenColor];
    [self addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    tableView.scrollEnabled = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark   ----tableDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HHChatPopupCell *cell = [HHChatPopupCell loadTableCell:tableView idResu:cellid ];
    modelTemp *temp = [[modelTemp alloc]init];
    temp.cellname =@"dfsdf";
    cell.mode = temp;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    if (section == 2) {
        return nil;
    }
    return lineView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableViewCallBack) {
        _tableViewCallBack([NSIndexPath indexPathForRow:indexPath.section inSection:self.indexValue]);
    }
}
-(Boolean)hideView{
    if (!self.isHidden) {
        self.hidden = YES;
    }
    return true;
}
-(Boolean)showView{
    if (self.isHidden) {
        self.hidden = NO;
        [self.tableView reloadData];
    }
    return YES;
}
@end
