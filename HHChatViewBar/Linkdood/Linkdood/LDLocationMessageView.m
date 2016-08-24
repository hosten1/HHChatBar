//
//  LDLocationMessageView.m
//  Linkdood
//
//  Created by VRV2 on 16/5/26.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDLocationMessageView.h"
#import "UILabel+ContentSize.h"
#import "HHLocationServiceView.h"
#import "UIImage+mapView.h"

@interface LDLocationMessageView ()
@property (strong, nonatomic) UIImageView *locationContainView;

@end

@implementation LDLocationMessageView
-(instancetype)initWithMessage:(LDLocationMessageModel *)message{
    if (self = [super init]) {
        [self setAppliesMediaViewMaskAsOutgoing:message.sendUserID == MYSELF.ID];
        self.LocationMessage = message;
    }
    return self;
}
-(CGSize)mediaViewDisplaySize{
    return CGSizeMake(240, 120);
}

-(UIView *)mediaView{
    
    if (self.LocationMessage) {
        self.address = self.LocationMessage.address;
    }
    _locationContainView = [[UIImageView alloc]init];
    CGSize size = [self mediaViewDisplaySize];
    BOOL outgoing = self.appliesMediaViewMaskAsOutgoing;
    
    UIImageView *containView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    containView.backgroundColor = self.appliesMediaViewMaskAsOutgoing?[UIColor jsq_messageBubbleLightGrayColor]:[UIColor colorWithRed:200/255.0 green:220/255.0 blue:1 alpha:1];
    containView.clipsToBounds = YES;
  
    CGFloat ypos = 0;
    CGFloat xposx =  outgoing ? 0 : 8;
    CGRect LocationFrame = CGRectMake(xposx, ypos, size.width, size.height);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@/%lld/%f_%f",APP_TMPPATH,MYSELF.ID,self.LocationMessage.latitude,self.LocationMessage.longitude];
    UIImageView *mapView = [[UIImageView alloc]init];
    if ([fileManager fileExistsAtPath:filePath]) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
        mapView = [[UIImageView alloc] initWithImage:image];
        [mapView setFrame:LocationFrame];
        [containView addSubview:mapView];
    }else{
        NSString *locationDirPath = [NSString stringWithFormat:@"%@/%lld",APP_TMPPATH,MYSELF.ID];
        if (![fileManager fileExistsAtPath:locationDirPath]) {
            [fileManager createDirectoryAtPath:locationDirPath withIntermediateDirectories:YES attributes:nil error:nil];}
            UIImage *image = [UIImage shotCoordinate:CLLocationCoordinate2DMake(self.LocationMessage.latitude, self.LocationMessage.longitude) withSize:LocationFrame.size];
            mapView = [[UIImageView alloc]initWithImage:image];
            [mapView setFrame:LocationFrame];
            [containView addSubview:mapView];
            BOOL result = [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
            NSLog(@"位置图片保存%@",result?@"成功":@"失败");
    }

    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = self.address;
    CGFloat addressLabelWidth = LocationFrame.size.width;
    CGFloat addressLabelHeight = 20;
    CGFloat addressLabelY = mapView.maxY - addressLabelHeight;
    
    CGRect frame = outgoing ? CGRectMake(0, addressLabelY,addressLabelWidth , addressLabelHeight) : CGRectMake(15, addressLabelY, addressLabelWidth,addressLabelHeight);
    addressLabel.frame = frame;
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.textColor = [UIColor blackColor];
    [addressLabel setBackgroundColor:RGBACOLOR(0, 0, 0, 0.3)];
    [addressLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    
    addressLabel.numberOfLines = 0;
    addressLabel.font = [UIFont systemFontOfSize:11];
    
    [containView addSubview:addressLabel];

    self.locationContainView = containView;
    JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc] init];
    if (self.appliesMediaViewMaskAsOutgoing) {
        [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor clearColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyOutgoingBubbleImageMaskToMediaView:self.locationContainView];
    }else{
        [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor clearColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyIncomingBubbleImageMaskToMediaView:self.locationContainView];
    }
    return self.locationContainView;
}

@end
