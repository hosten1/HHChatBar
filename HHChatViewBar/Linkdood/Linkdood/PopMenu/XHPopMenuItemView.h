//
//  XHPopMenuItemView.h
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHPopMenuItem.h"

@interface XHPopMenuItemView : UITableViewCell

@property (nonatomic, strong) XHPopMenuItem *popMenuItem;

- (void)setupPopMenuItem:(XHPopMenuItem *)popMenuItem atIndexPath:(NSIndexPath *)indexPath isBottom:(BOOL)isBottom;

@end
