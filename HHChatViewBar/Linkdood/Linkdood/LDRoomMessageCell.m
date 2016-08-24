//
//  LDRoomMessageCell.m
//  Linkdood
//
//  Created by VRV2 on 16/7/5.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDRoomMessageCell.h"

@implementation LDRoomMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setRoomModel:(LDRoomModel *)roomModel{
    _roomModel = roomModel;
    self.headerImg.image = [UIImage imageNamed:@"group_msg"];;
    self.roomNameLable.text = _roomModel.roomName;
    self.roomNumberNumber.text = [NSString stringWithFormat:@"会话数:%ld", [roomModel.chatList count]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
