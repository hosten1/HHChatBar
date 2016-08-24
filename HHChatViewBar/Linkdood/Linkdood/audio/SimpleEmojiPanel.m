//
//  SimpleEmojiPanel.m
//  IM
//
//  Created by spinery on 14-8-6.
//  Copyright (c) 2014年 VRV. All rights reserved.
//

#import "SimpleEmojiPanel.h"
#import "YLGIFImage.h"
#import "YLImageView.h"
@implementation SimpleEmojiPanel

-(void)awakeFromNib
{
    _recentlyEmoji = [[NSMutableArray alloc] initWithCapacity:0];
    
    _customEmoji = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"LDDExpression"]  ofType:@"plist"]];
    NSArray *emojiArray = dataDic[@"emoji"];
    for (NSDictionary *dic in emojiArray) {
        [_customEmoji addObject:[dic allKeys][0]];
    }
    _instructionAry = [[NSMutableArray alloc] initWithObjects:@"Dynamic_Expression_01.png",@"Dynamic_Expression_02.png",@"Dynamic_Expression_03.png",@"Dynamic_Expression_04.png",@"Dynamic_Expression_05.png",@"Dynamic_Expression_06.png",@"Dynamic_Expression_07.png",@"Dynamic_Expression_08.png",@"Dynamic_Expression_09.png",@"Dynamic_Expression_10.png",@"Dynamic_Expression_11.png",@"Dynamic_Expression_12.png",@"Dynamic_Expression_13.png",@"Dynamic_Expression_14.png",@"Dynamic_Expression_15.png",@"Dynamic_Expression_16.png",@"Dynamic_Expression_17.png",@"Dynamic_Expression_18.png",@"Dynamic_Expression_19.png",@"Dynamic_Expression_20.png",@"Dynamic_Expression_21.png",@"Dynamic_Expression_22.png",@"Dynamic_Expression_23.png",@"Dynamic_Expression_24.png",@"Dynamic_Expression_25.png",@"Dynamic_Expression_26.png",@"Dynamic_Expression_27.png",@"Dynamic_Expression_28.png",@"Dynamic_Expression_29.png", nil];
    [self layoutAllEmojis];
    [self showEmojiType:(UIButton*)[self viewWithTag:EMOJI_TYPE_SYMBOL]];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

//这么做是为了解决切换表情卡顿的情况
- (void)layoutAllEmojis
{
    //系统表情
    [_sysPanel setContentOffset:(CGPoint){0,0}];
    long page = [EMOJI_ARRAY count] % 32 > 0?[EMOJI_ARRAY count] / 32 + 1:[EMOJI_ARRAY count] / 32;
    //初始化加载两页表情
    for (int i = 0; i < page; i++) {
        [self layoutEmojis:i];
    }
    
    //自定义表情
    [_panel setContentOffset:(CGPoint){0,0}];
    [self layoutCustomEmoj];
    
    //系统表情
    [_instructionPanel setContentOffset:(CGPoint){0,0}];
    [self layoutInstructionEmoj];
}

- (IBAction)showEmojiType:(UIButton*)button
{
    for (UIView *child in [self subviews]) {
        if ([child isKindOfClass:[UIButton class]]) {
            if (child.tag == EMOJI_TYPE_CUSTOM || child.tag == EMOJI_TYPE_SYMBOL || child.tag == EMOJI_TYPE_INSTRUCTION)
            {
                [child setBackgroundColor:RGBACOLOR(239, 239, 239, 1.0)];
            }
        }
    }
    [button setBackgroundColor:[UIColor clearColor]];
    [self layoutEmoji:(enum INSTRUCTION_EMOJI)button.tag];
}

