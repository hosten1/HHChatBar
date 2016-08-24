//
//  LDNoteCell.m
//  Linkdood
//
//  Created by VRV2 on 16/8/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDNoteCell.h"
#import "NSString+MLExpression.h"
#import "MLLinkLabel.h"

@interface LDNoteCell ()<UITextViewDelegate>

@end

@implementation LDNoteCell
- (instancetype)initWithMessage:(LDNoteModel *)noteModel{
    self = [super init];
    if (self)
    {
        [self setAppliesMediaViewMaskAsOutgoing:noteModel.sendUserID == MYSELF.ID];
        
        self.noteModel = noteModel;
    }
    return self;
}
-(CGSize)mediaViewDisplaySize{
    return CGSizeMake(SCREEN_WIDTH, 200);

  
}
-(UIView *)mediaView{
    CGSize size = [self mediaViewDisplaySize];
    UIImageView *cachedImageView = [[UIImageView alloc]init];
    cachedImageView.bounds = CGRectMake(-50, 0, size.width, size.height);
    cachedImageView.contentMode = UIViewContentModeScaleAspectFill;
    cachedImageView.userInteractionEnabled = YES;
    UIImageView *contentView = [[UIImageView alloc]init];
    contentView.frame = CGRectMake(10, 20, size.width-30, size.height);
    //    标题
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.backgroundColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    titleLab.frame = CGRectMake(0, 0, contentView.size.width, 20);
    titleLab.text = _noteModel.title;
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = [UIColor whiteColor];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [contentView addSubview:titleLab];
    //    位置
    UILabel *savePosition = [[UILabel alloc]init];
    savePosition.backgroundColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    savePosition.frame = CGRectMake(contentView.size.width*0.7, 0, contentView.size.width*0.2, 20);
    NSString *posString = nil;
    if (_noteModel.sourceType == 0) {
        posString = @"位置:本地";
    }else{
        posString = @"位置:线上";
    }
    savePosition.text = posString;
    savePosition.font = [UIFont systemFontOfSize:10];
    savePosition.textColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [savePosition setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:savePosition];
        //内容
    UITextView *messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, contentView.size.width, contentView.size.height-10)];
    messageTextView.backgroundColor=[UIColor colorWithWhite:0.902 alpha:1.000]; //背景色
    messageTextView.scrollEnabled = NO;
    messageTextView.editable = YES;
    messageTextView.delegate = self;
    messageTextView.font=[UIFont fontWithName:@"Arial" size:14.0];
    messageTextView.returnKeyType = UIReturnKeyDefault;
    messageTextView.keyboardType = UIKeyboardTypeDefault;
    messageTextView.textAlignment = NSTextAlignmentLeft;
    messageTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    messageTextView.textColor = [UIColor blackColor];
    
    //图片内容
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor=[UIColor colorWithWhite:0.902 alpha:1.000]; //背景色
    imageView.frame = CGRectMake(0, 20,  contentView.size.width,  contentView.size.height-70);
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    switch (_noteModel.type) {
        case NOTE_TYPE_TEXT:{
              messageTextView.text = _noteModel.content;//设置显示的文本内容
              [contentView addSubview:messageTextView];
            }
            break;
        case NOTE_TYPE_IMAGE:{
            imageView.tag = 100002;
            imageView.contentMode = UIViewContentModeLeft;
            imageView.image = [self OriginImage:[UIImage imageNamed:@"DefaultImage"] scaleToSize:CGSizeMake(100, 100)];
            [contentView addSubview:imageView];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *nameString = [[_noteModel.content componentsSeparatedByString:@"/"] lastObject];
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                NSString *resoucesPath = [path stringByAppendingPathComponent:nameString];
                UIImage *image = [UIImage imageWithContentsOfFile:resoucesPath] ;
                image = [self OriginImage:image scaleToSize:CGSizeMake(100, 100)];
                if (!image) {
                    image = [self OriginImage:[UIImage imageNamed:@"DefaultImage"] scaleToSize:CGSizeMake(100, 100)];
                }
              
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回主线程刷新ui
                      imageView.image = image;
                });
  
           });
        }
        break;
        case NOTE_TYPE_AUDIO:{
            imageView.tag = 100001;
            UIImage *image = [[UIImage imageNamed:@"AudioIncoming"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,20) resizingMode:UIImageResizingModeTile];
            imageView.contentMode = UIViewContentModeLeft;

            if (!image) {
                image = [self OriginImage:[UIImage imageNamed:@"DefaultImage"] scaleToSize:imageView.size];
            }
            imageView.image = image;
            [contentView addSubview:imageView];
        }
            break;

        default:
            break;
    }
    //最后修改时间
    UIView *buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, contentView.size.height-50, contentView.size.width, 20)];
    UILabel *changeTimeLab = [[UILabel alloc]init];
    changeTimeLab.backgroundColor = [UIColor clearColor];
    changeTimeLab.frame = CGRectMake(buttomView.width-190,0,180, 20);
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:_noteModel.lastChgTime/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    if (!_noteModel.lastChgTime) {
        currentDateStr = @"未修改";
    }
    changeTimeLab.text = [NSString stringWithFormat:@"修改时间:%@",currentDateStr];
    changeTimeLab.font = [UIFont systemFontOfSize:12];
    changeTimeLab.textColor = [UIColor whiteColor];
    [changeTimeLab setTextAlignment:NSTextAlignmentRight];

    
    UILabel *formMessageLab = [[UILabel alloc]init];
    formMessageLab.backgroundColor = [UIColor clearColor];
    formMessageLab.frame = CGRectMake(10,0,180, 20);
    NSString *fromName = nil;
    if (!_noteModel.targetID) {
        fromName = @"未知";
    }else{
        IDRange idRange = [[LDClient sharedInstance] idRange:self.noteModel.targetID];
        if (idRange == id_range_USER) {
           LDUserModel *user = [[LDClient sharedInstance]localContact:self.noteModel.targetID];
            fromName = user.name;
        }else if(idRange == id_range_GROUP){
            LDGroupModel *group = [[LDClient sharedInstance]localGroup:self.noteModel.targetID];
            fromName = group.groupName;

        }else if(idRange == id_range_ROBOT){
            LDRobotModel *robot = [[LDClient sharedInstance]localRobot:self.noteModel.targetID];
            fromName = robot.appName;

        }
    }
    formMessageLab.text = [NSString stringWithFormat:@"来源:%@",fromName];
    formMessageLab.font = [UIFont systemFontOfSize:12];
    formMessageLab.textColor = [UIColor whiteColor];
    [formMessageLab setTextAlignment:NSTextAlignmentLeft];
    
    
    buttomView.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [buttomView addSubview:changeTimeLab];
    [buttomView addSubview:formMessageLab];
    [contentView addSubview:buttomView];

    [cachedImageView addSubview:contentView];
    return cachedImageView;
}
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

@end
