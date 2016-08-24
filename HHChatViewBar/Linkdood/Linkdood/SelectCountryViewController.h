//
//  SelectCountryViewController.h
//  ResignDL
//
//  Created by Jackie on 15/5/19.
//  Copyright (c) 2015年 Jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCountryViewCell.h"

@protocol CountryDelegate <NSObject>

- (void)choiceCountry:(NSDictionary*)country;

@end

@interface SelectCountryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>
{
    NSMutableArray *countryFilter;//搜索过滤数据
    NSMutableArray *indexs;//索引
    NSMutableDictionary *countrys;//所有国家码数据
}

@property (weak,nonatomic) IBOutlet UITableView *countryTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) id<CountryDelegate> delegate;

@end
