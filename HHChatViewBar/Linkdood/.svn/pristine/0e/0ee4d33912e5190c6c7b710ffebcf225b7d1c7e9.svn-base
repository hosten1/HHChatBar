//
//  LDSysMessageCell.h
//  Linkdood
//
//  Created by xiong qing on 16/4/6.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SysMessageDelegate

@optional
- (void)agreePressed:(id)sender;

@end

@interface LDSysMessageCell : UITableViewCell

@property (strong,nonatomic) LDSysMsgModel *sysMessage;

@property (weak,nonatomic) IBOutlet UIImageView *portrait;
@property (weak,nonatomic) IBOutlet UILabel *sender;
@property (weak,nonatomic) IBOutlet UILabel *message;
@property (weak,nonatomic) IBOutlet UILabel *time;
@property (weak,nonatomic) IBOutlet UIButton *oparate;
@property (weak,nonatomic) id delegate;

@end
