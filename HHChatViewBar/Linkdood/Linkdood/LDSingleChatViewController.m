//
//  LDSingleChatViewController.m
//  Linkdood
//
//  Created by xiong qing on 16/2/26.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDSingleChatViewController.h"
#import "LDContactInfoViewController.h"
#import "XMNPhotoPicker.h"
#import "VIMInputExtendView.h"

@interface LDSingleChatViewController ()<VIMInputExtendViewDelegate>{
    BOOL isChaImageLoaded;
}

@end

@implementation LDSingleChatViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBar setFrame:(CGRect){0,0,25,25}];
    [rightBar addTarget:self action:@selector(showUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [rightBar setCornerRadius:12.5];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBar]];
    
    __block NSString *msgFrom = @"Unisex";
    LDUserModel *user = [[LDClient sharedInstance] localContact:self.chatModel.ID];
    if(!user){
        [user loadUserInfo:^(LDUserModel *userInfo) {
            self.stranger = user;
            if (user.sex == msg_owner_male) {
                msgFrom = @"MaleIcon";
            }
            if (user.sex == msg_owner_female) {
                msgFrom = @"FemaleIcon";
            }
            [[LDClient sharedInstance] avatar:msgFrom withDefault:user.avatar complete:^(UIImage *avatar) {
                [rightBar setImage:avatar forState:UIControlStateNormal];
            }];
        }];
    }else{
        self.buddy = (LDContactModel*)user;
        if (user.sex == msg_owner_male) {
            msgFrom = @"MaleIcon";
        }
        if (user.sex == msg_owner_female) {
            msgFrom = @"FemaleIcon";
        }
        [[LDClient sharedInstance] avatar:user.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
            [rightBar setImage:avatar forState:UIControlStateNormal];
        }];
    }
    
    if([user isKindOfClass:[LDContactModel class]]){
        LDContactModel *contact = (LDContactModel *)user;
        [contact loadUserInfo:^(LDUserModel *userInfo) {
            if (![contact.chatImage isEqualToString:@""] && !isChaImageLoaded) {
                [[LDClient sharedInstance] avatar:contact.chatImage withDefault:nil complete:^(UIImage *avatar) {
                    
                    UIImageView *imgV = [[UIImageView alloc]initWithImage:avatar];
                    [imgV setFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
                    imgV.contentMode = UIViewContentModeScaleAspectFill;
                    [[[self.view subviews]firstObject]setBackgroundColor:[UIColor clearColor]];
                    [self.view insertSubview:imgV atIndex:0];
                    self.view.clipsToBounds = YES;
                    isChaImageLoaded = YES;
                }];
            }
        }];
    }
}

