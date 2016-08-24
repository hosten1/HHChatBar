//
//  LDGroupChatViewController.m
//  Linkdood
//
//  Created by xiong qing on 16/2/26.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDGroupChatViewController.h"
#import "LDGroupViewController.h"
#import "LDContactInfoViewController.h"
#import "LDGroupAtChooseViewController.h"
#import "LDGroupPrivateChatViewController.h"
#import "VIMInputExtendView.h"
#import "LDDatePickerController.h"

typedef enum : NSUInteger{
    CHOOSE_TYPE_TEXT,
    CHOOSE_TYPE_DEL,
    CHOOSE_TYPE_SHAKE,
}ChooseType;

@interface LDGroupChatViewController ()<LDGroupPrivateChatDelegate,VIMInputExtendViewDelegate,LDDatePickerDelegate>{
    BOOL shouldShowTextView;
    BOOL isChaImageLoaded;
    NSMutableArray *relatedUsers;
    NSMutableArray *privateChatUsers;
    Directive_type directiveType;
    ChooseType chooseType;
    LDMessageModel *delayMsg;
}

@end

@implementation LDGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputToolbar.contentView.textView.delegate = self;
    
    //@消息成员
    relatedUsers = [[NSMutableArray alloc]init];
    //群内私聊成员
    privateChatUsers = [[NSMutableArray alloc]init];
    
    UIButton *rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBar setFrame:(CGRect){0,0,25,25}];
    [rightBar addTarget:self action:@selector(showGroupInfo) forControlEvents:UIControlEventTouchUpInside];
    [rightBar setCornerRadius:12.5];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBar]];
    

    _group = [[LDGroupModel alloc] initWithID:self.chatModel.ID];
    [_group loadGroupInfo:group_info completion:^(LDGroupModel *groupInfo) {
        [[LDClient sharedInstance] avatar:_group.avatarUrl withDefault:@"GroupIcon" complete:^(UIImage *avatar) {
            [rightBar setBackgroundImage:avatar forState:UIControlStateNormal];
        }];
    }];

    
    if(![_group.chatImage isEqualToString:@""]){
        if (!isChaImageLoaded) {
            [[LDClient sharedInstance] avatar:_group.chatImage withDefault:nil complete:^(UIImage *avatar) {
                UIImageView *imgV = [[UIImageView alloc]initWithImage:avatar];
                [imgV setFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
                imgV.contentMode = UIViewContentModeScaleAspectFill;
                [[[self.view subviews]firstObject]setBackgroundColor:[UIColor clearColor]];
                [self.view insertSubview:imgV atIndex:0];
                self.view.clipsToBounds = YES;
                isChaImageLoaded = YES;
            }];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (shouldShowTextView) {
        [self.inputToolbar.contentView.textView becomeFirstResponder];
    }
}

- (void)showGroupInfo
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    LDGroupViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupViewController"];
    vc.groupModel = _group;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didPressMoreButton:(UIButton *)sender
{
    [super didPressMoreButton:sender];
    
    VIMInputExtendView *extend = [[VIMInputExtendView alloc] initWithExtends:@[VIMCard,VIMFile,VIMNotepad,VIMPrivacy]];
    [extend setDelegate:self];
    [self.inputToolbar showExtendView:extend];
}

-(void)didPressDirectiveButton:(UIButton *)sender
{
    self.isDirective = YES;
    
    VIMInputExtendView *extend = [[VIMInputExtendView alloc]initWithExtends:@[VIMReceipt,VIMTask,VIMDefer]];
    [self.inputToolbar showExtendView:extend];
    [extend setDelegate:self];
}

#pragma mark LDInputExtendViewDelegate
-(void)didPressExtend:(NSInteger)index
{
    [super didPressExtend:index];
    
    if (self.isDirective){
        if (index == 1 || index == 0){
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
            LDGroupPrivateChatViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupPrivateChatViewController"];
            
            vc.groupModel = self.group;
            vc.delegate = self;
            vc.isDirective = self.isDirective;
            [[LDClient sharedInstance].groupMembers clearSelectItems];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }else{
            
        }
    }else{
        if (index == 3) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
            LDGroupPrivateChatViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupPrivateChatViewController"];
            
            vc.groupModel = self.group;
            vc.delegate = self;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }
}



#pragma mark jsq
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
     LDMessageModel *message = (LDMessageModel*)[self.chatModel.chatMessageList itemAtIndexPath:indexPath];
    if (message.messageType == MESSAGE_TYPE_REVOKE || message.messageType == MESSAGE_TYPE_TIP) {
        
        return [super collectionView:collectionView layout:collectionViewLayout heightForCellBottomLabelAtIndexPath:indexPath];
    }
    return 20;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
    LDMessageModel *message = (LDMessageModel*)[self.chatModel.chatMessageList itemAtIndexPath:indexPath];
    if (message.messageType == MESSAGE_TYPE_REVOKE || message.messageType == MESSAGE_TYPE_TIP) {
        
        return [super collectionView:collectionView attributedTextForCellBottomLabelAtIndexPath:indexPath];
    }
    LDGroupMemberModel *member = (LDGroupMemberModel*)[groupMembers itemWithID:message.sendUserID];
    if (!member) {
        return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lld",message.sendUserID]];
    }
    return [[NSAttributedString alloc] initWithString:member.name];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LDMessageModel *message = (LDMessageModel*)[self.chatModel.chatMessageList itemAtIndexPath:indexPath];
    if (message.messageType == MESSAGE_TYPE_TIP || message.messageType == MESSAGE_TYPE_REVOKE) {
        return nil;
    }
    JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc] init];

    if (message.limitRange.count >0) {
        UIColor *buddleColor = [UIColor colorWithRed:245/255.0 green:191/255.0 blue:79/255.0 alpha:1];
        if (message.sendUserID == MYSELF.ID) {
             return [bubbleFactory outgoingMessagesBubbleImageWithColor:buddleColor];
        }
        
        return [bubbleFactory incomingMessagesBubbleImageWithColor:buddleColor];
    }
    
    if (message.sendUserID == [self.senderId longLongValue]) {
        return [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    }
    
    UIColor *buddleColor = [UIColor colorWithRed:200/255.0 green:220/255.0 blue:1 alpha:1];
    return [bubbleFactory incomingMessagesBubbleImageWithColor:buddleColor];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath{
    [super collectionView:collectionView didTapMessageBubbleAtIndexPath:indexPath];
    
    LDMessageModel *message = (LDMessageModel*)[self.chatModel.chatMessageList itemAtIndexPath:indexPath];
    if(message.limitRange.count>0){
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [effectView setFrame:(CGRect){0,0,220,120}];
        effectView.layer.cornerRadius = 14;
        effectView.layer.masksToBounds = YES;
        effectView.center = self.view.center;
        UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){0,88,220,33}];
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:245/255.0 green:191/255.0 blue:79/255.0 alpha:0.7];
        label.text = @"这是一条私聊消息";
        [effectView addSubview:label];
        effectView.alpha = 1;
        [self.view addSubview:effectView];
        
        BOOL hasSender = NO;
        for (NSNumber *obj in message.limitRange){
            if (obj.longLongValue == message.sendUserID){
                hasSender = YES;
            }
        }
        if(!hasSender)
            [message.limitRange addObject:[NSNumber numberWithLongLong:message.sendUserID]];
        
        for (NSNumber *obj in message.limitRange) {
            LDGroupMemberModel *member = (LDGroupMemberModel *)[[LDClient sharedInstance].groupMembers itemWithID:obj.longLongValue];
            NSInteger index = [message.limitRange indexOfObject:obj];
            CGFloat width = (effectView.width - message.limitRange.count*30)/(message.limitRange.count +1);
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:(CGRect){width*(index+1)+index*30,38,30,30}];
            imgV.layer.borderWidth = 1;
            imgV.layer.borderColor = [UIColor whiteColor].CGColor;
            imgV.layer.cornerRadius = imgV.frame.size.width/2;
            imgV.layer.masksToBounds = YES;
            [effectView addSubview:imgV];
            [[LDClient sharedInstance] avatar:member.avatar withDefault:@"MaleIcon" complete:^(UIImage *avatar) {
                [imgV setImage:avatar];
            }];
        }
        
        [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            effectView.alpha = 0;
        } completion:^(BOOL finished) {
            [effectView removeFromSuperview];
            [self selectSuccess:message.limitRange];
        }];
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
    LDMessageModel *message = (LDMessageModel*)[self.chatModel.chatMessageList itemAtIndexPath:indexPath];
    LDGroupMemberModel *member = (LDGroupMemberModel*)[groupMembers itemWithID:message.sendUserID];
    
    NSString *msgFrom = @"Unisex";
    if (!member) {
        return [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:msgFrom]
                                                          diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    }
    if (member.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (member.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    __block JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [[LDClient sharedInstance] avatar:member.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [cell.avatarImageView setImage:avatar];
    }];
    return [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:msgFrom]
                                                      diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [cell.textView setTextColor:[UIColor blackColor]];
    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
    LDMessageModel *message = (LDMessageModel*)[self.chatModel.chatMessageList itemAtIndexPath:indexPath];
    if (message.messageType == MESSAGE_TYPE_REVOKE || message.messageType == MESSAGE_TYPE_TIP) {
        cell.avatarImageView.hidden = YES;
        [cell.cellBottomLabel setTextAlignment:NSTextAlignmentCenter];
        cell.cellBottomLabel.font = [UIFont systemFontOfSize:14];
//        CGSize size = [cell.cellTopLabel contentSize];
//        cell.cellBottomLabel.bounds = CGRectMake(0, 0, size.width, cell.cellTopLabel.bounds.size.height);
//        cell.cellBottomLabel.backgroundColor = [UIColor colorWithWhite:0.863 alpha:1.000];
    }else{
        cell.avatarImageView.hidden = NO;
        cell.cellBottomLabel.font = [UIFont systemFontOfSize:12];
        if (message.sendUserID == MYSELF.ID) {
           [cell.cellBottomLabel setTextAlignment:NSTextAlignmentRight];
        }else{
            [cell.cellBottomLabel setTextAlignment:NSTextAlignmentLeft];
        }
        
    }
    LDGroupMemberModel *member = (LDGroupMemberModel*)[groupMembers itemWithID:message.sendUserID];
    NSString *msgFrom = @"Unisex";
    if (!member) {
        [cell.avatarImageView setImage:[UIImage imageNamed:msgFrom]];
    }
    if (member.sex == msg_owner_male) {
        msgFrom = @"MaleIcon";
    }
    if (member.sex == msg_owner_female) {
        msgFrom = @"FemaleIcon";
    }
    [[LDClient sharedInstance] avatar:member.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [cell.avatarImageView setImage:avatar];
    }];
    return cell;
}
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
//    LDContactInfoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDContactInfoViewController"];
//    
//    LDGroupMemberListModel *groupMembers = [[LDClient sharedInstance] groupMembers];
//    LDMessageModel *message = (LDMessageModel*)[self.chatModel.chatMessageList itemAtIndexPath:indexPath];
//    vc.contactModel = (LDContactModel *)[groupMembers itemWithID:message.sendUserID];
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didLongPressAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath{
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
//    LDGroupPrivateChatViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupPrivateChatViewController"];
//    
//    vc.groupModel = self.group;
//    vc.delegate = self;
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"@"]) { //@选择联系人

        if ([textView.text hasSuffix:@"."]) {
            textView.text = [textView.text substringToIndex:textView.text.length-1];
        }
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
            
        LDGroupAtChooseViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupAtChooseViewController"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.groupModel = _group;
        vc.memberChoosen = ^(int64_t memberID){
            LDGroupMemberModel *member = (LDGroupMemberModel *)[[LDClient sharedInstance].groupMembers itemWithID:memberID];
            
            NSMutableString *str = [[NSMutableString alloc]initWithString:self.inputToolbar.contentView.textView.text];
            
            if (member) {
                [str insertString:member.name atIndex:str.length];
                [str insertString:@" " atIndex:str.length];
            }else if (memberID == _group.ID){
                [str insertString:@"所有人 " atIndex:str.length];
            }
            self.inputToolbar.contentView.textView.text = str;
            
            __block NSInteger index = -1;
            
            [relatedUsers enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.longLongValue == member.ID) {
                    index = idx;
                    *stop = YES;
                }
            }];
            
            if(index <= 0){
                [relatedUsers addObject:[NSNumber numberWithLongLong:memberID]];
            }
            
            shouldShowTextView = YES;
        };
            
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        [textView setText:[textView.text stringByAppendingString:@"@"]];
        
        return NO;
    }
    
    if ([[textView.text substringWithRange:range] isEqualToString:@" "]) {
        NSRange delRange = [textView.text rangeOfString:@"@" options:NSBackwardsSearch];
        if (delRange.location != NSNotFound) {
            delRange.length = textView.text.length - delRange.location - 1;
            NSMutableString *str = [[NSMutableString alloc]initWithString:textView.text];
            [str deleteCharactersInRange:delRange];
            NSMutableString *tepStr = [[NSMutableString alloc]initWithString:[textView.text substringWithRange:delRange]];
            [tepStr stringByReplacingOccurrencesOfString:@"@" withString:@""];
            [tepStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if ([tepStr isEqualToString:@"所有人"]) {
                for (NSNumber *obj in relatedUsers) {
                    if (obj.longLongValue == _group.ID) {
                        [relatedUsers removeObject:obj];
                    }
                }
            }
            
            for (LDGroupMemberModel *member in [LDClient sharedInstance].groupMembers.allItems){
                if ([member.name isEqualToString:tepStr]) {
                    for (NSNumber *obj in relatedUsers) {
                        if (obj.longLongValue == member.ID) {
                            [relatedUsers removeObject:obj];
                        }
                    }
                }
            }
            
            textView.text = str;
        }
    }
    
    return YES;
}

