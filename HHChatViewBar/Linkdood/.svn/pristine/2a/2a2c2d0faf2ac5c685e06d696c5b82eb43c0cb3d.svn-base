//
//  LDMessageCell.m
//  Linkdood
//
//  Created by xiong qing on 16/2/22.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDMessageCell.h"
#import "KYCuteView.h"
#import "NSString+MLExpression.h"
#import "HQliquidButton.h"

@interface LDMessageCell ()
{
    MLExpression *exp;
}
@end
@implementation LDMessageCell

- (void)awakeFromNib {
    [_portrait setCornerRadius:_portrait.width / 2];
    [_isread setCornerRadius:_isread.width / 2];
    
    CGFloat y = CGRectGetMaxY(self.time.frame)+15;
    CGFloat x = [UIScreen mainScreen].bounds.size.width-30;
    
    HQliquidButton *redPoint = [[HQliquidButton alloc] initWithLocationCenter:CGPointMake(x, y)];
    redPoint.bagdeLableWidth = 18;
    self.liquidButton = redPoint;
    redPoint.maxDistance = 100;
    redPoint.maxTouchDistance = 30;
    [self.contentView addSubview:redPoint];
    redPoint.hidden = YES;
    
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
    if (chatModel.msgType == MESSAGE_TYPE_TIP) {
         _message.attributedText = [@"[弱提示]" expressionAttributedStringWithExpression:[self getMLExpression]];
    }else if(chatModel.msgType == MESSAGE_TYPE_REVOKE){
         _message.attributedText = [@"[撤回]" expressionAttributedStringWithExpression:[self getMLExpression]];
    }else if(chatModel.msgType == MESSAGE_TYPE_LUCKYMONEY){
        _message.attributedText = [[NSString stringWithFormat:@"%@:[红包]",chatModel.whereFrom] expressionAttributedStringWithExpression:[self getMLExpression]];
    }
    
    if(chatModel.msgType == MESSAGE_TYPE_TEXT){
        if ([chatModel.lastMsg containsString:DirectiveShake]) {//如果是抖一抖消息
            NSString *text = [chatModel.lastMsg stringByReplacingOccurrencesOfString:DirectiveShake withString:@""];
            _message.attributedText = [[NSString stringWithFormat:@"%@ [抖一抖]",text] expressionAttributedStringWithExpression:[self getMLExpression]];
        }
        else if ([chatModel.lastMsg containsString:DirectivedelDelToday]){//如果是橡皮擦消息
            NSString *text = [chatModel.lastMsg stringByReplacingOccurrencesOfString:DirectivedelDelToday withString:@""];
            _message.attributedText = [[NSString stringWithFormat:@"%@ [橡皮擦]",text] expressionAttributedStringWithExpression:[self getMLExpression]];
        }
        else if ([chatModel.lastMsg containsString:DirectivedelDelAll]){
            NSString *text = [chatModel.lastMsg stringByReplacingOccurrencesOfString:DirectivedelDelAll withString:@""];
            _message.attributedText = [[NSString stringWithFormat:@"%@ [橡皮擦]",text] expressionAttributedStringWithExpression:[self getMLExpression]];
        }
    }
    
    [_time setText:[[NSString stringWithFormat:@"%lld",chatModel.timestamp] specialTime:nil]];
    
    if (chatModel.unreadNumber == 0) {
        [_unread setHidden:YES];
        //隐藏自定义小红点
         self.liquidButton.hidden = YES;
    }else{
        [_unread setHidden:YES];
        self.liquidButton.hidden = NO;
        NSString *unreade = chatModel.unreadNumber > 99?@"99+":[NSString stringWithFormat:@"%hd",chatModel.unreadNumber];
        [_unread setTitle:unreade forState:UIControlStateNormal];
        self.liquidButton.bagdeNumber = chatModel.unreadNumber;
        WEAKSELF
        self.liquidButton.dragLiquidBlock = ^(HQliquidButton *liquid) {
            //设置消息会话已读
            [chatModel makeMessageReaded];
             weakSelf.liquidButton.hidden = YES;
        };
        if (chatModel.unreadNumber < 10){
            _unreadConstraint.constant = 38;
        }
        if (chatModel.unreadNumber >= 10){
            _unreadConstraint.constant = 45;

        }
        if (chatModel.unreadNumber > 99){
            _unreadConstraint.constant = 50;
        }
    }
    
    [self setRightButton:chatModel];
}

