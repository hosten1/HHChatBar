//
//  IMNew
//
//  Created by VRV on 15/11/26.
//  Copyright © 2015年 VRV. All rights reserved.
//

#import "LDSearchCell.h"

@implementation LDSearchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)sweapView
{
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2-15, 30, 30)];
    iconImage.image = [UIImage imageNamed:@"CONTACTS_QCODE"];
    iconImage.layer.cornerRadius = iconImage.frame.size.width/2;
    iconImage.layer.masksToBounds = YES;
    [self.contentView addSubview:iconImage];
    
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 15)];
    nameLb.backgroundColor = [UIColor clearColor];
    nameLb.font = [UIFont systemFontOfSize:14];
    nameLb.text = NSLocalizedString(@"扫一扫", @"");
    nameLb.textColor = RGBACOLOR(51, 51, 51, 1);
    [self.contentView addSubview:nameLb];
    
    UILabel *nameLbDetail = [[UILabel alloc] initWithFrame:CGRectMake(50, 28, 200, 14)];
    nameLbDetail.backgroundColor = [UIColor clearColor];
    nameLbDetail.font = [UIFont systemFontOfSize:12];
    nameLbDetail.text = NSLocalizedString(@"扫描二维码名片", @"");
    nameLbDetail.textColor = RGBACOLOR(153, 153, 153, 1);
    [self.contentView addSubview:nameLbDetail];
}

- (void)contactView
{
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2-15, 30, 30)];
    iconImage.image = [UIImage imageNamed:@"CONTACTS_PHONE"];
    iconImage.layer.cornerRadius = iconImage.frame.size.width/2;
    iconImage.layer.masksToBounds = YES;
    [self.contentView addSubview:iconImage];
    
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 15)];
    nameLb.backgroundColor = [UIColor clearColor];
    nameLb.font = [UIFont systemFontOfSize:14];
    nameLb.text = NSLocalizedString(@"手机联系人", @"");
    nameLb.textColor = RGBACOLOR(51, 51, 51, 1);
    [self.contentView addSubview:nameLb];
    
    UILabel *nameLbDetail = [[UILabel alloc] initWithFrame:CGRectMake(50, 28, 200, 15)];
    nameLbDetail.backgroundColor = [UIColor clearColor];
    nameLbDetail.font = [UIFont systemFontOfSize:12];
    nameLbDetail.text = NSLocalizedString(@"添加或邀请通讯录中的好友", @"");
    nameLbDetail.textColor = RGBACOLOR(153, 153, 153, 1);
    [self.contentView addSubview:nameLbDetail];
}

- (void)faceToFaceSingelView
{
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2-15, 30, 30)];
    iconImage.image = [UIImage imageNamed:@"content_faceToFace"];
    iconImage.layer.cornerRadius = iconImage.frame.size.width/2;
    iconImage.layer.masksToBounds = YES;
    iconImage.backgroundColor = [UIColor colorWithRed:0.272 green:0.773 blue:1.000 alpha:1.000];
    [self.contentView addSubview:iconImage];
    
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 15)];
    
    nameLb.font = [UIFont systemFontOfSize:14];
    nameLb.text = NSLocalizedString(@"近距离添加", @"");
    nameLb.textColor = RGBACOLOR(51, 51, 51, 1);
    [self.contentView addSubview:nameLb];
    
    UILabel *nameLbDetail = [[UILabel alloc] initWithFrame:CGRectMake(50, 28, 200, 15)];
    nameLbDetail.backgroundColor = [UIColor clearColor];
    nameLbDetail.font = [UIFont systemFontOfSize:12];
    nameLbDetail.text = NSLocalizedString(@"近距离添加或根据匹配码添加好友", @"");
    nameLbDetail.textColor = RGBACOLOR(153, 153, 153, 1);
    [self.contentView addSubview:nameLbDetail];
}
-(void)faceToFaceGrpiopView{
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2-15, 30, 30)];
    iconImage.image = [UIImage imageNamed:@"group_faceToface"];
    iconImage.layer.cornerRadius = iconImage.frame.size.width/2;
    iconImage.layer.masksToBounds = YES;
    iconImage.backgroundColor = [UIColor colorWithRed:0.295 green:0.409 blue:1.000 alpha:1.000];
    [self.contentView addSubview:iconImage];
    
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 15)];
    
    nameLb.font = [UIFont systemFontOfSize:14];
    nameLb.text = NSLocalizedString(@"近距离添加群", @"");
    nameLb.textColor = RGBACOLOR(51, 51, 51, 1);
    [self.contentView addSubview:nameLb];
    
    UILabel *nameLbDetail = [[UILabel alloc] initWithFrame:CGRectMake(50, 28, 200, 15)];
    nameLbDetail.backgroundColor = [UIColor clearColor];
    nameLbDetail.font = [UIFont systemFontOfSize:12];
    nameLbDetail.text = NSLocalizedString(@"近距离添加或根据匹配码添加群", @"");
    nameLbDetail.textColor = RGBACOLOR(153, 153, 153, 1);
    [self.contentView addSubview:nameLbDetail];
    
}



@end
