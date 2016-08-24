//
//  UIImage+RoundedRectImage.h
//  Linkdood
//
//  Created by renxin on 16/6/27.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedRectImage)
 + (UIImage *)createRoundedRectImage:(UIImage *)image withSize:(CGSize)size withRadius:(NSInteger)radius;
@end
