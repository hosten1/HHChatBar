//
//  LDFaceToFaceViewController.m
//  Linkdood
//
//  Created by VRV2 on 16/8/8.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDFaceToFaceViewController.h"
#import "LDAddNearbyBuddyCollectionController.h"
#import "LDLocationModel.h"
#import "LDInputCodeViewController.h"

@interface LDFaceToFaceViewController ()
@property(nonatomic,strong) LDAddNearbyBuddyCollectionController *nearbyAdd;
@property(nonatomic,strong) LDInputCodeViewController *codeVc;
@property(nonatomic,strong)LDFaceToFaceModel *faceToface;
@property(nonatomic,strong)LDLocationModel *location;
@property(nonatomic,strong)CLLocation *locationCornor;
@property(nonatomic,copy)NSString *oldPwd;
@property(nonatomic,strong)LDInputCodeViewController *inputVc;
@end

@implementation LDFaceToFaceViewController
-(void)viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden =NO;
    
    self.navigationController.navigationBar.translucent = NO;
}
-(void)loadView{
    [super loadView];
    //发起近距离加好友
    WEAKSELF
    LDFaceToFaceModel *faceToface = [[LDFaceToFaceModel alloc]init];
    self.faceToface = faceToface;
    if (!self.location) {
        LDLocationModel *location = [[LDLocationModel alloc]init];
        self.location = location;
    }
    
    self.location.locationBlock = ^(BOOL suceess,LDLocationModel *locationModel ){
        if (!weakSelf.oldPwd) {
            if (suceess) {
                CLLocation *location = [[CLLocation alloc]initWithLatitude:locationModel.mLocation_X longitude:locationModel.mLocation_Y];
                weakSelf.locationCornor = location;
                if (weakSelf.isGroup) {
                    [faceToface seedGroupRoomWithLocation:location completion:^(NSError *error, NSString *password) {
                        if (!error) {
                            if (weakSelf.nearbyAdd) {
                                weakSelf.nearbyAdd.passWorld = password;
                                weakSelf.oldPwd = password;
                            }
                        }
                        
                    }];
                }else{
                    [faceToface seedBuddyRoomWithLocation:location completion:^(NSError *error, NSString *password) {
                        if (!error) {
                            if (weakSelf.nearbyAdd) {
                                weakSelf.nearbyAdd.passWorld = password;
                                weakSelf.oldPwd = password;
                            }
                        }
                    }];
                }
                
            }

        }
    };
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.isGroup) {
        self.title =NSLocalizedString(@"近距离加好友", @"");
    }else{
        self.title =NSLocalizedString(@"近距离加群", @"");
    }
    
    
    self.view.backgroundColor = [UIColor grayColor];
    
    
    UISegmentedControl *segmentView = [[UISegmentedControl alloc]initWithItems:@[@"找好友",@"匹配码"]];
    
    segmentView.bounds =CGRectMake(60,100,100, 30);
    
    self.navigationItem.titleView = segmentView;
    
    segmentView.selectedSegmentIndex =0;//选择按下标
    
    segmentView.momentary =NO;//点完以后会起来,按钮(瞬间选中离开)默认为NO
    
    segmentView.tintColor=[UIColor colorWithRed:0.455 green:0.610 blue:0.694 alpha:1.000];
    
    [segmentView addTarget:self action:@selector(handelSegementControlAction:)forControlEvents:(UIControlEventValueChanged)];
    [self handelSegementControlAction:segmentView];
}

//[dubai]点击分段控制执行相应的方法

- (void)handelSegementControlAction:(UISegmentedControl *)segment

{
    
    switch (segment.selectedSegmentIndex) {
            
        case 0:{
            if (self.nearbyAdd) {
                 [self.nearbyAdd.view removeFromSuperview];
            }
            if (self.codeVc) {
                [self.codeVc.view removeFromSuperview];
            }
            LDAddNearbyBuddyCollectionController *nearbyAdd = [[LDAddNearbyBuddyCollectionController alloc]init];
            self.nearbyAdd = nearbyAdd;
            nearbyAdd.isGroup = self.isGroup;
            nearbyAdd.faceToFace = self.faceToface;
            nearbyAdd.nc = self.navigationController;
            if (self.oldPwd) {
                nearbyAdd.passWorld = self.oldPwd;
            }

            [self.view insertSubview:nearbyAdd.view belowSubview:self.view];
            }
              break;
        case 1:{
            if (self.nearbyAdd) {
                [self.nearbyAdd.view removeFromSuperview];
            }
            if (self.codeVc) {
                [self.codeVc.view removeFromSuperview];
            }
            [self.nearbyAdd.view removeFromSuperview];
            LDInputCodeViewController *codeVc;
            if (self.locationCornor) {
                codeVc = [[LDInputCodeViewController alloc]initWithLocation:self.locationCornor];
            }else{
                codeVc = [[LDInputCodeViewController alloc]init];
            }
            self.codeVc  = codeVc;
            codeVc.isGroup = self.isGroup;
            codeVc.nc = self.navigationController;
            codeVc.faceToFaceModel = self.faceToface;
            [self.view insertSubview:codeVc.view belowSubview:self.view];
        }
             break;
        default:
            
        {
            
            
        }
            
            break;
            
    }
}
- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

@end