- (NSMutableArray *)getRelatedUsersFromMessage:(NSString *)str{
    NSMutableArray *users = [[NSMutableArray alloc]init];
    [relatedUsers enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LDGroupMemberModel *member = (LDGroupMemberModel*)[[LDClient sharedInstance].groupMembers itemWithID:obj.longLongValue];
        if (member) {
            if ([str containsString:[NSString stringWithFormat:@"@%@",member.name]]) {
                [users addObject:obj];
            }
        }else if ([str containsString:[NSString stringWithFormat:@"@所有人"]]){
             [users addObject:[NSNumber numberWithLongLong:self.group.ID]];
        }

    }];
    [relatedUsers removeAllObjects];
    return users;
}

- (void)selectSuccess:(NSArray *)members{
    if (self.isTask || self.isReceipt) {
        relatedUsers = [NSMutableArray arrayWithArray:members];
        NSMutableString *str = [[NSMutableString alloc]init];
        for (NSNumber *ID in relatedUsers){
            LDGroupMemberModel *member = (LDGroupMemberModel*)[[LDClient sharedInstance].groupMembers itemWithID:ID.longLongValue];
            [str appendString:[NSString stringWithFormat:@"@%@ ",member.name]];
        }
        self.inputToolbar.contentView.textView.text = str;
    }else {
    privateChatUsers = [NSMutableArray arrayWithArray:members];
    
    if(members.count){
        self.inputToolbar.contentView.rightBarButtonItem.tintColor = [UIColor orangeColor];
    }else{
        self.inputToolbar.contentView.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
    }
    
    UIImage *image = self.inputToolbar.contentView.rightBarButtonItem.imageView.image;
        [self.inputToolbar.contentView.rightBarButtonItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
}

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    //发送文本消息后清空输入框
    [self.inputToolbar.contentView.textView setText:@""];
    [self.inputToolbar toggleSendButtonEnabled];
    
    //发送文本消息
    LDMessageModel *message = [[LDTextMessageModel alloc] initWithText:text];
    if(self.isFire){
        [message setActiveType:1];
    }
    if (self.isDelayMsg){
        LDDatePickerController *datePicker = [[LDDatePickerController alloc] initWithNibName:@"LDDatePickerController" bundle:nil];
        datePicker.delegate = self;
        datePicker.providesPresentationContextTransitionStyle = YES;
        datePicker.definesPresentationContext = YES;
        datePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        delayMsg = message;
        [self presentViewController:datePicker animated:YES completion:nil];
        return;
    }
    if (self.isTask){
        message = [[LDTaskMessageModel alloc]initWithTaskContent:text];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        
        [message setMsgProperties:[@{@"timeTask":[formatter stringFromDate:date], @"isFinish":@0,@"isTask":@1} JSONString]];
    }
    if (self.isReceipt){
        [message setMsgProperties:[@{@"receipt":@"1"} JSONString]];
    }
    message.relatedUsers = [self getRelatedUsersFromMessage:text];
    message.limitRange = privateChatUsers;
    [self.chatModel sendMessage:message onStatus:^(msg_status status) {
        //消息发送状态回调代码
        if (status == msg_normal){
            self.isFire = NO;
            self.isDelayMsg = NO;
            self.isTask = NO;
            self.isReceipt = NO;
        }
    }];
    
    [[LDClient sharedInstance].groupMembers clearSelectItems];
    
    //加入到会话窗口消息列表
    [self receivedMessage:message];
}


- (void)receivedMessage:(LDMessageModel*)message
{
    if ([message isKindOfClass:[LDSysMsgModel class]]) {
        return;
    }
    //接收到的消息设置已读
    if (message.sendUserID != MYSELF.ID) {
        [self.chatModel makeMessageReaded];
    }
    
    [self.chatModel receivedMessage:message];
    
    //刷新会话窗口
    self.scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:[self.chatModel.chatMessageList numberOfSections] - 1];
    [self.collectionView reloadData];
    [self scrollToBottomAnimated:YES];
}

#pragma mark LDDatePickerDelegate Delegate
-(void)didPickDate:(NSDate *)date{
    NSNumber *number = [NSNumber numberWithLongLong:[date timeIntervalSince1970] * 1000];
    [delayMsg setMsgProperties:[@{@"isDelayMsg":@1,@"delaySendTime":number} JSONString]];
    [self.chatModel sendMessage:delayMsg onStatus:^(msg_status status) {
        
    }];
}

@end
