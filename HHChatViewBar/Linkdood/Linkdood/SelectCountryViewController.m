//
//  SelectCountryViewController.m
//  ResignDL
//
//  Created by Jackie on 15/5/19.
//  Copyright (c) 2015年 Jackie. All rights reserved.
//

#import "SelectCountryViewController.h"
#import <MJNIndexView/MJNIndexView.h>

@interface SelectCountryViewController ()<MJNIndexViewDataSource>

@property(strong)UISearchDisplayController * searchController;
@property(weak)  IBOutlet UISearchBar *bar;
@property (strong,nonatomic) MJNIndexView *indexView;
@end

@implementation SelectCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"国家/地区", @"")];
    self.searchBar.placeholder = NSLocalizedString(@"查找", @"");
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.bar contentsController:self];
    self.searchController.delegate=self;
    self.searchController.searchResultsDataSource=self;
    self.searchController.searchResultsDelegate=self;
    [self.searchController setActive:NO];
    [_countryTable reloadData];
    
    [_countryTable registerNib:[UINib nibWithNibName:@"SelectCountryViewCell" bundle:nil] forCellReuseIdentifier:@"forCountry"];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"SelectCountryViewCell" bundle:nil] forCellReuseIdentifier:@"forCountry"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!countrys) {
        countrys = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"加载中...", nil) maskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Countrys"]  ofType:@"plist"]];
        [dicData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *localName = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:key];
            NSLocale *countryLocal = [[NSLocale alloc] initWithLocaleIdentifier:[obj objectForKey:@"language"]];
            NSString *countryName = [countryLocal displayNameForKey:NSLocaleCountryCode value:key];
            [obj setObject:countryName forKey:@"language"];
            [self addIndex:localName.indexs];
            if (![countrys objectForKey:localName.indexs]) {
                [countrys setObject:[[NSMutableArray alloc] initWithObjects:@{localName:obj}, nil] forKey:localName.indexs];
            }else{
                [[countrys objectForKey:localName.indexs] addObject:@{localName:obj}];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            _countryTable.dataSource = self;
            _countryTable.delegate = self;
            [_countryTable reloadData];
            [self loadIndexView];
        });
    });
}

- (void)loadIndexView
{
    if (!self.indexView) {
        self.indexView = [[MJNIndexView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height)];
        self.indexView.dataSource = self;
        self.indexView.font = [UIFont systemFontOfSize:13];
        self.indexView.fontColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        [self.view addSubview:self.indexView];
    }
}

- (void)addIndex:(NSString*)index
{
    if (!indexs) {
        indexs = [[NSMutableArray alloc] initWithCapacity:0];
    }
    NSCountedSet *buddyIndex = [[NSCountedSet alloc] initWithArray:indexs];
    [buddyIndex addObject:index];
    [indexs removeAllObjects];
    [indexs addObjectsFromArray:[[buddyIndex allObjects] sortedArrayUsingSelector:@selector(compare:)]];
}

- (void)filterContentForSearchText:(NSString *)searchText
{
    if (!countryFilter) {
        countryFilter = [[NSMutableArray alloc] initWithCapacity:0];
    }else{
        [countryFilter removeAllObjects];
    }
    if ([searchText length] == 0) {
        [countryFilter addObjectsFromArray:[countrys allValues]];
        return;
    }
    for (NSArray *country1 in [countrys allValues]) {
        for (NSDictionary *country in country1) {
            [country enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
                if ([scopePredicate evaluateWithObject:key]) {
                    [countryFilter addObject:@{key:obj}];
                }
            }];
        }
    }
}

#pragma -mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    如果当前是UISearchDisplayController内部的tableView则使用搜索数据
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return [indexs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @"";
    }
    return [indexs objectAtIndex:section];
}

//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return indexs;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果当前是UISearchDisplayController内部的tableView则使用搜索数据
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return countryFilter.count;
    }
    return [[countrys objectForKey:[indexs objectAtIndex:section]] number];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCountryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forCountry"];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSDictionary *country = [countryFilter objectAtIndex:indexPath.row];
        [cell.place setText:[[country allKeys] firstObject]];
        [cell.language setText:[[[country allValues] firstObject] objectForKey:@"language"]];
        [cell.areaCode setText:[@"+" stringByAppendingString:[[[country allValues] firstObject] objectForKey:@"code"]]];
        return cell;
    }
    else
    {
        NSDictionary *country = [[countrys objectForKey:[indexs objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [cell.place setText:[[country allKeys] firstObject]];
        [cell.language setText:[[[country allValues] firstObject] objectForKey:@"language"]];
        [cell.areaCode setText:[@"+" stringByAppendingString:[[[country allValues] firstObject] objectForKey:@"code"]]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SelectCountryViewCell *countryCell = (SelectCountryViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceCountry:)]) {
        [self.delegate choiceCountry:@{countryCell.areaCode.text:countryCell.place.text}];
        if (![self.navigationController popViewControllerAnimated:YES]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return indexs;
}
- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [_countryTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
}

#pragma mark SearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchController setActive:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchTextDidChanged:searchText Block:^(bool done) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}

-(void)searchTextDidChanged:(NSString *)searchText Block:(void(^)(bool done)) block
{
    if ([searchText isEqualToString:@""]) {
        return ;
    }
    [self filterContentForSearchText:searchText];
    block(YES);
}

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString];
//    
//    return YES;
//}
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    [self filterContentForSearchText:controller.searchBar.text];
//    
//    return YES;
//}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    [self filterContentForSearchText:@""];
}

@end
