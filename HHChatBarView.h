//
//  HHChatBarView.h
//  HHChatBar
//
//  Created by VRV2 on 16/8/19.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHChatBarView;

@protocol HHChatBarDelegate <NSObject>
@required
-(NSInteger)numberOfSectionWithchatBar:(HHChatBarView*)charBar;
-(NSString*)chatBar:(HHChatBarView*)charBar sectionTitleWithIndexPath:(NSIndexPath*)indexPath;
-(NSArray*)chatBar:(HHChatBarView *)charBar subPopViewTitleOfRowWithIndexPath:(NSIndexPath*)indexPath;
@optional
-(void)chatBar:(HHChatBarView*)charBar didSelectIndex:(NSIndexPath*)indexPath;

@end

@interface HHChatBarView : UIView
@property (copy,nonatomic) NSDictionary *resourseDictionary;
@property (assign,nonatomic) id<HHChatBarDelegate> ChatDelegate;

-(instancetype)initWithDictionary:(NSDictionary*)resourcesDic;
-(void)setupSubviewItems;
@end
