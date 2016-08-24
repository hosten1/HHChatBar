//
//  HHChatPopupTableView.m
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHChatPopupTableView.h"
#import "HHChatPopupCell.h"
#import "LDChatBarCellModel.h"
#define cellid  @"HHChatPopupTableCell"

@interface HHChatPopupTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;

@end
@implementation HHChatPopupTableView
-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray{
    if (self == [super initWithFrame:frame]) {
        NSAssert(titleArray==nil||titleArray.count!=0, @"子标题数组为空");
        _titleArray = titleArray;
        self.cellHeight = frame.size.height;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.cellHeight*titleArray.count);
        self.backgroundColor = [UIColor whiteColor];
        [self initTableView];
    }
    return self;
}
-(void)initTableView{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
    tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    tableView.scrollEnabled = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark   ----tableDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HHChatPopupCell *cell = [HHChatPopupCell loadTableCell:tableView idResu:cellid ];
    LDChatBarCellModel *temp = [[LDChatBarCellModel alloc]init];
    temp.cellname =self.titleArray[indexPath.row];
    cell.mode = temp;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.tableView.bounds.size.width-10, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.790 green:0.802 blue:0.838 alpha:1.000];
    if (section == self.titleArray.count-1) {
        return nil;
    }
    return lineView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
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
