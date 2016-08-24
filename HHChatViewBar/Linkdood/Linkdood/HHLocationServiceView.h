//
//  HHLocationServiceView.h
//  Linkdood
//
//  Created by VRV2 on 16/5/26.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^goBackLocation)(double latitude,double longitude,NSString *address);

@interface HHLocationServiceView : UIView
/*!
 @property  latitude
 @descript  位置经度
 */
@property (assign,nonatomic) double latitude;

/*!
 @property  longitude
 @descript  位置纬度
 */
@property (assign,nonatomic) double longitude;

/*!
 @property  address
 @descript  位置对应的地名
 */
@property (strong,nonatomic) NSString *address;

@property (copy,nonatomic) goBackLocation locationBlock;

-(instancetype)initWithFrame:(CGRect)frame inView:(UIView*)containView;
//获取当前位置
- (void)getUserLocation;
@end
