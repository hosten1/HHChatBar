//
//  LDFileMessageView.m
//  Linkdood
//
//  Created by yue on 7/4/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import "LDFileMessageView.h"

@interface LDFileMessageView()

@property (strong, nonatomic) UIImageView *cachedImageView;

@end

@implementation LDFileMessageView

- (instancetype)initWithMessage:(LDMessageModel *)message{
    self = [super init];
    if (self)
    {
        [self setAppliesMediaViewMaskAsOutgoing:message.sendUserID == MYSELF.ID];
        self.file = (LDFileMessageModel*)message;
    }
    return self;
}


-(UIView *)mediaView
{
    UIImageView *mediaView = [[UIImageView alloc]initWithFrame:(CGRect){0,0,self.mediaViewDisplaySize.width,self.mediaViewDisplaySize.height}];
    
    self.cachedImageView = mediaView;
    
    UIImageView *fileIcon = [[UIImageView alloc]initWithFrame:(CGRect){25,20,40,40}];
    
    switch ([self fileType]) {
        case FILE_TYPE_APK:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_APK"]];
            break;
        case FILE_TYPE_BAT:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_BAT"]];
            break;
        case FILE_TYPE_BIN:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_BIN"]];
            break;
        case FILE_TYPE_DLL:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_DLL"]];
            break;
        case FILE_TYPE_DOC:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_DOC"]];
            break;
        case FILE_TYPE_EXE:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_EXE"]];
            break;
        case FILE_TYPE_XML:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_XML"]];
            break;
        case FILE_TYPE_XLS:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_XLS"]];
            break;
        case FILE_TYPE_TXT:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_TXT"]];
            break;
        case FILE_TYPE_PPT:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_PPT"]];
            break;
        case FILE_TYPE_PDF:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_PDF"]];
            break;
        case FILE_TYPE_LOG:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_LOG"]];
            break;
        case FILE_TYPE_AUDIO:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_AMR"]];
            break;
        case FILE_TYPE_IMAGE:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_ICON"]];
            break;
        case FILE_TYPE_MOVIE:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_VIDEO"]];
            break;
        case FILE_TYPE_FOLDER:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_FLODER"]];
            break;
        default:
            [fileIcon setImage:[UIImage imageNamed:@"MESSAGE_TYPE_UNKNOW"]];
            break;
    }
    
    UILabel *fileName = [[UILabel alloc]initWithFrame:(CGRect){85,10,78,35}];
    [fileName setText:self.file.fileName];
    [fileName setFont:[UIFont systemFontOfSize:12]];
    [fileName setNumberOfLines:2];
    
    UILabel *fileSize = [[UILabel alloc]initWithFrame:(CGRect){85,53,78,17}];
    [fileSize setText:[self calcFileSize:self.file.fileSize]];
    [fileSize setFont:[UIFont systemFontOfSize:12]];
    [fileSize setTextColor:[UIColor lightGrayColor]];
    
    [mediaView addSubview:fileIcon];
    [mediaView addSubview:fileName];
    [mediaView addSubview:fileSize];
    
    JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc] init];
    if (self.appliesMediaViewMaskAsOutgoing) {
        [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyOutgoingBubbleImageMaskToMediaView:self.cachedImageView];
    }else{
        [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        [[[JSQMessagesMediaViewBubbleImageMasker alloc] initWithBubbleImageFactory:bubbleFactory] applyIncomingBubbleImageMaskToMediaView:self.cachedImageView];
    }
    
    self.cachedImageView.backgroundColor = self.appliesMediaViewMaskAsOutgoing?[UIColor jsq_messageBubbleLightGrayColor]:[UIColor colorWithRed:200/255.0 green:220/255.0 blue:1 alpha:1];
    [self.cachedImageView setClipsToBounds:YES];
    
    if(![self isDownloadFile]){
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"filedown"]];
        imageView.center = CGPointMake(45, 40);
        [self.cachedImageView addSubview:imageView];
        [imageView setTag:self.file.ID];
    }
    
    return self.cachedImageView;
}

-(CGSize)mediaViewDisplaySize
{
    return CGSizeMake(178,80);
}

