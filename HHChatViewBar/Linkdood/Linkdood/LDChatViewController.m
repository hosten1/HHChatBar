//
//  LDChatViewController.m
//  Linkdood
//
//  Created by xiong qing on 16/2/24.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDChatViewController.h"
#import "LDImageMessageView.h"
#import "LDAudioMessageView.h"
#import "LDCardMessageView.h"
#import "LDFileMessageView.h"
#import "LDComboMessageView.h"
#import "XMNPhotoPickerKit.h"
#import "PhotoBroswerVC.h"
#import "LDChooseMemberController.h"
#import "LDContactInfoViewController.h"
#import "LDGroupViewController.h"
#import "LDGroupListViewController.h"
#import "LDLocationMessageView.h"
#import "HHLocationServiceView.h"
#import "LDLocationDetailsViewController.h"
#import "SimpleEmojiPanel.h"
#import "LDExpressionMessageView.h"
#import "PanelMapView.h"
#import "AudioRecoderPanel.h"
#import "LDTextMessageView.h"
#import "UIImage+mapView.h"
#import "HMScannerController.h"
#import "LCQRCodeUtil.h"
#import "LDFileChooseController.h"
#import "LDMoreExtendBar.h"
#import "LDComboMessageViewController.h"
#import "LDEmptyMessageView.h"
#import "LDNoteListTableViewController.h"
#import "VIMInputExtendView.h"
#import "LDDatePickerController.h"

@interface LDChatViewController ()<SimpleEmojiPanelDelegate,PanelMapViewDelegate,AudioRecoderPanelDelegate,LDFileChooseControllerDelegate,LDMoreExtendBarDelegate,LDImageMessageViewDelegate,LDTextMessageViewDelegate,VIMInputExtendViewDelegate,LDDatePickerDelegate,PhotoBroswerVCDelegate>{
    bool isDragging;
    NSArray<XMNAssetModel *> *assetArray;
    NSInteger messageCount;
    NSMutableDictionary *eraserDic;
    LDMessageModel *delayMsg;
}
@property (nonatomic, strong)  SimpleEmojiPanel *simpleEmoji;
@property (nonatomic, strong)  LDMoreExtendBar *moreExtendBar;
@property (nonatomic, strong)  LDMessageModel *longPressMessageModel;
@property (nonatomic, strong)  JSQMessagesCollectionViewCell *longPressCell;
@end

@implementation LDChatViewController

- (instancetype)initWithChat:(LDChatModel*)chat;
{
    return [self initWithTarget:chat.ID];
}

- (instancetype)initWithTarget:(int64_t)target
{
    self = [super init];
    if (self) {
        self.chatModel = [[LDChatModel alloc] initWithID:target];
        messageCount = self.chatModel.chatMessageList.numberOfItems;
        self.senderId = [NSString stringWithFormat:@"%lld",MYSELF.ID];
        [self setHidesBottomBarWhenPushed:YES];
        [self loadHistoryMessage];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:self.senderDisplayName];
    
    _moreExtendBar = [[[UINib nibWithNibName:@"LDMoreExtendBar" bundle:nil]instantiateWithOwner:self options:nil]objectAtIndex:0];
    [_moreExtendBar setFrame:(CGRect){0,SCREEN_HEIGHT,SCREEN_WIDTH,80}];
    _moreExtendBar.delegate = self;
    [self.view addSubview:_moreExtendBar];
    [_moreExtendBar setHidden:YES];
    
    eraserDic = [[NSMutableDictionary alloc]init];
    self.inputToolbar.contentView.leftBarButtonWidth = 0.0f;
}

- (void)showMoreBar{
    [_moreExtendBar setHidden:NO];
    [UIView animateWithDuration:0.2 animations:^{
        [_moreExtendBar setFrame:(CGRect){0,SCREEN_HEIGHT - 80,SCREEN_WIDTH,80}];
        [self.inputToolbar setHidden:YES];
        self.inputToolbar.preferredDefaultHeight = 80;
    }];
}