- (void)setRightButton:(LDChatModel*)chatModel{
    UIColor * colors[2] = {
        [UIColor colorWithRed:0 green:0x99/255.0 blue:0xcc/255.0 alpha:1.0],
        [UIColor colorWithRed:0.59 green:0.29 blue:0.08 alpha:1.0]};
    MGSwipeButton *button1 = [MGSwipeButton buttonWithTitle:@"删除" icon:nil backgroundColor:colors[0] padding:15 callback:^BOOL(MGSwipeTableCell * sender){
        NSLog(@"这里是按钮的回调方法!");
        return YES;
    }];
    MGSwipeButton *button2 = [MGSwipeButton buttonWithTitle:chatModel.isTopChat?@"取消置顶":@"置顶" icon:nil backgroundColor:colors[1] padding:15 callback:^BOOL(MGSwipeTableCell * sender){
        NSLog(@"这里是按钮的回调方法!");
        return YES;
    }];
    
    self.rightButtons = @[button1,button2];
    self.rightSwipeSettings.transition = MGSwipeStateSwippingRightToLeft;
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

-(void)setSysMessage:(LDSysMsgModel *)sysMessage
{
    [_isread setHidden:sysMessage.isRead == 1?YES:NO];
    [_sender setTextColor:RGBACOLOR(68, 131, 160, 1)];
    [_sender setText:@"系统消息"];
    [_time setText:[[NSString stringWithFormat:@"%lld",sysMessage.timestamp] specialTime:nil]];
    [_portrait setImage:[UIImage imageNamed:@"sys_message"]];
    if (sysMessage.msgType == 1) {
        if (sysMessage.subType == 1) {
            [_message setText:[NSString stringWithFormat:@"%@请求加您为好友",sysMessage.userName]];
        }
        if (sysMessage.subType == 2) {
            [_message setText:[NSString stringWithFormat:@"%@请求加您为好友",sysMessage.userName]];
        }
    }
    if (sysMessage.msgType == 2) {
        if (sysMessage.opType == 1) {
            [_message setText:[NSString stringWithFormat:@"%@同意了您的好友申请",sysMessage.userName]];
        }else{
            [_message setText:[NSString stringWithFormat:@"%@拒绝了您的好友申请",sysMessage.userName]];
        }
    }
    if (sysMessage.msgType == 3) {
        if (sysMessage.subType == 1) {
            [_message setText:[NSString stringWithFormat:@"%@邀请您加入群%@",sysMessage.userName,sysMessage.groupName]];
        }
        if (sysMessage.subType == 2) {
            [_message setText:[NSString stringWithFormat:@"%@申请加入群%@",sysMessage.userName,sysMessage.groupName]];
        }
    }
    if (sysMessage.msgType == 4) {
        if (sysMessage.opType == 1) {
            [_message setText:[NSString stringWithFormat:@"%@忽略了您的入群申请",sysMessage.userName]];
        }
        if (sysMessage.opType == 2) {
            [_message setText:[NSString stringWithFormat:@"%@同意了您的入群申请",sysMessage.userName]];
        }
        if (sysMessage.opType == 3 || sysMessage.opType == 4) {
            [_message setText:[NSString stringWithFormat:@"%@拒绝了您的入群申请",sysMessage.userName]];
        }
        if (sysMessage.opType == 5) {
            [_message setText:[NSString stringWithFormat:@"%@解散了群%@",sysMessage.userName,sysMessage.groupName]];
        }
        if (sysMessage.opType == 6) {
            [_message setText:[NSString stringWithFormat:@"您被%@移出群%@",sysMessage.userName,sysMessage.groupName]];
        }
        if (sysMessage.opType == 7) {
            [_message setText:[NSString stringWithFormat:@"%@退出了群%@",sysMessage.userName,sysMessage.groupName]];
        }
    }
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
      
        [self.liquidButton setBackgroundColor:[UIColor redColor]];
        }
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
       
        [self.liquidButton setBackgroundColor:[UIColor redColor]];
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
