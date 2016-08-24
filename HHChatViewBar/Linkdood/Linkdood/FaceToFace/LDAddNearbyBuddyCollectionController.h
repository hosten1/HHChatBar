//
//  LDAddNearbyBuddyCollectionController.h
//  Linkdood
//
//  Created by VRV2 on 16/8/8.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^fromValueBack)(int from,LDFaceToFaceModel* faceToface,int isGroup,UINavigationController* nc);
typedef void(^alertValueBack)(NSString *title);
@interface LDAddNearbyBuddyCollectionController : UICollectionViewController
@property (copy,nonatomic) NSString *passWorld;
@property (strong,nonatomic) LDFaceToFaceModel *faceToFace;
@property (copy,nonatomic) fromValueBack fromValueBlock;
@property (copy,nonatomic) alertValueBack alertCallBack;
@property (assign,nonatomic) int fromToInputCodeView;//1代表来自房间号输入后的
@property (assign,nonatomic) int isGroup;//1 标示加群房间
@property (strong,nonatomic) UINavigationController *nc;
@end
