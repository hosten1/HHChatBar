//
//  VIMInputExtendViewCell.m
//  Linkdood
//
//  Created by 熊清 on 16/7/29.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "VIMInputExtendViewCell.h"

@interface VIMInputExtendViewCell()

@property (strong,nonatomic) IBOutlet UIImageView *extendImage;

@end

@implementation VIMInputExtendViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configExtendIcon:(NSString*)extend
{
    [_extendImage setImage:[UIImage imageNamed:extend]];
    [_extendImage setHighlightedImage:[[UIImage imageNamed:extend] imageMaskedWithColor:RGBACOLOR(255, 255, 255, 0.5)]];
}

@end
