//
//  LDChatRoomMessageCell.m
//  Linkdood
//
//  Created by VRV2 on 16/7/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDChatRoomMessageCell.h"
#import "KYCuteView.h"
#import "NSString+MLExpression.h"

@interface LDChatRoomMessageCell(){
    MLExpression *exp;
}
@end 
@implementation LDChatRoomMessageCell

- (void)awakeFromNib {
    [_portrait setCornerRadius:_portrait.width / 2];
    [_isread setCornerRadius:_isread.width / 2];
    
    CGFloat wid = self.unread.frame.size.width;
    CGFloat y = CGRectGetMaxY(self.time.frame)+15;
    
    CGFloat x = [UIScreen mainScreen].bounds.size.width-30;
    KYCuteView *cuteView = [[KYCuteView alloc]initWithPoint:CGPointMake(x,y) superView:self.contentView];
    
    self.cuteView = cuteView;
    cuteView.isSubview  = YES;
    cuteView.viscosity  = 50;
    cuteView.bubbleWidth = wid-20;
    cuteView.bubbleHeight = 18;
    cuteView.bubbleColor = [UIColor redColor];
    [cuteView setUp];
    cuteView.bubbleLabel.font = [UIFont systemFontOfSize:12];
    self.cuteView.frontView.hidden = YES;
    
    
    _unread.hidden = YES;
    [_unread setBackgroundImage:[[UIImage imageNamed:@"Unread"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 19, 0, 19)] forState:UIControlStateNormal];
    
}

- (void)setChatModel:(LDChatModel *)chatModel
{
    if (chatModel.isTopChat) {
        [self.contentView setBackgroundColor:RGBACOLOR(240, 240, 240, 1.0)];
    }else{
        [self.contentView setBackgroundColor:RGBACOLOR(255, 255, 255, 1.0)];
    }
    [_sender setText:chatModel.sender];
    [_sender setTextColor:[UIColor blackColor]];
    NSString *msgFrom = @"Unisex";
    if (chatModel.status == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (chatModel.status == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    if (chatModel.status == msg_owner_group) {
        msgFrom = @"GroupIcon";
    }
    IDRange range = idRange(chatModel.ID);
    if (range == id_range_ROBOT) {
        msgFrom = @"robot";
    }
    [[LDClient sharedInstance] avatar:chatModel.avatarUrl withDefault:msgFrom complete:^(UIImage *avatar) {
        [_portrait setImage:avatar];
    }];
    
    if (chatModel.status == msg_owner_group && ![chatModel.whereFrom isEmpty] && chatModel.whereFrom != nil) {
        _message.attributedText = [[NSString stringWithFormat:@"%@:%@",chatModel.whereFrom,chatModel.lastMsg] expressionAttributedStringWithExpression:[self getMLExpression]];
    }else{
        _message.attributedText = [chatModel.lastMsg expressionAttributedStringWithExpression:[self getMLExpression]];
    }
    
    if(chatModel.lastAtMsgID){
        _message.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"[有人@我]%@",_message.text] attributes:@{                                                                                                                                                  NSForegroundColorAttributeName:[UIColor orangeColor]                                                                                                                                    }];
    }
    
    [_time setText:[[NSString stringWithFormat:@"%lld",chatModel.timestamp] specialTime:nil]];
    
    if (chatModel.unreadNumber == 0) {
        [_unread setHidden:YES];
        //隐藏自定义小红点
        self.cuteView.frontView.hidden = YES;
    }else{
        [_unread setHidden:YES];
        self.cuteView.frontView.hidden = NO;
        
        __weak typeof(self) weakSelf = self;
        self.cuteView.returnBlock = ^(bool state){
            if (state) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置消息会话已读
                    [chatModel makeMessageReaded];
                    weakSelf.cuteView.frontView.hidden = YES;
                });
            }
        };
        NSString *unreade = chatModel.unreadNumber > 99?@"99+":[NSString stringWithFormat:@"%hd",chatModel.unreadNumber];
        [_unread setTitle:unreade forState:UIControlStateNormal];
        if (chatModel.unreadNumber < 10) {
            _unreadConstraint.constant = 38;
            self.cuteView.bubbleWidth = 18;
            self.cuteView.bubbleLabel.text = unreade;
            self. cuteView.bubbleLabel.font = [UIFont systemFontOfSize:12];
        }
        if (chatModel.unreadNumber >= 10) {
            _unreadConstraint.constant = 45;
            self.cuteView.bubbleWidth = 24;
            self.cuteView.bubbleLabel.text = unreade;
            self. cuteView.bubbleLabel.font = [UIFont systemFontOfSize:12];
        }
        if (chatModel.unreadNumber > 99)
        {
            _unreadConstraint.constant = 50;
            self.cuteView.bubbleWidth = 30;
            self.cuteView.bubbleLabel.text = unreade;
            self.cuteView.bubbleLabel.font = [UIFont systemFontOfSize:12];
        }
    }
    
//    [self setRightButton:chatModel];
}

-(void)setSearchChatModel:(LDChatModel *)searchChatModel
{
    [_unread setHidden:YES];
    [_time setHidden:YES];
    [_sender setTextColor:[UIColor blackColor]];
    [_sender setText:searchChatModel.sender];
    NSString *msgFrom = @"Unisex";
    if (searchChatModel.status == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (searchChatModel.status == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    if (searchChatModel.status == msg_owner_group) {
        msgFrom = @"GroupIcon";
    }
    [[LDClient sharedInstance] avatar:searchChatModel.avatarUrl withDefault:msgFrom complete:^(UIImage *avatar) {
        [_portrait setImage:avatar];
    }];
    [_message setText:[NSString stringWithFormat:@"%d条聊天记录",searchChatModel.unreadNumber]];
}



-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        
        [self.cuteView.frontView setBackgroundColor:[UIColor redColor]];
    }
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        
        [self.cuteView.frontView setBackgroundColor:[UIColor redColor]];
    }
}


- (MLExpression *)getMLExpression
{
    if (!exp) {
        MLExpression *expression = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"LDDExpression" bundleName:@"LDDCExpression"];
        exp = expression;
    }
    return exp;
}

@end
