//
//  LDSysMessageCell.m
//  Linkdood
//
//  Created by xiong qing on 16/4/6.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDSysMessageCell.h"

@implementation LDSysMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_portrait setCornerRadius:_portrait.width / 2];
}

-(void)setSysMessage:(LDSysMsgModel *)sysMessage
{
    [[LDClient sharedInstance] avatar:sysMessage.portraitUrl withDefault:@"sys_message" complete:^(UIImage *avatar) {
        [_portrait setImage:avatar];
    }];
    [_time setText:[[NSString stringWithFormat:@"%lld",sysMessage.timestamp] specialTime:nil]];
    [_oparate setHidden:(sysMessage.msgType == 2 || sysMessage.msgType == 4)];
    NSMutableAttributedString *textAttributed;
    if (sysMessage.msgType == 1) {
        textAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@请求加您为好友",sysMessage.userName]];
        [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, sysMessage.userName.length)];
    }
    if (sysMessage.msgType == 2) {
        if (sysMessage.opType == 1) {
            textAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@同意了您的好友申请",sysMessage.userName]];
        }else{
            textAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@拒绝了您的好友申请",sysMessage.userName]];
        }
        [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, sysMessage.userName.length)];
    }
    if (sysMessage.msgType == 3) {
        if (sysMessage.subType == 1) {
            textAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@邀请您加入群%@",sysMessage.userName,sysMessage.groupName]];
        }
        if (sysMessage.subType == 2) {
            textAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@申请加入群%@",sysMessage.userName,sysMessage.groupName]];
        }
        [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, sysMessage.userName.length)];
        [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(textAttributed.length - sysMessage.groupName.length, sysMessage.groupName.length)];
    }
    if (sysMessage.msgType == 4) {
        if (sysMessage.opType == 1) {
            textAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@忽略了您的入群申请",sysMessage.userName]];
            [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, sysMessage.userName.length)];
        }
        if (sysMessage.opType == 2) {
            textAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@同意您加入群%@",sysMessage.userName,sysMessage.groupName]];
            [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, sysMessage.userName.length)];
            [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(textAttributed.length - sysMessage.groupName.length, sysMessage.groupName.length)];
        }
        if (sysMessage.opType == 3 || sysMessage.opType == 4) {
            textAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@拒绝您加入群%@",sysMessage.userName,sysMessage.groupName]];
            [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, sysMessage.userName.length)];
            [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(textAttributed.length - sysMessage.groupName.length, sysMessage.groupName.length)];
        }
        if (sysMessage.opType == 5) {
            textAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@解散了群%@",sysMessage.userName,sysMessage.groupName]];
            [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, sysMessage.userName.length)];
            [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(textAttributed.length - sysMessage.groupName.length, sysMessage.groupName.length)];
        }
        if (sysMessage.opType == 6) {
            textAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@将您移出群%@",sysMessage.userName,sysMessage.groupName]];
            [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, sysMessage.userName.length)];
            [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(textAttributed.length - sysMessage.groupName.length, sysMessage.groupName.length)];
        }
        if (sysMessage.opType == 7) {
            textAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@退出群%@",sysMessage.userName,sysMessage.groupName]];
            [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, sysMessage.userName.length)];
            [textAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(textAttributed.length - sysMessage.groupName.length, sysMessage.groupName.length)];
        }
    }
    [_sender setAttributedText:textAttributed];
    if (sysMessage.addInfo) {
        [_message setText:[@"附言:" stringByAppendingString:sysMessage.addInfo]];
    }
}

- (IBAction)agree:(id)sender {
    if ([self.delegate respondsToSelector:@selector(agreePressed:)]) {
        [self.delegate agreePressed:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
