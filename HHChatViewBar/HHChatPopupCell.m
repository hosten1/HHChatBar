//
//  HHChatPopupCell.m
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHChatPopupCell.h"

@implementation HHChatPopupCell
+(instancetype)loadTableCell:(UITableView*)tableView idResu:(NSString*)cellid{
    HHChatPopupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[HHChatPopupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
  
//    cell.backgroundColor = [UIColor colorWithRed:0.970 green:0.965 blue:0.931 alpha:1.000];
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子控件
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(5, self.contentView.frame.size.height-12, self.bounds.size.width-10, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:0.790 green:0.802 blue:0.838 alpha:1.000];
        [self.contentView addSubview:lineView];
    }
    return self;
}
-(void)setMode:(LDChatBarCellModel *)mode{
    _mode = mode;
    self.textLabel.text = mode.cellname;
    self.textLabel.textColor = [UIColor orangeColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:14];

}

@end
