//
//  LDCardMessageView.m
//  Linkdood
//
//  Created by VRV2 on 16/5/20.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDCardMessageView.h"

@interface LDCardMessageView ()
@property (strong, nonatomic) UIImageView *cachedImageView;
@end

@implementation LDCardMessageView
- (instancetype)initWithMessage:(LDMessageModel *)message{
    self = [super init];
    if (self)
    {
        [self setAppliesMediaViewMaskAsOutgoing:message.sendUserID == MYSELF.ID];

        self.cardMessage = (LDCardMessageModel*)message;
        }
    return self;
}
#pragma mark -- 判断该消息中的名片类型

-(void)optionItemModel{
    IDRange idRange = [[LDClient sharedInstance] idRange:self.cardMessage.cardID];
    if (idRange == id_range_USER) {
        self.itemModel = [[LDClient sharedInstance] localContact:self.cardMessage.cardID];
        if (!self.itemModel) {
            self.itemModel = [[LDUserModel alloc] initWithID:self.cardMessage.cardID];
            [(LDUserModel*)self.itemModel loadUserInfo:^(LDUserModel *userInfo) {
                if (userInfo != nil) {
                    self.itemModel = userInfo;
                    _cachedImageView = [self setCardContentView];
                }
                NSLog(@"");
            }];
        }else{
            
        }
        
    }
//    if (idRange == id_range_GROUP) {
//        self.itemModel = [[LDClient sharedInstance] localGroup:self.cardMessage.cardID];
//        if (!self.itemModel) {
//            self.itemModel = [[LDGroupModel alloc] initWithID:self.cardMessage.cardID];
//            [(LDGroupModel*)self.itemModel loadGroupInfo:group_info completion:^(LDGroupModel *groupInfo) {
//                if (groupInfo != nil) {
//                    self.itemModel = groupInfo;
//                    _cachedImageView = [self setCardContentView];
//                }
//                NSLog(@"");
//            }];
//        }else{
//            
//        }
//    }
    if (idRange == id_range_ROBOT) {
        self.itemModel = [[LDClient sharedInstance] localRobot:self.cardMessage.cardID];
        if (!self.itemModel) {
            self.itemModel = [[LDRobotModel alloc] initWithID:self.cardMessage.cardID];
            [(LDRobotModel*)self.itemModel loadRobotInfo:^(LDRobotModel *robotInfo) {
                if (robotInfo != nil) {
                    self.itemModel = robotInfo;
                    _cachedImageView = [self setCardContentView];
                }
            }];
        }else{
            
        }
    }
}
//设置名片显示的内容
-(UIImageView*)setCardContentView{
    CGSize size = [self mediaViewDisplaySize];
    BOOL outgoing = self.appliesMediaViewMaskAsOutgoing;
    
    CGFloat titleWid = 135;
    CGFloat titleHeight = 25;
    CGFloat titleY = 5;
    CGRect frameff = outgoing ? CGRectMake(15, titleY, titleWid,titleHeight ) : CGRectMake(20, titleY, titleWid, titleHeight);
    
    UILabel *labelf = [[UILabel alloc] initWithFrame:frameff];
    labelf.textAlignment = NSTextAlignmentLeft;
    labelf.textColor = [UIColor grayColor];
//    labelf.text = self.title?self.title:@"个人名片";
    labelf.font=[UIFont systemFontOfSize:12];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    CGFloat ypos = ((size.height - 50) / 2+15);
    CGFloat xpos = (size.width - 50) / 2+20;
    CGFloat xposx =  outgoing ? (xpos-70) : (xpos-65);
    iconView.frame = CGRectMake(xposx, ypos, 40, 40);
    iconView.layer.cornerRadius = iconView.frame.size.width/2;
    iconView.layer.masksToBounds = YES;
    
    CGFloat nameLableWidth = 135;
    CGFloat nameLableHeight = 25;
    CGFloat nameLableY = 40;
    CGRect frame = outgoing ? CGRectMake((65+10), nameLableY,nameLableWidth , nameLableHeight) : CGRectMake(70+10, nameLableY, nameLableWidth, nameLableHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
//    label.text = _userName;
    label.numberOfLines = 0;
    label.font=[UIFont systemFontOfSize:14];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    imageView.backgroundColor = self.appliesMediaViewMaskAsOutgoing?[UIColor jsq_messageBubbleLightGrayColor]:[UIColor colorWithRed:200/255.0 green:220/255.0 blue:1 alpha:1];
    imageView.clipsToBounds = YES;
//    //缓存到本地(消息id进行判断)
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%lld/%lld",NSTemporaryDirectory(),MYSELF.ID,self.itemModel.ID];
//       if ([fileManager fileExistsAtPath:filePath]) {
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
//        imageView = [[UIImageView alloc] initWithImage:image];
//       
//    }else{
//        NSString *locationDirPath = [NSString stringWithFormat:@"%@/%lld",NSTemporaryDirectory(),MYSELF.ID];
//        if (![fileManager fileExistsAtPath:locationDirPath]) {
//            [fileManager createDirectoryAtPath:locationDirPath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        if ([[self.cachedImageView subviews] count] != 0) {
//            imageView = self.cachedImageView;
//        }else{
//            [imageView addSubview:iconView];
//            [imageView addSubview:label];
//            [imageView addSubview:labelf];
//        }
//       
//        UIImage *image = [self getImageFromView:imageView];
//
//        BOOL result = [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
//        NSLog(@"位置图片保存%@",result?@"成功":@"失败");
//    }
    if ([[self.cachedImageView subviews] count] != 0) {
        imageView = self.cachedImageView;
    }else{
        [imageView addSubview:iconView];
        [imageView addSubview:label];
        [imageView addSubview:labelf];
    }

    
    if ([self.itemModel isKindOfClass:[LDContactModel class]] || [self.itemModel isKindOfClass:[LDUserModel class]]) {
        LDUserModel *contact = (LDUserModel*)self.itemModel;
        NSString *msgFrom = @"Unisex";
        if (contact.sex == msg_owner_male) {
            msgFrom = @"MaleIcon";
        }
        if (contact.sex == msg_owner_female) {
            msgFrom = @"FemaleIcon";
        }
        self.title = @"个人名片";
        self.userName = contact.name;
        [[LDClient sharedInstance] avatar:contact.avatar withDefault:msgFrom complete:^(UIImage *avatar) {
            [iconView setImage:avatar];
            //            [self setImage:avatar];
        }];
    }else
//        if ([self.itemModel isKindOfClass:[LDGroupModel class]]){
//        LDGroupModel *group = (LDGroupModel*)_itemModel;
//        self.title = @"群名片";
//        self.userName = group.groupName;
//        [[LDClient sharedInstance] avatar:group.avatarUrl withDefault:@"GroupIcon" complete:^(UIImage *avatar) {
//            [iconView setImage:avatar];
//            //            [self setImage:avatar];
//        }];
//    }else
        if ([self.itemModel isKindOfClass:[LDRobotModel class]]){
        LDRobotModel *robot = (LDRobotModel*)self.itemModel;
        self.title = @"机器人名片";
        self.userName = robot.appName;
        [[LDClient sharedInstance] avatar:robot.appIcon withDefault:@"robot" complete:^(UIImage *avatar) {
            [iconView setImage:avatar];
            //            [self setImage:avatar];
        }];
    }
    labelf.text = self.title?self.title:@"个人名片";
    label.text = _userName;
    return imageView;
}

#pragma mark 将view保存成image

-(UIImage *)getImageFromView:(UIView *)theView

{
    
    //UIGraphicsBeginImageContext(theView.bounds.size);
    
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
-(CGSize)mediaViewDisplaySize{
    return CGSizeMake(180, 80);
}
-(UIView *)mediaView{
    
     _cachedImageView = [[UIImageView alloc]init];
    //处理 该信息中的名片是群，机器人等
    [self optionItemModel];
    
     _cachedImageView = [self setCardContentView];
    
    
   
    
    JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc] init];
    if (self.appliesMediaViewMaskAsOutgoing) {
        [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyOutgoingBubbleImageMaskToMediaView:self.cachedImageView];
    }else{
        [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyIncomingBubbleImageMaskToMediaView:self.cachedImageView];
    }
    return self.cachedImageView;
}
@end
