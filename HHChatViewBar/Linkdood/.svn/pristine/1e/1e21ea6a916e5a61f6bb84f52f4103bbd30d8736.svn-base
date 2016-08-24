//
//  AudioRecoderPanel.h
//  Linkdood
//
//  Created by 熊清 on 16/6/24.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudioRecoderPanelDelegate <NSObject>

- (void)completeRecoder:(NSURL*)audioUrl;

@optional
- (void)startRecoder;
- (void)cancelRecoder;

@end

@interface AudioRecoderPanel : UIView

@property (strong,nonatomic) RecordAudio *recordAudio;

@property (assign,nonatomic) id<AudioRecoderPanelDelegate> delegate;

@end
