//
//  SimpleEmojiPanel.h
//  IM
//
//  Created by spinery on 14-8-6.
//  Copyright (c) 2014年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emoji.h"
#import "ExpressionImageView.h"

typedef enum EMOJI_TYPE{
    EMOJI_TYPE_RECENTLY = 1000,
    EMOJI_TYPE_SYMBOL,
    EMOJI_TYPE_CUSTOM,
    EMOJI_TYPE_INSTRUCTION,
} EMOJI_TYPE;

typedef enum INSTRUCTION_EMOJI{
    INSTRUCTION_EMOJI_NO = -1,
    INSTRUCTION_EMOJI_DELAY = 1,
    INSTRUCTION_EMOJI_READ,
    INSTRUCTION_EMOJI_FLASH,
    INSTRUCTION_EMOJI_CANCEL,
    INSTRUCTION_EMOJI_DELTODAY,
    INSTRUCTION_EMOJI_DELALL,
    INSTRUCTION_EMOJI_TASK,
//    INSTRUCTION_EMOJI_VERSION,
//    INSTRUCTION_EMOJI_CALL,
//    INSTRUCTION_EMOJI_LOCATION,
//    INSTRUCTION_EMOJI_DEL,
//    INSTRUCTION_EMOJI_TAKEPIC,
} INSTRUCTION_EMOJI;

#define EMOJI_ARRAY  [Emoji allEmoji]// LISTFILES([[ NSBundle mainBundle] pathForResource: @"resource" ofType :@"bundle"])

@protocol SimpleEmojiPanelDelegate <NSObject>

- (void)fillEmoji:(NSString*)emoji;
- (void)sendDynamicExpression:(NSInteger)type;

@optional
- (void)sendInstruction:(INSTRUCTION_EMOJI)instruction_type status:(BOOL)isSelect;

@end

@interface SimpleEmojiPanel : UIView<UIScrollViewDelegate,UIActionSheetDelegate,ExpressionClickedDelegate>
{
    IBOutlet UIButton *customEmojiBtn,*sysEmojiBtn,*instructionBtn;
    UIView *showExpressionView;
}

@property (weak,nonatomic) IBOutlet UIScrollView *panel;
@property (weak,nonatomic) IBOutlet UIScrollView *sysPanel;
@property (weak,nonatomic) IBOutlet UIScrollView *instructionPanel;
@property (assign,nonatomic) id<SimpleEmojiPanelDelegate> delegate;
@property (strong,nonatomic) NSMutableArray *recentlyEmoji;
@property (strong,nonatomic) NSMutableArray *customEmoji;
@property (strong,nonatomic) NSMutableArray *instructionAry;

@end
