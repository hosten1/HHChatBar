//
//  XHPopMenuItem.h
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kXHMenuTableViewWidth 128
#define kXHMenuTableViewSapcing 7

#define kXHMenuItemViewHeight 44
#define kXHMenuItemViewImageSapcing 15
#define kXHSeparatorLineImageViewHeight 0.5


@interface XHPopMenuItem : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

@end
