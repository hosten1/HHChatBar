//
//  LegendFileChooseController.h
//  IM
//
//  Created by liuxinbo on 14-8-19.
//  Copyright (c) 2014年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDFileChooseControllerDelegate <NSObject>

@optional
-(void) sendFile:(NSString *)path;

@end

@interface LDFileChooseController : UITableViewController

//文件夹列表
@property (strong,nonatomic) NSMutableArray * files;

@property (weak,nonatomic) id<LDFileChooseControllerDelegate> delegate;
@end