-(void)hideMoreBar{
    
    [UIView animateWithDuration:0.2 animations:^{
        [_moreExtendBar setFrame:(CGRect){0,SCREEN_HEIGHT,SCREEN_WIDTH,80}];
        self.inputToolbar.preferredDefaultHeight = 0;
    }completion:^(BOOL finished) {
        [self.inputToolbar setHidden:NO];
        [UIView animateWithDuration:0.2 animations:^{
            self.inputToolbar.preferredDefaultHeight = 80;
            [_moreExtendBar setHidden:YES];
        }];
        self.showMessageSelector = NO;
        [self.chatModel.chatMessageList.selectedItems removeAllObjects];
        [self.collectionView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    LDChatModel *chatModel = (LDChatModel*)[[LDClient sharedInstance].chatListModel itemWithID:self.chatModel.ID];
    //设置已读
    if (chatModel && chatModel.unreadNumber > 0) {
        [self handleDirectiveHistoryMessage];
        [chatModel makeMessageReaded];
    }
    
    [[LDNotify sharedInstance] messageMoniter:^(LDMessageModel *message) {
        [self receivedMessage:message];
        [self handleDirectiveMessage:message];
    } forTarget:_chatModel.ID];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //表情面板
    _simpleEmoji = [[[UINib nibWithNibName: @"SimpleEmojiPanel" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    _simpleEmoji.delegate = self;
}

- (void)loadHistoryMessage
{
    if (_chatModel.chatMessageList.numberOfItems == 0) {
        [_chatModel setLastMsgid:0];
    }else{
        LDMessageModel *message = (LDMessageModel*)[_chatModel.chatMessageList itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [_chatModel setLastMsgid:message.ID - 1];
    }
    [_chatModel historyMessages:^(NSError *error, LDMessageListModel *messageList) {
        if (messageList.numberOfItems != messageCount) {
            [_chatModel.chatMessageList assembleData];
            
            if (_chatModel.chatMessageList.numberOfItems <= 10) {
                _scrollIndexPath = [self indexPathOfSection:[_chatModel.chatMessageList numberOfSections] - 1];
            }else{
                _scrollIndexPath = [self indexPathOfSection:_chatModel.chatMessageList.numberOfSections - _scrollIndexPath.section - 1];
            }
            if (_scrollIndexPath) {
                [self.collectionView reloadData];
                [self scrollToBottomAnimated:NO];
            }
            messageCount = messageList.numberOfItems;
        }
    }];
}

- (NSIndexPath*)indexPathOfSection:(NSInteger)section
{
    if (section < 0) {
        return nil;
    }
    if ([_chatModel.chatMessageList numberOfRowsInSection:section] == 0) {
        return [self indexPathOfSection:section - 1];
    }
    return [NSIndexPath indexPathForRow:0 inSection:section];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger sections = [self.collectionView numberOfSections];
    if (sections == 0) {
        return;
    }
    
    NSInteger items = [self.collectionView numberOfItemsInSection:sections - 1];
    if (items == 0) {
        NSInteger section = _scrollIndexPath.section - 1;
        NSInteger row = [_chatModel.chatMessageList numberOfRowsInSection:section];
        _scrollIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        return;
    }
    
    CGFloat collectionViewContentHeight = [self.collectionView.collectionViewLayout collectionViewContentSize].height;
    BOOL isContentTooSmall = (collectionViewContentHeight < CGRectGetHeight(self.collectionView.bounds));
    
    if (isContentTooSmall) {
        //  workaround for the first few messages not scrolling
        //  when the collection view content size is too small, `scrollToItemAtIndexPath:` doesn't work properly
        //  this seems to be a UIKit bug, see #256 on GitHub
        [self.collectionView scrollRectToVisible:CGRectMake(0.0, collectionViewContentHeight - 1.0f, 1.0f, 1.0f)
                                        animated:animated];
        return;
    }
    
    //  workaround for really long messages not scrolling
    //  if last message is too long, use scroll position bottom for better appearance, else use top
    //  possibly a UIKit bug, see #480 on GitHub
    //    NSUInteger finalRow = MAX(0, [self.collectionView numberOfItemsInSection:0] - 1);
    //    NSIndexPath *finalIndexPath = [NSIndexPath indexPathForItem:finalRow inSection:0];
    CGSize finalCellSize = [self.collectionView.collectionViewLayout sizeForItemAtIndexPath:_scrollIndexPath];
    
    CGFloat maxHeightForVisibleMessage = CGRectGetHeight(self.collectionView.bounds) - self.collectionView.contentInset.top - CGRectGetHeight(self.inputToolbar.bounds);
    
    UICollectionViewScrollPosition scrollPosition = (finalCellSize.height > maxHeightForVisibleMessage) ? UICollectionViewScrollPositionBottom : UICollectionViewScrollPositionTop;
    
    [self.collectionView scrollToItemAtIndexPath:_scrollIndexPath
                                atScrollPosition:scrollPosition
                                        animated:animated];
}

- (void)receivedMessage:(LDMessageModel*)message
{
    if ([message isKindOfClass:[LDSysMsgModel class]]) {
        return;
    }
    //接收到的消息设置已读
    if (message.sendUserID != MYSELF.ID) {
        [_chatModel makeMessageReaded];
    }
    
    [_chatModel receivedMessage:message];
    //刷新会话窗口
    self.scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:[_chatModel.chatMessageList numberOfSections] - 1];
    [self.collectionView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)showEraserAction:(LDMessageModel*)message{
    
}

#pragma mark 解析各种数据
-(JSQMessage*)jsqMessageFrom:(LDMessageModel*)message{
    
    switch (message.messageType) {
        case MESSAGE_TYPE_TEXT: {
            //            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
            //                                      senderDisplayName:@""
            //                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
            //                                                text:message.message];
            LDTextMessageView *TextView = [[LDTextMessageView alloc]initWithMessage:message];
            TextView.delegate =self;
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                  media:TextView];
        }
        case MESSAGE_TYPE_LOCATION:{
            LDLocationMessageView *locationView = [[LDLocationMessageView alloc]initWithMessage:(LDLocationMessageModel*)message];
            
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                  media:locationView];
        }
        case MESSAGE_TYPE_AUDIO: {
            LDAudioMessageView *audioView = [[LDAudioMessageView alloc] initWithMessage:message];
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                  media:audioView];
        }
        case MESSAGE_TYPE_IMAGE:
        {
            LDImageMessageView *imageView = [[LDImageMessageView alloc] initWithMessage:message];
            imageView.delegate = self;
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                  media:imageView];
            
        }//个人名片
        case MESSAGE_TYPE_CARD:
        {
            LDCardMessageView *cardView = [[LDCardMessageView alloc]initWithMessage:message];
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                  media:cardView];
        }
            
        case MESSAGE_TYPE_TIP:
        {
            LDEmptyMessageView *imageView = [[LDEmptyMessageView alloc] initWithMessage:message];
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                  media:imageView];
        }
        case MESSAGE_TYPE_FILE:
        {
            LDFileMessageView *fileView = [[LDFileMessageView alloc]initWithMessage:message];
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                  media:fileView];
        }
            
        case MESSAGE_TYPE_REVOKE:
        {
            LDEmptyMessageView *imageView = [[LDEmptyMessageView alloc] initWithMessage:message];
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                  media:imageView];
        }
            
            
        case MESSAGE_TYPE_ASSEMBLE:
        {
            LDComboMessageView *comboView = [[LDComboMessageView alloc] initWithMessage:message];
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                  media:comboView];
        }
        case MESSAGE_TYPE_EXPRESSTIONS:
        {
            LDExpressionMessageView *imageView = [[LDExpressionMessageView alloc] initWithMessage:message];
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                  media:imageView];
        }
            
        default:
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.sendUserID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                   text:@"暂未支持的消息类型"];
    }
    return nil;
}