- (void)showUserInfo
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    LDContactInfoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDContactInfoViewController"];
    [vc setContactModel:_buddy];
    [vc setPushFromChat:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didPressMoreButton:(UIButton *)sender
{
    [super didPressMoreButton:sender];
    
    VIMInputExtendView *extend = [[VIMInputExtendView alloc] initWithExtends:@[VIMCard,VIMFile,VIMNotepad]];
    [extend setDelegate:self];
    [self.inputToolbar showExtendView:extend];
}

-(void)didPressDirectiveButton:(UIButton *)sender
{
    self.isDirective = YES;
    
    VIMInputExtendView *extend = [[VIMInputExtendView alloc]initWithExtends:@[VIMReceipt,VIMTask,VIMDefer,VIMClear,VIMShake]];
    [self.inputToolbar showExtendView:extend];
    [extend setDelegate:self];
}

#pragma mark LDInputExtendViewDelegate
-(void)didPressExtend:(NSInteger)index
{
    [super didPressExtend:index];
    
    if (self.isDirective) {
        if (index == 0){
            //阅后回执
        }
        if (index == 1) {
            //任务
        }
        if (index == 2) {
            //延迟消息
        }
        if (index == 3) {
            //橡皮擦
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"让对方删除自己与对方的会话信息" preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction: [UIAlertAction actionWithTitle: @"删除今日" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                LDDirectiveMessageModel *message = [[LDDirectiveMessageModel alloc] initWithDirectiveType:Directive_type_delMsgToday];
                [self.chatModel sendMessage:message onStatus:^(msg_status status) {
                    switch (status) {
                        case msg_sending:
                            NSLog(@"发送中。。。。");
                            break;
                        case msg_normal:
                            NSLog(@"发送成功");
                            break;
                        case msg_failure:
                            NSLog(@"发送失败");
                            break;
                        default:
                            break;
                    }
                    [self receivedMessage:message];
                }];
            }]];
            [alert addAction: [UIAlertAction actionWithTitle: @"删除全部" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                LDDirectiveMessageModel *message = [[LDDirectiveMessageModel alloc] initWithDirectiveType:Directive_type_delMsgAll];
                [self.chatModel sendMessage:message onStatus:^(msg_status status) {
                    switch (status) {
                        case msg_sending:
                            NSLog(@"发送中。。。。");
                            break;
                        case msg_normal:
                            NSLog(@"发送成功");
                            break;
                        case msg_failure:
                            NSLog(@"发送失败");
                            break;
                        default:
                            break;
                    }
                    [self receivedMessage:message];
                }];
            }]];
            [alert addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        if (index == 4){
            //抖一抖
            LDDirectiveMessageModel *message = [[LDDirectiveMessageModel alloc] initWithDirectiveType:Directive_type_shake];
            message.msgProperties = [@{@"receipt":@"1"} JSONString];
            [self.chatModel sendMessage:message onStatus:^(msg_status status) {
                switch (status) {
                    case msg_sending:
                        NSLog(@"发送中。。。。");
                        break;
                    case msg_normal:
                        NSLog(@"发送成功");
                        break;
                    case msg_failure:
                        NSLog(@"发送失败");
                        break;
                    default:
                        break;
                }
                //加入到会话窗口消息列表
                [self receivedMessage:message];
            }];
        }
    }
}

#pragma mark - 指令消息

-(void)handleDirectiveHistoryMessage{
    LDChatModel *chatModel = (LDChatModel*)[[LDClient sharedInstance].chatListModel itemWithID:self.chatModel.ID];
    NSRange range;
    if(chatModel.unreadNumber >= self.chatModel.chatMessageList.allItems.count){
        range = (NSRange){0,self.chatModel.chatMessageList.allItems.count};
    }else{
        range = (NSRange){self.chatModel.chatMessageList.allItems.count - chatModel.unreadNumber,chatModel.unreadNumber};
    }
    NSArray *unreadArray = [[self.chatModel.chatMessageList allItems] subarrayWithRange:range];
    for (LDMessageModel *msg in unreadArray){
        [self handleDirectiveMessage:msg];
    }
}

-(void)handleDirectiveMessage:(LDMessageModel*)message{
    if ([message isKindOfClass:[LDDirectiveMessageModel class]]) {
        if ([message.message containsString:DirectivedelDelToday]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"指令消息" message:@"对方想删除与你今日的聊天记录，是否同意删除？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSDate *endDate = [NSDate date];
                NSTimeZone *zone = [NSTimeZone localTimeZone];
                NSInteger endInterval = [zone secondsFromGMTForDate: endDate];
                NSDate *localeEndDate = [endDate  dateByAddingTimeInterval: endInterval];
                int64_t endTime = [localeEndDate timeIntervalSince1970] * 1000;
                
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:endDate];
                NSDate *startDate = [calendar dateFromComponents:components];
                NSInteger startInterval = [zone secondsFromGMTForDate: startDate];
                NSDate *startLocaleDate = [startDate  dateByAddingTimeInterval: startInterval];
                int64_t startTime = [startLocaleDate timeIntervalSince1970] * 1000;
                [self.chatModel.chatMessageList removeMessageFromTime:startTime toTime:endTime completion:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.chatModel.chatMessageList assembleData];
                        [self.collectionView reloadData];
                        [self sendTipMsgWithType:5 operType:1];
                    });
                }];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self sendTipMsgWithType:5 operType:2];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([message.message containsString:DirectivedelDelAll]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"指令消息" message:@"对方想删除与你的全部聊天记录，是否同意删除？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.chatModel.chatMessageList removeMessageFromTime:0 toTime:0 completion:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.chatModel.chatMessageList assembleData];
                        [self.collectionView reloadData];
                        [self sendTipMsgWithType:5 operType:1];
                    });
                }];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self sendTipMsgWithType:5 operType:2];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    NSDictionary *dict = [message.msgProperties objectFromJSONString];
    if ([dict[@"receipt"] isEqualToString:@"1"]) {
        [self sendTipMsgWithType:4 operType:0];
    }
}

