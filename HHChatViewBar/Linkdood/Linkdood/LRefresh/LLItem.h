//
//  LLItem.h
//  Demo
//
//  Created by 李乐 on 16/7/11.
//  Copyright © 2016年 beixinyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LLItem : NSObject
// item的名字
@property (copy, nonatomic) NSString *itemName;
// 正常状态下的图片名称
@property (copy, nonatomic) UIImage *normalImage;
// 选中状态下的图片名称
@property (copy, nonatomic) UIImage *selectedImage;

- (instancetype)initWithTitle:(NSString*)title nomal:(UIImage*)nomalImage selected:(UIImage*)selectedImage;

+ (instancetype)itemWithTitle:(NSString*)title nomal:(UIImage*)nomalImage selected:(UIImage*)selectedImage;

@end
