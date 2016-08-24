//
//  LDInputExtendView.h
//  Linkdood
//
//  Created by 熊清 on 16/7/27.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSString *VIMPhoto = @"VIMPhoto";//相册
static const NSString *VIMPhotograph = @"VIMPhotograph";//拍照
static const NSString *VIMExpression = @"VIMExpression";//表情
static const NSString *VIMAudio = @"VIMAudio";//语音
static const NSString *VIMLocation = @"VIMLocation";//位置
static const NSString *VIMCard = @"VIMCard";//名片
static const NSString *VIMFile = @"VIMFile";//文件
static const NSString *VIMDirective = @"VIMDirective";//指令
static const NSString *VIMVideo = @"VIMVideo";//音视频
static const NSString *VIMNotepad = @"VIMNotepad";//记事本
static const NSString *VIMPrivacy = @"VIMPrivacy";//群内私聊

static const NSString *VIMReceipt = @"VIMReceipt";//阅后回执
static const NSString *VIMTask = @"VIMTask";//任务
static const NSString *VIMDefer = @"VIMDefer";//延迟消息
static const NSString *VIMClear = @"VIMClear";//橡皮擦
static const NSString *VIMShake = @"VIMShake";//抖一抖


@protocol VIMInputExtendViewDelegate <NSObject>

- (void)didPressExtend:(NSInteger)index;

@end

@interface VIMInputExtendView : UIView

@property (strong,nonatomic) NSMutableArray *extends;
@property (assign,nonatomic) id<VIMInputExtendViewDelegate> delegate;

/*!
 * @method    initWithExtends
 * @descript  通过扩展功能初始化扩展面板
 * @param     extends 扩展面板包含的功能(从上述列表中选择)
 * @result    空
 */
- (instancetype)initWithExtends:(NSArray*)extends;

@end
