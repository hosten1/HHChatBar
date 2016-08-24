//
//  LDFileMessageView.h
//  Linkdood
//
//  Created by yue on 7/4/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

typedef enum FILE_TYPE {
    FILE_TYPE_TXT,
    FILE_TYPE_DOC,
    FILE_TYPE_XLS,
    FILE_TYPE_PPT,
    FILE_TYPE_PDF,
    FILE_TYPE_LOG,
    FILE_TYPE_MOVIE,
    FILE_TYPE_XML,
    FILE_TYPE_AUDIO,
    FILE_TYPE_IMAGE,
    FILE_TYPE_APK,
    FILE_TYPE_EXE,
    FILE_TYPE_BIN,
    FILE_TYPE_BAT,
    FILE_TYPE_DLL,
    FILE_TYPE_FOLDER,
    FILE_TYPE_UNKONW,
} FILE_TYPE;

@interface LDFileMessageView : JSQMediaItem

@property(nonatomic,strong) LDFileMessageModel *file;

- (instancetype)initWithMessage:(LDMessageModel*)message;

@end