- (void)layoutEmoji:(enum EMOJI_TYPE)type
{
    switch (type) {
        case EMOJI_TYPE_RECENTLY:
            _sysPanel.hidden = YES;
            _panel.hidden = YES;
            _instructionPanel.hidden = YES;
            break;
        case EMOJI_TYPE_SYMBOL:
            _sysPanel.hidden = NO;
            _panel.hidden = YES;
            _instructionPanel.hidden = YES;
            long page = [EMOJI_ARRAY count] % 32 > 0?[EMOJI_ARRAY count] / 32 + 1:[EMOJI_ARRAY count] / 32;
            [_sysPanel setContentSize:(CGSize){page * [UIScreen mainScreen].bounds.size.width,_panel.frame.size.height}];
            break;
        case EMOJI_TYPE_CUSTOM:
            _sysPanel.hidden = YES;
            _panel.hidden = NO;
            _instructionPanel.hidden = YES;
            page = _customEmoji.count/2 % 32 > 0?_customEmoji.count/2 / 32 + 1:_customEmoji.count/2 / 32;
            [_panel setContentSize:(CGSize){page * [UIScreen mainScreen].bounds.size.width,_panel.frame.size.height}];
            break;
        case EMOJI_TYPE_INSTRUCTION:
            _sysPanel.hidden = YES;
            _panel.hidden = YES;
            _instructionPanel.hidden = NO;
            page = [_instructionAry count] % 8 > 0?[_instructionAry count] / 8 + 1:[_instructionAry count] / 8;
            [_instructionPanel setContentSize:(CGSize){page * [UIScreen mainScreen].bounds.size.width,_panel.frame.size.height}];
            break;
    }
}

- (void)layoutEmojis:(int)page
{
    for (int i = page * 32; i < ((page + 1) * 32 >= [EMOJI_ARRAY count]?[EMOJI_ARRAY count]:(page + 1) * 32); i++) {
        int row = i % 32 / 8;
        int col = i % 32 % 8;
        UIButton *emoji = [UIButton buttonWithType:UIButtonTypeCustom];
        [emoji setTitle:[EMOJI_ARRAY objectAtIndex:i] forState:UIControlStateNormal];
        [emoji.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [emoji addTarget:self action:@selector(didTapIndex:) forControlEvents:UIControlEventTouchUpInside];
        float empt = ([UIScreen mainScreen].bounds.size.width - 40 * 8) / 2;
        float interval = (((page + 1) * 2) - 1) * empt;
        [emoji setFrame:(CGRect){self.frame.size.width * page + col * 40 + interval,row * 40,40,40}];
        [_sysPanel addSubview:emoji];
    }
}

- (void)layoutCustomEmoj
{
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"LDDExpression"]  ofType:@"plist"]];
    NSArray *emojiArray = dataDic[@"emoji"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in emojiArray) {
        [array addObject:[dic allValues][0]];
    }
    for (int i = 0; i < [_customEmoji count]/2; i++) {
        int row = i % 32 / 8;
        int col = i % 32 % 8;
        UIButton *emoji = [UIButton buttonWithType:UIButtonTypeCustom];
        emoji.tag = i+1;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LDDCExpression" ofType:@"bundle"];
        NSString *pathDirect = array[i*2];
        path = [path stringByAppendingFormat:@"/%@@2x.png",pathDirect];
        [emoji setImage:[UIImage imageWithContentsOfFile:path]forState:UIControlStateNormal];
        [emoji addTarget:self action:@selector(didTapDefinedEmoji:) forControlEvents:UIControlEventTouchUpInside];
        float empt = SCREEN_WIDTH - 40 * 8;
        [emoji setFrame:(CGRect){ col * 40 + empt / 2,row * 40,40,40}];
        [_panel addSubview:emoji];
    }
}

- (void)layoutInstructionEmoj
{
    NSArray *contentAry = [NSArray arrayWithObjects:@"抱抱",@"蹭蹭",@"吃饭",@"大哭",@"哼",@"加油",@"抠鼻",@"雷劈",@"亲亲",@"数钱",@"睡觉",@"无聊",@"谢谢",@"再见",@"抓狂",@"臭美",@"大笑",@"点头",@"肥家喽",@"干杯",@"挤成狗了",@"加班",@"开会啦",@"老天保佑",@"加班",@"签到",@"幸会",@"鸭梨山大",@"赞", @"鼓掌",nil];
    for (int i = 0; i < [_instructionAry count]; i++) {
        
        int plate = i / 8;
        int row = i % 8 / 4;
        int col = i % 4;
        
        ExpressionImageView *imageview = [[ExpressionImageView alloc] init];
        imageview.delegate = self;
        imageview.scrollView = self.instructionPanel;
        [imageview setFrame:(CGRect){plate * SCREEN_SIZE.width + col * (SCREEN_SIZE.width/4)+(IS_INCH_5_5?15:IS_INCH_4_7?10:5) ,row * 70 + row * 15 ,70 ,70}];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(plate * SCREEN_SIZE.width + col * (SCREEN_SIZE.width/4)+(IS_INCH_5_5?15:IS_INCH_4_7?10:5), (row+1) * 70 +row*15, imageview.size.width, 15)];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = contentAry[i];
        [_instructionPanel addSubview:label];
        
        imageview.image = [UIImage imageNamed:_instructionAry[i]];
        [imageview setTag:(i+1)];
        imageview.userInteractionEnabled = YES;
        
        [_instructionPanel addSubview:imageview];
        _instructionPanel.clipsToBounds = NO;
    }
}

