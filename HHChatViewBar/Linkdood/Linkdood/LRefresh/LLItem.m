//
//  LLItem.m
//  Demo
//
//  Created by 李乐 on 16/7/11.
//  Copyright © 2016年 beixinyuan. All rights reserved.
//

#import "LLItem.h"

@implementation LLItem

+ (instancetype)itemWithTitle:(NSString *)title nomal:(UIImage *)nomalImage selected:(UIImage *)selectedImage
{
    return [[self alloc] initWithTitle:title nomal:nomalImage selected:selectedImage];
}

- (instancetype)initWithTitle:(NSString*)title nomal:(UIImage*)nomalImage selected:(UIImage*)selectedImage
{
    if (self = [super init]) {
        self.itemName = title;
        self.normalImage = nomalImage;
        self.selectedImage = selectedImage;
    }
    return self;
}

@end