- (void)removeMessage:(LDImageMessageModel *)message{
    [self.chatModel.chatMessageList removeMessages:@[message] completion:^(NSError *error) {
        if (!error) {
            [self.chatModel.chatMessageList assembleData];
            [self.collectionView reloadData];
        }
    }];
    
}
#pragma mark --textMessageView delegate
-(void)removeTextMessage:(LDTextMessageModel *)message{
    [self.chatModel.chatMessageList removeMessages:@[message] completion:^(NSError *error) {
        if (!error) {
            [self.chatModel.chatMessageList assembleData];
            [self.collectionView reloadData];
        }
    }];
}

-(void)textMessageViewDidResponserInstructMessage:(LDTextMessageModel *)testMessage{
    if (testMessage.sendUserID != MYSELF.ID) {
        LDMessageModel *tipMessage = [[LDMessageModel alloc]init];
        tipMessage.messageType = MESSAGE_TYPE_TIP;
        
        tipMessage.message = [@{@"msgBodyType":@6,@"body":@""} JSONString];
        LDContactModel *contact = (LDContactModel *)[[LDClient sharedInstance].contactListModel itemWithID:_chatModel.ID];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"operType",MYSELF.name,@"operUser",contact.name,@"usersInfo",nil];
        tipMessage.msgProperties = [dic JSONString];
        [_chatModel sendMessage:tipMessage onStatus:^(msg_status status) {
            if (status == msg_normal) {
                [self receivedMessage:tipMessage];
            }
        }];
        
    }
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSString *keyString = [NSString stringWithFormat:@"key_%lld",testMessage.ID];
    [userdef setBool:YES forKey:keyString];
    [userdef synchronize];
    
}

#pragma mark - 橡皮擦消息

-(void)handleDirectiveHistoryMessage{
}




-(void)handleDirectiveMessage:(LDMessageModel*)message{
}



#pragma mark - JSQMessages CollectionView DataSource
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LDMessageModel *message = (LDMessageModel*)[_chatModel.chatMessageList itemAtIndexPath:indexPath];
    if (message.messageType == MESSAGE_TYPE_REVOKE ) {
        NSDictionary *messageDic = [message.msgProperties objectFromJSONString];
        int64_t deleteMsgID = [messageDic[@"messageID"] longLongValue];
        LDMessageModel *deleMsg = (LDMessageModel*)[self.chatModel.chatMessageList itemWithID:deleteMsgID];
        if (deleMsg && message.sendUserID != MYSELF.ID) {
            [self.chatModel.chatMessageList removeMessages:@[deleMsg] completion:^(NSError *error) {
                if (!error) {
                    [self.chatModel.chatMessageList assembleData];
                    [self.collectionView reloadData];
                }
            }];
        }
        return [self jsqMessageFrom:message];
    }else{
        if (!message) {
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",message.receTargetID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",message.timestamp] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                   text:message.message];
        }
        
        return [self jsqMessageFrom:message];
    }
    
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LDMessageModel *message = (LDMessageModel*)[_chatModel.chatMessageList itemAtIndexPath:indexPath];
    if (message.messageType == MESSAGE_TYPE_TIP || message.messageType == MESSAGE_TYPE_REVOKE) {
        return nil;
    }
    JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc] init];
    if (message.sendUserID == [self.senderId longLongValue]) {
        return [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    }
    
    UIColor *buddleColor = [UIColor colorWithRed:200/255.0 green:220/255.0 blue:1 alpha:1];
    return [bubbleFactory incomingMessagesBubbleImageWithColor:buddleColor];
}

- (UIImage *)collectionView:(JSQMessagesCollectionView *)collectionView selectorImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    LDMessageModel *message = (LDMessageModel*)[_chatModel.chatMessageList itemAtIndexPath:indexPath];
    
    if ([[self.chatModel.chatMessageList selectedItems]containsLDItem:message]) {
        return [UIImage imageNamed:@"msg_select"];
    }
    return [UIImage imageNamed:@"msg_deselect"];
}

#pragma mark - JSQMessages collection view flow layout delegate
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 20;
    }
    return 0.0f;
}
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath{
    LDMessageModel *message = (LDMessageModel*)[_chatModel.chatMessageList itemAtIndexPath:indexPath];
    if (message.messageType == MESSAGE_TYPE_REVOKE) {//撤回消息提示
        if (message.sendUserID == MYSELF.ID) {
            return [[NSAttributedString alloc] initWithString:@"你撤回了一条消息"];
        }
        return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@撤回了一条消息",message.message]];
    }else if(message.messageType == MESSAGE_TYPE_TIP){
        NSString *msgString = [self parseJsonWithMessage:message];
        return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",msgString]];
    }
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return [[NSAttributedString alloc] initWithString:[_chatModel.chatMessageList sectionIndexTitle:indexPath.section]];
}