- (FILE_TYPE)fileType
{
    NSString *name = self.file.fileName;
    if ([name hasSuffix:@".jpg"] || [name hasSuffix:@".JPG"] || [name hasSuffix:@".png"] || [name hasSuffix:@".PNG"]|| [name hasSuffix:@".gif"]|| [name hasSuffix:@".GIF"] || [name hasSuffix:@".jpeg"] || [name hasSuffix:@".JPEG"]) {
        return FILE_TYPE_IMAGE;
    }
    if([name hasSuffix:@".amr"] || [name hasSuffix:@".AMR"]){
        return FILE_TYPE_AUDIO;
    }
    if([name hasSuffix:@".doc"] || [name hasSuffix:@".DOC"] || [name hasSuffix:@".docx"] || [name hasSuffix:@".DOCX"]){
        return FILE_TYPE_DOC;
    }
    if([name hasSuffix:@".xls"] || [name hasSuffix:@".XLS"] || [name hasSuffix:@".xlsx"] || [name hasSuffix:@".XLSX"]){
        return FILE_TYPE_XLS;
    }
    if([name hasSuffix:@".exe"] || [name hasSuffix:@".EXE"]){
        return FILE_TYPE_EXE;
    }
    if([name hasSuffix:@".apk"] || [name hasSuffix:@".APK"]){
        return FILE_TYPE_APK;
    }
    if([name hasSuffix:@".txt"] || [name hasSuffix:@".TXT"] || [name hasSuffix:@".log"]){
        return FILE_TYPE_TXT;
    }
    if([name hasSuffix:@".mp4"]){
        return FILE_TYPE_MOVIE;
    }
    if([name hasSuffix:@".xml"] || [name hasSuffix:@".XML"] || [name hasSuffix:@".xhtml"] || [name hasSuffix:@".XHTML"] || [name hasSuffix:@".htmls"] || [name hasSuffix:@".HTMLS"] || [name hasSuffix:@".html"] || [name hasSuffix:@".HTML"] || [name hasSuffix:@".plist"] || [name hasSuffix:@".PLIST"]){
        return FILE_TYPE_XML;
    }
    if([name hasSuffix:@".pdf"] || [name hasSuffix:@".PDF"]){
        return FILE_TYPE_PDF;
    }
    if([name hasSuffix:@".bin"] || [name hasSuffix:@".BIN"]){
        return FILE_TYPE_BIN;
    }
    if([name hasSuffix:@".pptx"] || [name hasSuffix:@".ppt"] || [name hasSuffix:@".potx"] || [name hasSuffix:@".pot"]){
        return FILE_TYPE_PPT;
    }
    if([name hasSuffix:@".bat"] || [name hasSuffix:@".BAT"]){
        return FILE_TYPE_BAT;
    }
    if([name hasSuffix:@".dll"] || [name hasSuffix:@".DLL"]){
        return FILE_TYPE_DLL;
    }
    if ([name rangeOfString:@"."].location == NSNotFound) {
        return FILE_TYPE_FOLDER;
    }
    return FILE_TYPE_UNKONW;
}

- (NSString *)calcFileSize:(int64_t)size{
    int kb = 1024;
    int mb = 1024 * 1024;
    int gb = 1024 * 1024 * 1024;
    if (size < kb) {
        return [NSString stringWithFormat:@"%lldB",size];
    }else if (size <mb)
    {
        return [NSString stringWithFormat:@"%.2fkB",(double)size/kb];
    }else if (size <gb){
        return [NSString stringWithFormat:@"%.2fMB",(double)size/mb];
    }else{
        return [NSString stringWithFormat:@"%.2LfGB",(long double)size/gb];
    }
}

-(BOOL)isDownloadFile{
    if (self.appliesMediaViewMaskAsOutgoing == NO) {
        NSString *filePath = [NSString stringWithFormat:@"%@%lld/Files/%@",NSTemporaryDirectory(),MYSELF.ID,[self.file.mediaUrl lastPathComponent]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            return NO;
        }else{
            return YES;
        }
    }return YES;
}

@end