- (void)didTapIndex:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fillEmoji:)]) {
        [self.delegate fillEmoji:button.titleLabel.text];
    }
}

//点击表情的事件
- (void)didTapDefinedEmoji:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fillEmoji:)]) {
        NSInteger tag = button.tag-1;
        tag = [(NSString*)([[NSUserDefaults standardUserDefaults] valueForKey:@"LANGUAGE"]) hasPrefix:@"zh-Hans"]?tag*2:tag*2+1;
        [self.delegate fillEmoji:_customEmoji[tag]];
    }
}

- (void)didTapInstruction:(UIButton*)button
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(sendInstruction: status:)]) {
        return;
    }
    [button setSelected:!button.selected];
    if(button.tag == INSTRUCTION_EMOJI_CANCEL){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"InstructionExpToast3", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelButtonTitle", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"InstructionExpToast4", nil),NSLocalizedString(@"InstructionExpToast5", nil),NSLocalizedString(@"InstructionExpToast6", nil),nil];
        [actionSheet showInView:self];
    }else{
        [self.delegate sendInstruction:(enum INSTRUCTION_EMOJI)button.tag status:button.selected];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.delegate sendInstruction:INSTRUCTION_EMOJI_CANCEL status:YES];
            break;
        case 1:
            [self.delegate sendInstruction:INSTRUCTION_EMOJI_DELTODAY status:YES];
            break;
        case 2:
            [self.delegate sendInstruction:INSTRUCTION_EMOJI_DELALL status:YES];
            break;
        default:
            break;
    }
}

#pragma mark -ExpressionClickedDelegate

-(void)didtapClicked:(NSInteger)tag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendDynamicExpression:)]) {
        [self.delegate sendDynamicExpression:tag];
        long page = [_instructionAry count] % 8 > 0?[_instructionAry count] / 8 + 1:[_instructionAry count] / 8;
        [_instructionPanel setContentSize:(CGSize){page * _instructionPanel.frame.size.width,_instructionPanel.frame.size.height}];
    }
}

-(void)didlongClicked:(ExpressionImageView *)expressImg
{
    [_instructionPanel setContentSize:(CGSize){_instructionPanel.frame.size.width,_instructionPanel.frame.size.height}];
    if (expressImg.tag >8) {
        [_instructionPanel setContentOffset:CGPointMake(_instructionPanel.frame.size.width*((expressImg.tag-1)/8), 0)];
    }else{
        [_instructionPanel setContentOffset:CGPointMake(0, 0)];
    }
    if (showExpressionView) {
        [showExpressionView removeFromSuperview];
        showExpressionView = nil;
    }
    showExpressionView = [[UIView alloc] initWithFrame:CGRectMake(expressImg.frame.origin.x-5, expressImg.frame.origin.y - 80, 80, 80)];
    showExpressionView.backgroundColor = [UIColor clearColor];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    bgView.image = [UIImage imageNamed:@"Dynamic_Expression_bg"];
    YLImageView *imageYL = [[YLImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
    NSString *contentmsg;
    if (expressImg.tag<10) {
        contentmsg = [NSString stringWithFormat:@"Dynamic_Expression_0%ld.gif",(long)expressImg.tag];
    }else{
        contentmsg = [NSString stringWithFormat:@"Dynamic_Expression_%ld.gif",(long)expressImg.tag];
    }
    
    imageYL.image = [YLGIFImage imageNamed:contentmsg];
    [showExpressionView addSubview:bgView];
    [showExpressionView addSubview:imageYL];
    [_instructionPanel addSubview:showExpressionView];
}

-(void)didmissClicked
{
    long page = [_instructionAry count] % 8 > 0?[_instructionAry count] / 8 + 1:[_instructionAry count] / 8;
    [_instructionPanel setContentSize:(CGSize){page * _instructionPanel.frame.size.width,_instructionPanel.frame.size.height}];
    [showExpressionView removeFromSuperview];
    showExpressionView = nil;
}

@end
