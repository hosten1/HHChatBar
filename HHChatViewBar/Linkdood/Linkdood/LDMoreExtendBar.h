//
//  LDMoreExtendBar.h
//  Linkdood
//
//  Created by yue on 7/6/16.
//  Copyright © 2016 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDMoreExtendBarDelegate <NSObject>

-(void)sendButtonPressed:(id)sender;

-(void)cancelButtonPressed:(id)sender;

@end

@interface LDMoreExtendBar : UIView

@property (weak,nonatomic) id<LDMoreExtendBarDelegate> delegate;

@end
