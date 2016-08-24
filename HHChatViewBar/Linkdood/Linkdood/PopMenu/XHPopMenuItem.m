//
//  XHPopMenuItem.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) . All rights reserved.
//

#import "XHPopMenuItem.h"

@implementation XHPopMenuItem

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [super init];
    if (self) {
        self.image = image;
        self.title = title;
    }
    return self;
}

@end