#pragma mark --解析弱提示消息
-(NSString*)parseJsonWithMessage:(LDMessageModel*)message{
    NSString *msgString = @"";
    
    if (![message.message isEmpty]) {
        NSDictionary *jsonStringMsgDic = [message.message objectFromJSONString];
        int msgBodyType = [jsonStringMsgDic[@"msgBodyType"] intValue];
        switch (msgBodyType) {
            case 3:{//群若提示消息
                NSDictionary *messageDic = [message.msgProperties objectFromJSONString];
                msgString = [self stringWithGroupOption:messageDic];
                return msgString;
            }
            case 4:{//阅后回执
                NSDictionary *messageDic = [message.msgProperties objectFromJSONString];
                NSString *operUser = messageDic[@"operUser"];
                NSString *userInfo = messageDic[@"usersInfo"];
                if (message.sendUserID != MYSELF.ID) {
                    return [NSString stringWithFormat:@"%@已经看过我的消息",operUser];
                }else{
                    return [NSString stringWithFormat:@"自动回复%@的阅后回执消息",userInfo];
                }            }
            case 5:{//橡皮擦
                NSDictionary *messageDic = [message.msgProperties objectFromJSONString];
                int operType = [messageDic[@"operType"] intValue];
                NSString *operUser = messageDic[@"operUser"];
                NSString *userInfo = messageDic[@"usersInfo"];
                if (operType == 1) {
                    if (message.sendUserID != MYSELF.ID) {
                        return [NSString stringWithFormat:@"%@同意了您的删除请求",operUser];
                    }
                    return [NSString stringWithFormat:@"您同意了%@的删除请求",userInfo];
                }
                if (operType == 2) {
                    if (message.sendUserID != MYSELF.ID) {
                        return [NSString stringWithFormat:@"%@拒绝了您的删除请求",operUser];
                    }
                    return [NSString stringWithFormat:@"您拒绝了%@的删除请求",userInfo];
                    
                }
                break;
            }
            case 6:{//抖一抖
                NSDictionary *messageDic = [message.msgProperties objectFromJSONString];
                NSString *operUser = messageDic[@"operUser"];
                NSString *userInfo = messageDic[@"usersInfo"];
                if (message.sendUserID != MYSELF.ID) {
                    return [NSString stringWithFormat:@"%@响应了我的抖一抖",operUser];
                }else{
                    return [NSString stringWithFormat:@"我响应了%@的抖一抖",userInfo];
                }
                
            }
            case 7:{//红包
                NSDictionary *messageDic = [message.msgProperties objectFromJSONString];
                NSString *operUser = messageDic[@"operUser"];
                NSString *userInfo = messageDic[@"usersInfo"];
                //                int operType = [messageDic[@"operType"] intValue];
                if (message.ID == MYSELF.ID) {
                    return [NSString stringWithFormat:@"%@领取了我的红包",operUser];
                }else{
                    return [NSString stringWithFormat:@"我领取了%@的红包",userInfo];
                }
                
                break;
            }
                
            default:
                break;
        }
    }
    
    //    int deviceType = [messageDic[@"deviceType"] intValue];
    return msgString;
}

-(NSString*)stringWithGroupOption:(NSDictionary*)optionDictionary{
    
    int operType = [optionDictionary[@"operType"] intValue];
    NSString *operUser = optionDictionary[@"operUser"];
    NSString *userInfo = optionDictionary[@"usersInfo"];
    switch (operType) {
        case 0:
            return [NSString stringWithFormat:@"%@加入该群",userInfo];
        case 1:
            return [NSString stringWithFormat:@"%@邀请%@加入该群",operUser,userInfo];
        case 2:
            return [NSString stringWithFormat:@"%@同意%@加入该群",operUser,userInfo];
        case 3:
            return [NSString stringWithFormat:@"%@退出该群",userInfo];
        case 4:
            return [NSString stringWithFormat:@"%@被%@移除该群",userInfo,operUser];
        default:
            break;
    }
    return nil;
    
}
#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //    NSInteger i = [_chatModel.chatMessageList numberOfSections];
    return [_chatModel.chatMessageList numberOfSections];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_chatModel.chatMessageList numberOfRowsInSection:section];
}