-(void)sendTipMsgWithType:(int)tType operType:(int)oType{
    LDMessageModel *tipMessage = [[LDMessageModel alloc]init];
    tipMessage.messageType = MESSAGE_TYPE_TIP;
    
    tipMessage.message = [@{@"msgBodyType":[NSNumber numberWithInt:tType],@"body":@""} JSONString];
    LDContactModel *contact = (LDContactModel *)[[LDClient sharedInstance].contactListModel itemWithID:self.chatModel.ID];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:oType],@"operType",MYSELF.name,@"operUser",contact.name,@"usersInfo",nil];
    tipMessage.msgProperties = [dic JSONString];
    [self.chatModel sendMessage:tipMessage onStatus:^(msg_status status) {
        if (status == msg_normal) {
            [self receivedMessage:tipMessage];
        }
    }];
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
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LDMessageModel *message = (LDMessageModel*)[self.chatModel.chatMessageList itemAtIndexPath:indexPath];
    NSString *msgFrom = @"Unisex";
    NSString *avatar;
    LDUserModel *mySelf = MYSELF;
    if (message.sendUserID == mySelf.ID) {
        if (mySelf.sex == msg_owner_male) {
            msgFrom = @"MaleIcon";
        }
        if (mySelf.sex == msg_owner_female) {
            msgFrom = @"FemaleIcon";
        }
        avatar = mySelf.avatar;
    }else{
        avatar = _buddy.avatar;
        if (_buddy.sex == msg_owner_male) {
            msgFrom = @"MaleIcon";
        }
        if (_buddy.sex == msg_owner_female) {
            msgFrom = @"FemaleIcon";
        }
    }
    __block JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [[LDClient sharedInstance] avatar:avatar withDefault:msgFrom complete:^(UIImage *avatar) {
        [cell.avatarImageView setImage:avatar];
    }];
    return [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:msgFrom]
                                                      diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [cell.textView setTextColor:[UIColor blackColor]];
    LDMessageModel *message = (LDMessageModel*)[self.chatModel.chatMessageList itemAtIndexPath:indexPath];
    if (message.messageType == MESSAGE_TYPE_REVOKE || message.messageType == MESSAGE_TYPE_TIP) {
        cell.avatarImageView.hidden = YES;
        [cell.cellBottomLabel setTextAlignment:NSTextAlignmentCenter];
        cell.cellBottomLabel.font = [UIFont systemFontOfSize:14];
    }else{
        cell.avatarImageView.hidden = NO;
        cell.cellBottomLabel.font = [UIFont systemFontOfSize:12];
        if (message.sendUserID == MYSELF.ID) {
            [cell.cellBottomLabel setTextAlignment:NSTextAlignmentRight];
        }else{
            [cell.cellBottomLabel setTextAlignment:NSTextAlignmentLeft];
        }
        
        NSString *msgFrom = @"Unisex";
        NSString *avatar;
        LDUserModel *mySelf = MYSELF;
        if (message.sendUserID == mySelf.ID) {
            if (mySelf.sex == msg_owner_male) {
                msgFrom = @"MaleIcon";
            }
            if (mySelf.sex == msg_owner_female) {
                msgFrom = @"FemaleIcon";
            }
            avatar = mySelf.avatar;
        }else{
            avatar = _buddy.avatar;
            if (_buddy.sex == msg_owner_male) {
                msgFrom = @"MaleIcon";
            }
            if (_buddy.sex == msg_owner_female) {
                msgFrom = @"FemaleIcon";
            }
        }
        [[LDClient sharedInstance] avatar:avatar withDefault:msgFrom complete:^(UIImage *avatar) {
            [cell.avatarImageView setImage:avatar];
        }];
    }
    return cell;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didLongPressAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
