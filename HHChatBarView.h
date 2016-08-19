//
//  HHChatBarView.h
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHChatBarView : UIView
@property (copy,nonatomic) NSDictionary *resourseDictionary;

-(instancetype)initWithDictionary:(NSDictionary*)resourcesDic;
@end
