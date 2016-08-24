//
//  PBSaveBtn.m
//  CorePhotoBroswerVC
//
//  Created by 冯成林 on 15/5/7.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "PBSaveBtn.h"

@implementation PBSaveBtn

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //视图准备
        [self viewPrepare];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        //视图准备
        [self viewPrepare];
    }
    
    return self;
}

/*
 *  视图准备
 */
-(void)viewPrepare{
    if (self.tag == 1000) {
        [self setImage:[UIImage imageNamed:@"PB.bundle/preview_save_icon"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"PB.bundle/preview_save_icon_highlighted"] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"PB.bundle/preview_save_icon_disable"] forState:UIControlStateDisabled];
    }
    if (self.tag == 1001) {
        [self setImage:[UIImage imageNamed:@"PB.bundle/preview_scan_icon"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"PB.bundle/preview_scan_icon_highlighted"] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"PB.bundle/preview_scan_icon_disable"] forState:UIControlStateDisabled];
    }
}

@end