#pragma mark - Responding to collection view tap events
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation{
    LDMessageModel *message = (LDMessageModel*)[_chatModel.chatMessageList itemAtIndexPath:indexPath];
    
    LDMessageListModel *messages = self.chatModel.chatMessageList;
    if ([messages.selectedItems containsLDItem:message]) {
        [messages delSelectedItem:message];
    }else
        [self.chatModel.chatMessageList.selectedItems addObject:message];
    
    [self.collectionView reloadData];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    LDMessageModel *message = (LDMessageModel*)[_chatModel.chatMessageList itemAtIndexPath:indexPath];
    
    if (message.messageType == MESSAGE_TYPE_IMAGE) {
        NSArray *visibCell = [collectionView visibleCells];
        __block NSUInteger index = -1;
        [visibCell enumerateObjectsUsingBlock:^(JSQMessagesCollectionViewCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[collectionView indexPathForCell:cell] isEqual:indexPath]) {
                *stop = YES;
            }
            if (cell.mediaView && [cell.mediaView isKindOfClass:[UIImageView class]]) {
                index += 1;
            }
        }];
        [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
            NSMutableArray *localImages = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:localImages.count];
            for (NSUInteger i = 0; i< visibCell.count; i++) {
                JSQMessagesCollectionViewCell *cell = [visibCell objectAtIndex:i];
                if (!cell.mediaView || ![cell.mediaView isKindOfClass:[UIImageView class]]) {
                    continue;
                }
                PhotoModel *pbModel=[[PhotoModel alloc] init];
                pbModel.mid = i + 1;
                //            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
                //            pbModel.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
                pbModel.image = [(UIImageView*)cell.mediaView image];
                pbModel.image_HD_U = @"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=网络图片&pn=0&spn=0&di=140501382670&pi=&rn=1&tn=baiduimagedetail&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=1414664594%2C2171329517&os=964253411%2C3153774711&simid=3419101897%2C379450959&adpicid=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic.58pic.com%2F58pic%2F15%2F66%2F29%2F76Y58PICik6_1024.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bcbrtv_z%26e3Bv54AzdH3Ffitstwg2p7AzdH3F8cmmdl0m_z%26e3Bip4s&gsm=0";
                //源frame
                pbModel.sourceImageView = (UIImageView*)cell.mediaView;
                [modelsM addObject:pbModel];
            }
            return modelsM;
        }];
    }else if(message.messageType == MESSAGE_TYPE_CARD){//如果消息类型是名片
        LDCardMessageModel *cardModel = (LDCardMessageModel*)message;
        //根据id跳转到对应的页面
        [self pushViewWithID:cardModel.cardID];
    }else if(message.messageType == MESSAGE_TYPE_LOCATION){//如果消息类型位置信息
        LDLocationMessageModel *locationMsg = (LDLocationMessageModel*)message;
        LDLocationDetailsViewController *locationVC = [[LDLocationDetailsViewController alloc]init];
        locationVC.locationMsg = locationMsg;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:locationVC];
        [self.navigationController presentViewController:nav
                                                animated:YES completion:nil];
    }else if(message.messageType == MESSAGE_TYPE_AUDIO){
        JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if (message.sendUserID == MYSELF.ID) {
            [(UIImageView*)cell.mediaView setAnimationImages:@[[[UIImage imageNamed:@"AudioOutgoing1"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 25) resizingMode:UIImageResizingModeTile]
                                                               ,[[UIImage imageNamed:@"AudioOutgoing2"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 25) resizingMode:UIImageResizingModeTile]
                                                               ,[[UIImage imageNamed:@"AudioOutgoing"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 25) resizingMode:UIImageResizingModeTile]]];
        }else{
            [(UIImageView*)cell.mediaView setAnimationImages:@[[[UIImage imageNamed:@"AudioIncoming1"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 25) resizingMode:UIImageResizingModeTile]
                                                               ,[[UIImage imageNamed:@"AudioIncoming2"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 25) resizingMode:UIImageResizingModeTile]
                                                               ,[[UIImage imageNamed:@"AudioIncoming"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 25) resizingMode:UIImageResizingModeTile]]];
        }
        [(UIImageView*)cell.mediaView setAnimationDuration:1.2];
        [(UIImageView*)cell.mediaView startAnimating];
        
        [(LDAudioMessageModel*)message playAudio:^(bool result) {
            if (result) {
                [(UIImageView*)cell.mediaView stopAnimating];
                if (message.activeType == 1) {
                    [self.chatModel.chatMessageList removeMessages:@[message] completion:^(NSError *error) {
                        if (!error) {
                            [self.chatModel.chatMessageList assembleData];
                            [self.collectionView reloadData];
                        }
                    }];
                }
            }
        }];
    }else if (message.messageType == MESSAGE_TYPE_FILE){
        JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if([cell.mediaView viewWithTag:message.ID]){
            [(LDFileMessageModel *)message downLoadFile:^(id file) {
                if(file){
                    [[cell.mediaView viewWithTag:message.ID] removeFromSuperview];
                    [collectionView reloadData];
                }
            } onProgress:nil];
        }
    }
    else if (message.messageType == MESSAGE_TYPE_ASSEMBLE){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
        LDComboMessageViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDComboMessageViewController"];
        vc.combo = (LDComboMessageModel*)message;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didLongPressMessageBubbleAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.longPressCell = cell;
    LDMessageModel *message = (LDMessageModel*)[_chatModel.chatMessageList itemAtIndexPath:indexPath];
    self.longPressMessageModel = message;
    UIMenuController *sharedMenuController = [UIMenuController sharedMenuController];
    UIMenuItem *revokeItem = [[UIMenuItem alloc]initWithTitle:@"撤回" action:@selector(revokeItemClicked:)];
    UIMenuItem *item = [[UIMenuItem alloc]initWithTitle:@"更多" action:@selector(moreItemClicked:)];
    if (message.sendUserID == MYSELF.ID ) {
        [sharedMenuController setMenuItems:@[revokeItem,item]];
        
    }else{
        [sharedMenuController setMenuItems:@[item]];
    }
    [sharedMenuController setTargetRect:cell.messageBubbleContainerView.bounds inView:cell.messageBubbleContainerView];
    [sharedMenuController setMenuVisible:YES animated:YES];
}
#pragma mark ---撤回一分钟内的消息
-(void)revokeItemClicked:(id)sender {
    int64_t timesp = self.longPressMessageModel.timestamp;
    int64_t recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    int64_t ts = (recordTime - timesp)/1000;
    int hour = (int)(ts/3600);
    
    int minute = (int)(ts - hour*3600)/60;
    
    //    int second =(int)(ts - hour*3600 - minute*60);
    if (minute < 1 && hour == 0) {
        
        LDMessageModel *msg = [[LDMessageModel alloc]init];
        msg.messageType = MESSAGE_TYPE_REVOKE;
        msg.msgProperties = [@{@"messageID":[NSNumber numberWithLongLong:self.longPressMessageModel.ID]} JSONString];
        msg.message = MYSELF.name;
        [self.chatModel sendMessage:msg onStatus:^(msg_status status) {
            if (status ==  msg_normal) {
                [self.chatModel.chatMessageList removeMessages:@[self.longPressMessageModel] completion:^(NSError *error) {
                    if (!error) {
                        [self.chatModel.chatMessageList assembleData];
                        [SVProgressHUD showWithStatus:@"撤回成功" maskType:SVProgressHUDMaskTypeBlack];
                        [SVProgressHUD dismiss];
                        [self.collectionView reloadData];
                    }
                }];
            }else if(status == msg_sending){
                [SVProgressHUD showWithStatus:@"正在撤回..." maskType:SVProgressHUDMaskTypeBlack];
            }
            //加入到会话窗口消息列表
            [self receivedMessage:msg];
        }];
    }else{
        NSString *timeOut = [NSString stringWithFormat:@"发送超过一分钟的消息，不能撤回。"];
        [SVProgressHUD showErrorWithStatus:timeOut maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (void)moreItemClicked:(id)sender{
    self.showMessageSelector = !self.showMessageSelector;
    [self.inputToolbar hideExtendViewWithAnimated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.inputToolbar.preferredDefaultHeight = 0;
    } completion:^(BOOL finished) {
        
        [self showMoreBar];
    }];
    
    [self.collectionView reloadData];
}
-(void)cancelButtonPressed:(id)sender{
    [self hideMoreBar];
}

-(void)sendButtonPressed:(id)sender{
    [self hideMoreBar];
    
    LDComboMessageModel *combo = [[LDComboMessageModel alloc]initWithMessages:[self.chatModel.chatMessageList selectedItems]];
    
    __block NSInteger count = 0;
    [self.chatModel.chatMessageList.selectedItems enumerateObjectsUsingBlock:^(LDMessageModel* obj, NSUInteger idx, BOOL *stop) {
        if (obj.messageType == MESSAGE_TYPE_TEXT || obj.messageType == MESSAGE_TYPE_AUDIO || obj.messageType == MESSAGE_TYPE_LOCATION|| obj.messageType == MESSAGE_TYPE_IMAGE|| obj.messageType == MESSAGE_TYPE_FILE|| obj.messageType == MESSAGE_TYPE_CARD|| obj.messageType == MESSAGE_TYPE_EXPRESSTIONS) {
            count += 1;
        }
    }];
    
    if (count == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有选择支持的消息类型"];
        return;
    }
    
    UIStoryboard *contact = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    LDChooseMemberController *vc = [contact instantiateViewControllerWithIdentifier:@"LDChooseMemberController"];
    vc.type = 1;
    vc.backContactBlock = ^(LDItemModel *item){
        LDChatModel *chat = [[LDChatModel alloc]initWithID:item.ID];
        [chat sendMessage:combo onStatus:^(msg_status status) {
            if (status == msg_normal){
                [SVProgressHUD showSuccessWithStatus:@"转发成功"];
                [self receivedMessage:combo];
            }
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Messages view controller 消息发送
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    //发送文本消息后清空输入框
    [self.inputToolbar.contentView.textView setText:@""];
    [self.inputToolbar toggleSendButtonEnabled];
    
    //发送文本消息
    
    LDMessageModel *message = [[LDTextMessageModel alloc] initWithText:text];
    if (self.isFire) {
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
    [_chatModel sendMessage:message onStatus:^(msg_status status) {
        //消息发送状态回调代码
        if (status == msg_normal){
            self.isFire = NO;
            self.isDelayMsg = NO;
            self.isTask = NO;
            self.isReceipt = NO;
        }
    }];
    
    //加入到会话窗口消息列表
    [self receivedMessage:message];
}

- (void)didPressPhotoButton:(UIButton *)sender
{
    //1. 推荐使用XMNPhotoPicker 的单例
    //2. 设置选择完照片的block回调
    [[XMNPhotoPicker sharePhotoPicker] setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
        if (!assets) {
            for (UIImage *image in images) {
                LDImageMessageModel *message = [[LDImageMessageModel alloc] initWithImage:image];
                [message setFileName:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] *1000]];
                [_chatModel sendMessage:message onProgress:^(int32_t progress) {
                    //文件上传进度回调代码
                } onStatus:^(msg_status status) {
                    //消息发送状态回调代码
                }];
                
                //加入到会话窗口消息列表
                [self receivedMessage:message];
            }
            return ;
        }
        assetArray = [assets copy];
        for (XMNAssetModel *assetModel in assetArray) {
            PHAsset *asset = assetModel.asset;
            UIImage *pickerImage = [assetModel originImage];
            LDImageMessageModel *message = [[LDImageMessageModel alloc] initWithImage:pickerImage];
            [message setFileName:[asset valueWithProperty:@"filename"]];
            [_chatModel sendMessage:message onProgress:^(int32_t progress) {
                //文件上传进度回调代码
            } onStatus:^(msg_status status) {
                //消息发送状态回调代码
            }];
            
            //加入到会话窗口消息列表
            [self receivedMessage:message];
        }
    }];
    
    //需要指定弹出相机和相册的controller--用jsq第三方扩展显示
    [[XMNPhotoPicker sharePhotoPicker] setParentController:self];
    [self.inputToolbar showExtendView:[XMNPhotoPicker sharePhotoPicker]];
}
- (void)didPressAudioButton:(UIButton*)sender
{
    AudioRecoderPanel *audioRecoderPanel = [[[UINib nibWithNibName: @"AudioRecoderPanel" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [audioRecoderPanel setDelegate:self];
    [self.inputToolbar showExtendView:audioRecoderPanel];
}

- (void)cancelRecoder
{
    
}

- (void)completeRecoder:(NSURL *)audioPath
{
    LDAudioMessageModel *message = [[LDAudioMessageModel alloc] initWithAudio:audioPath.relativeString];
    [_chatModel sendMessage:message onProgress:^(int32_t progress) {
        
    } onStatus:^(msg_status status) {
        
    }];
    [self receivedMessage:message];
}

- (void)didPressExpressionButton:(UIButton *)sender
{
    [self.inputToolbar showExtendView:_simpleEmoji];
}

//表情选择
- (void)fillEmoji:(NSString*)emoji{
    [self.inputToolbar.contentView.textView setText:[self.inputToolbar.contentView.textView.text stringByAppendingString:emoji]];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.inputToolbar.contentView.textView];
    [self.inputToolbar toggleSendButtonEnabled];
}

//发送动态表情
- (void)sendDynamicExpression:(NSInteger)type{
    LDExpressionMessageModel *message = [[LDExpressionMessageModel alloc] initWithExpression:type];
    [_chatModel sendMessage:message onStatus:^(msg_status status) {
        //消息发送状态回调代码
        if (status == msg_normal) {
            
        }else if (status == msg_sending){
            
        }
    }];
    [self receivedMessage:message];
}

-(void)didPressMoreButton:(UIButton *)sender{
    self.isDirective = NO;
}

- (void)sendQR:(NSString*)qrString withAvatar:(UIImage*)avatar
{
    __block UIImageView*imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [HMScannerController cardImageWithCardName:qrString avatar:avatar contentSize:1000 completion:^(UIImage *image) {
        if (image) {
            imageView.image = image;
            LDImageMessageModel *message = [[LDImageMessageModel alloc] initWithImage:imageView.image];
            [message setFileName:@"qrcode"];
            [_chatModel sendMessage:message onProgress:^(int32_t progress) {
                //文件上传进度回调代码
            } onStatus:^(msg_status status) {
                //消息发送状态回调代码
            }];
            
            //加入到会话窗口消息列表
            [self receivedMessage:message];
        }
      
    }];
//    imageView.image = [imageView qrString:qrString iconImage:avatar];
    }

- (void)didPressLocationButton:(UIButton *)sender
{
    PanelMapView *mapView = [[[UINib nibWithNibName:@"PanelMapView" bundle:nil] instantiateWithOwner:self options:nil]objectAtIndex:0];
    mapView.delegate = self;
    
    __weak typeof(self) mySelf = self;
    mapView.locationBlock = ^(double latitude,double longitude,NSString *address){
        LDLocationMessageModel *message = [[LDLocationMessageModel alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) andAddress:address];
        if (self.isFire) {
            [message setActiveType:1];
        }
        [_chatModel sendMessage:message onStatus:^(msg_status status) {
            //消息发送状态回调代码
            [self.inputToolbar hideExtendViewWithAnimated:YES];
            if (status == msg_normal) {
                
            }else if (status == msg_sending){
                
            }
        }];
        
        //加入到会话窗口消息列表
        [mySelf receivedMessage:message];
    };
    [self.inputToolbar showExtendView:mapView];
}

-(void)sendFile:(NSString *)path{
    LDFileMessageModel *file = [[LDFileMessageModel alloc]initWithFile:path];
    [self.chatModel sendMessage:file onProgress:^(int32_t progress) {
        
    } onStatus:^(msg_status status) {
        [self.collectionView reloadData];
    }];
}

//- (NSString *)senderDisplayName
//{
//    LDChatModel *chatModel = (LDChatModel*)[[LDClient sharedInstance].chatListModel itemWithID:_chatModel.ID];
//    if (chatModel && chatModel.sender != nil) {
//        return chatModel.sender;
//    }else{
//        LDContactModel *contact = (LDContactModel*)[[LDClient sharedInstance].contactListModel itemWithID:_chatModel.ID];
//        if (contact) {
//            if (contact.remark && !contact.remark.isEmpty) {
//                return contact.remark;
//            }
//            return contact.name;
//        }else{
//            LDRobotModel *robot = (LDRobotModel*)[[LDClient sharedInstance].robotListModel itemWithID:_chatModel.ID];
//            if (robot) {
//                if (robot.appName.jsonType == JSON_TYPE_DICTIONARY) {
//                    NSDictionary *nameDic = [robot.appName objectFromJSONString];
//                    if (nameDic && [nameDic objectForKey:@"name"]) {
//                        return [nameDic objectForKey:@"name"];
//                    }else{
//                        return robot.appName;
//                    }
//                }else{
//                    return (robot.appName && robot.appName.length > 0)?robot.appName:[NSString stringWithFormat:@"%lld",robot.ID];
//                }
//            }else{
//                LDGroupModel *group = (LDGroupModel*)[[LDClient sharedInstance].groupListModel itemWithID:_chatModel.ID];
//                if (group) {
//                    return (group.groupName && group.groupName.length > 0)?group.groupName:[NSString stringWithFormat:@"%lld",group.ID];
//                }
//            }
//        }
//    }
//    return nil;
//}

#pragma mark LDInputExtendViewDelegate
-(void)didPressExtend:(NSInteger)index
{
    [self.inputToolbar hideExtendViewWithAnimated:YES];
    if (self.isDirective) {
        if (index == 0){
            //阅后回执
            self.isReceipt = self.isReceipt == NO ?YES:NO;
            [self changToolBarItemTintColor:@"D0021B" hightLight:self.isReceipt];
        }
        if (index == 1) {
            //任务
            self.isTask = self.isTask == NO ?YES:NO;
            [self changToolBarItemTintColor:@"50E3C2" hightLight:self.isTask];
        }
        if (index == 2) {
            //延迟消息
            self.isDelayMsg = self.isDelayMsg == NO ?YES:NO;
            [self changToolBarItemTintColor:@"F8E71C" hightLight:self.isDelayMsg];
        }
    }else{
        if (index == 0) {
            UIStoryboard *contact = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
            LDChooseMemberController *addBlackVc = [contact instantiateViewControllerWithIdentifier:@"LDChooseMemberController"];
            addBlackVc.hidesBottomBarWhenPushed = YES;
            addBlackVc.type = 1;
            __weak typeof(self) mySelf = self;
            addBlackVc.backContactBlock = ^(LDItemModel* item){
                if (contact) {
                    LDCardMessageModel *message = [[LDCardMessageModel alloc]initWithItem:item];
                    if (self.isFire) {
                        [message setActiveType:1];
                    }
                    [_chatModel sendMessage:message onStatus:^(msg_status status) {
                        //消息发送状态回调代码
                        if (status == msg_normal) {
                            
                        }else if (status == msg_sending){
                            
                        }
                    }];
                    
                    //加入到会话窗口消息列表
                    [mySelf receivedMessage:message];
                }
            };
            addBlackVc.qrCodeBlock = ^(LDItemModel *item){
                IDRange idRange = [[LDClient sharedInstance] idRange:item.ID];
                if (idRange == id_range_ROBOT) {
                    LDRobotModel *robot = (LDRobotModel*)item;
                    [[LDClient sharedInstance] avatar:robot.appIcon withDefault:@"robot" complete:^(UIImage *avatar) {
                        [self sendQR:[NSString stringWithFormat:@"http://im.vrv.cn/user/getinfo?uid=%lld",robot.ID] withAvatar:avatar];
                    }];
                }else if(idRange == id_range_USER){
                    LDUserModel *contact = (LDUserModel*)item;
                    NSString *msgFrom = @"Unisex";
                    if (contact.sex == msg_owner_male) {
                        msgFrom = @"MaleIcon";
                    }
                    if (contact.sex == msg_owner_female) {
                        msgFrom = @"FemaleIcon";
                    }else{
                        msgFrom = @"Unisex";
                    }
                    [[LDClient sharedInstance] avatar:contact.avatar withDefault:@"Unisex" complete:^(UIImage *avatar) {
                        [self sendQR:[NSString stringWithFormat:@"http://im.vrv.cn/user/getinfo?uid=%lld",contact.ID] withAvatar:avatar];
                    }];
                }else{
                    LDGroupModel *contact = (LDGroupModel*)item;
                    [[LDClient sharedInstance] avatar:contact.avatarUrl withDefault:@"GroupIcon" complete:^(UIImage *avatar) {
                        [self sendQR:[NSString stringWithFormat:@"http://im.vrv.cn/user/getinfo?uid=%lld",contact.ID] withAvatar:avatar];
                    }];
                }
            };
            [self.navigationController pushViewController:addBlackVc animated:YES];
        }
        if (index == 1) {
            LDFileChooseController *vc = [[LDFileChooseController alloc]init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (index == 2) {
            //记事本
            LDNoteListTableViewController *noteVC = [[LDNoteListTableViewController alloc]initWithSenderTarget:MYSELF.ID];
            noteVC.originId = _chatModel.ID;
            [self.navigationController pushViewController:noteVC animated:YES];
            
        }
    }
}

-(void)changToolBarItemTintColor:(NSString *)hexColor hightLight:(BOOL)state{
    if(state){
        self.inputToolbar.contentView.rightBarButtonItem.tintColor = [UIColor colorWithHexColorString:hexColor];
    }else{
        self.inputToolbar.contentView.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
    }
    UIImage *image = self.inputToolbar.contentView.rightBarButtonItem.imageView.image;
    [self.inputToolbar.contentView.rightBarButtonItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

#pragma mark PhotoBroswerVCDelegate
- (void)scanQRCode:(NSString *)qrCode
{
    NSArray *subString = [qrCode componentsSeparatedByString:@"="];
    int64_t target = [[subString lastObject] longLongValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pushViewWithID:target];
    });
}

-(void)pushViewWithID:(int64_t)targetID{
    __block LDItemModel *itemModel;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    IDRange idRange = [[LDClient sharedInstance] idRange:targetID];
    if (idRange == id_range_USER) {
        LDContactInfoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDContactInfoViewController"];
        vc.userInfoIDForomChatCard = targetID;
        [vc setPushFromChatCard:YES];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = self.navigationItem.title;
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(idRange == id_range_GROUP)  {
        LDGroupModel *groupModel = [[LDClient sharedInstance] localGroup:targetID];
        if (!groupModel) {
            [[LDClient sharedInstance].contactListModel contactsWithKey:[NSString stringWithFormat:@"%lld",targetID] onArea:search_area_inside forType:search_type_all completion:^(NSError *error, NSDictionary *info) {
                if (!error) {
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
                    LDGroupViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupViewController"];
                    vc.groupModel = groupModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    NSAssert(error != nil, @"搜索关键字or信息出错");
                }
            }];
        }else{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
            LDGroupViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LDGroupViewController"];
            vc.groupModel = groupModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    if (idRange == id_range_ROBOT) {
        itemModel = [[LDClient sharedInstance] localRobot:targetID];
        if (!itemModel) {
            itemModel = [[LDRobotModel alloc] initWithID:targetID];
            [(LDRobotModel*)itemModel loadRobotInfo:^(LDRobotModel *robotInfo) {
                if (robotInfo != nil) {
                    itemModel = robotInfo;
                    
                }
            }];
        }
    }
    
}

#pragma mark scroller
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isDragging) {
        return;
    }
    if (self.collectionView.contentOffset.y < 0 && self.collectionView.visibleCells.count > 0) {
        isDragging = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <= 0) {
        [self loadHistoryMessage];
    }
}

-(BOOL)prefersStatusBarHidden
{
    return _hiddenStatusBar;
}

#pragma mark PanelMapView Delegate

- (void)locationButtonPressed:(id)sender{
    UIView *view = (UIView *)sender;
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [blurView setFrame:view.frame];
    [view addSubview:blurView];
    UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){0,0,SCREEN_WIDTH,50}];
    [label setText:@"位置消息发送中"];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setCenter:CGPointMake(SCREEN_WIDTH/2, 216/2)];
    [blurView addSubview:label];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action ==@selector(moreItemClicked:)){
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

#pragma mark LDDatePickerDelegate Delegate
-(void)didPickDate:(NSDate *)date{
    NSNumber *number = [NSNumber numberWithLongLong:[date timeIntervalSince1970] * 1000];
    [delayMsg setMsgProperties:[@{@"isDelayMsg":@1,@"delaySendTime":number} JSONString]];
    [self.chatModel sendMessage:delayMsg onStatus:^(msg_status status) {
        self.isFire = NO;
        self.isDelayMsg = NO;
        self.isTask = NO;
        self.isReceipt = NO;
    }];
}

#pragma mark 系统监听
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
