//
//  LegendOrganizationHeaderView.h
//  IM
//
//  Created by spinery on 15/6/18.
//  Copyright (c) 2015年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDOrganizationHeaderDelegate <NSObject>

- (void)loadChildWith:(LDOrganizationModel*)organization;

@end

@interface LDOrganizationHeaderView : UIView

@property (weak,nonatomic) IBOutlet UIScrollView *orgsPlate;
@property (strong,nonatomic) NSMutableArray *orgs;
@property (assign) id<LDOrganizationHeaderDelegate> delegate;
@property (assign) CGFloat plateContentX;

-(void)refreshOrganization:(LDOrganizationModel*)org;
-(void)clearOrganization;

@end
