//
//  LDInputCodeViewController.h
//  Linkdood
//
//  Created by VRV2 on 16/8/9.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDInputCodeViewController : UIViewController
@property (strong,nonatomic) LDFaceToFaceModel *faceToFaceModel;
@property(nonatomic,strong)CLLocation *locationCornor;
@property (strong,nonatomic) UINavigationController *nc;
@property (assign,nonatomic) int isGroup;//1 表示加群房间


-(instancetype)initWithLocation:(CLLocation*)location;
@end
