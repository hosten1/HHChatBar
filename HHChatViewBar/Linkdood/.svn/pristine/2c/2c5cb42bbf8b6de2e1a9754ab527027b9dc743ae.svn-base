//
//  LDContactViewController.m
//  Linkdood
//
//  Created by xiong qing on 16/2/19.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDContactViewController.h"
#import "LDSingleChatViewController.h"
#import "LDGroupListViewController.h"
#import "LDRobotListViewController.h"
#import "LLView.h"
#import "LDOrganizationHeaderView.h"
#import "LDOrganizationCell.h"

typedef enum : NSInteger {
    show_type_contact = 1000,
    show_type_organization = 1001,
} show_type;

@interface LDContactViewController ()<MJNIndexViewDataSource,LLViewDelegate,LDOrganizationHeaderDelegate,UISearchDisplayDelegate,UISearchBarDelegate>

//显示联系人相关
@property (strong,nonatomic) LDContactListModel *contactList;
@property (strong,nonatomic) MJNIndexView *indexView;
@property (strong,nonatomic) LLView *refreshView;
@property (assign,nonatomic) NSInteger childMenu;//联系人以外的子节点,比如群组、服务号

//显示数据模块0-联系人,1-组织架构
@property (assign,nonatomic) show_type showType;
@property (strong,nonatomic) LDOrganizationContactListModel *orgList;
@property (strong,nonatomic) LDOrganizationModel *currentOrg;
@property (strong,nonatomic) LDOrganizationHeaderView *orgHeader;

//搜索相关
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong)UISearchDisplayController * searchController;
@property (strong,nonatomic) NSMutableArray *modelAry;

@end

@implementation LDContactViewController

- (void)awakeFromNib {
    [self.navigationItem setTitle:LOCALIIZED(@"Contacts")];
    [self.navigationController.tabBarItem setTitle:LOCALIIZED(@"Contacts")];
}

- (void)viewDidLoad
{
    //自定义搜索框按钮
    [_searchBar setImage:[UIImage imageNamed:@"Contact_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    //计算子menu个数
    _childMenu = 0;
    if ([LDClient sharedInstance].groupListModel.allItems.count > 0) {
        _childMenu += 1;
    }
    if ([LDClient sharedInstance].robotListModel.allItems.count > 0) {
        _childMenu += 1;
    }
    
    //显示联系人数据
    _showType = show_type_contact;
    [self refreshContactData];
    
    //监听联系人数据刷新
    [[LDNotify sharedInstance] contactListMoniter:^(LDContactListModel *contactList) {
        [self refreshContactData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //如果存在组织架构则添加下拉切换控件
    self.orgList = [LDClient sharedInstance].organizationList;
    if ([_orgList allItems].count > 0) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //强引用组织架构列表对象
            self.currentOrg = [_orgList allItems][0];
            //初始化组织架构头试图
            if (!_orgHeader) {
                self.orgHeader = [[[UINib nibWithNibName:@"LDOrganizationHeaderView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
                [_orgHeader setDelegate:self];
                [_orgHeader setBorder:0.5 withColor:[UIColor lightGrayColor].CGColor];
            }
            //初始化下拉刷新试图
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
            [items addObject:[[LLItem alloc] initWithTitle:@"" nomal:[UIImage imageNamed:@"Contact_refresh"] selected:[[UIImage imageNamed:@"Contact_refresh"] imageMaskedWithColor:RGBACOLOR(0, 160, 190, 1.0)]]];
            [items addObject:[[LLItem alloc] initWithTitle:@"" nomal:[UIImage imageNamed:@"Organization_refresh"] selected:[[UIImage imageNamed:@"Organization_refresh"] imageMaskedWithColor:RGBACOLOR(0, 160, 190, 1.0)]]];
            self.refreshView = [[LLView alloc] initWithTableView:self.tableView items:items target:self];
            [_refreshView setDelegate:self];
        });
    }
    if (_showType == show_type_contact) {
        if (_searchController.active) {
            self.tabBarController.tabBar.hidden = YES;
            return;
        }
        [self loadIndexView];
    }
}

- (void)loadIndexView
{
    if (!self.indexView) {
        self.indexView = [[MJNIndexView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height)];
        self.indexView.dataSource = self;
        self.indexView.font = [UIFont systemFontOfSize:13];
        self.indexView.fontColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    }
    [self.navigationController.view addSubview:self.indexView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.indexView removeFromSuperview];
    self.indexView = nil;
    
}

//刷新联系人数据
- (void)refreshContactData
{
    if (_showType == show_type_contact) {
        //调整界面
        [self.navigationItem setTitle:LOCALIIZED(@"Contacts")];
        [self.navigationController.tabBarItem setTitle:LOCALIIZED(@"Contacts")];
        [self.navigationController.tabBarItem setImage:[UIImage imageNamed:@"Contact"]];
        [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"Contact"]];
        
        //搜索controller
        if (!self.searchController) {
            self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
            self.searchController.delegate=self;
            self.searchController.searchResultsDataSource=self;
            self.searchController.searchResultsDelegate=self;
        }
        
        //刷新数据
        self.contactList = [LDClient sharedInstance].contactListModel;
        if (self.contactList.numberOfSections == 0) {
            [self.contactList assembleData];
        }
        if (_orgHeader) {
            [_orgHeader clearOrganization];
        }
        [self.tableView reloadData];
        [self loadIndexView];
        [self.indexView refreshIndexItems];
    }
    if (_showType == show_type_organization) {
        [self.navigationItem setTitle:LOCALIIZED(@"Organization")];
        [self.navigationController.tabBarItem setTitle:LOCALIIZED(@"Organization")];
        [self.navigationController.tabBarItem setImage:[UIImage imageNamed:@"Organization"]];
        [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"Organization"]];
        if (_orgHeader && _currentOrg) {
            [_orgHeader refreshOrganization:_currentOrg];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    if (_showType == show_type_contact) {
        if (_childMenu > 0) {
            return [_contactList numberOfSections] + 1;
        }
        return [_contactList numberOfSections];
    }
    return [_orgList numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_modelAry count];
    }
    if (_showType == show_type_contact) {
        if (_childMenu > 0) {
            if (section == 0) {
                return _childMenu;
            }
            return [_contactList numberOfRowsInSection:section - 1];
        }
        return [_contactList numberOfRowsInSection:section];
    }
    return [_orgList numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return CGFLOAT_MIN;
    }
    if (_showType == show_type_contact) {
        if (_childMenu > 0) {
            if (section == 0) {
                return CGFLOAT_MIN;
            }
            return 20;
        }
        return 20;
    }
    return section == 0?35:CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    if (_showType == show_type_contact) {
        UILabel *header = [[UILabel alloc] initWithFrame:(CGRect){0,0,[APP_WINDOW width],30}];
        [header setBackgroundColor:[UIColor clearColor]];
        [header setTextColor:[UIColor grayColor]];
        [header setFont:[UIFont systemFontOfSize:14]];
        if (_childMenu > 0) {
            if (section == 0) {
                return nil;
            }
            [header setText: [NSString stringWithFormat:@"   %@",[_contactList sectionIndexTitle:section - 1]]];
            return  header;
        }
        [header setText: [NSString stringWithFormat:@"   %@",[_contactList sectionIndexTitle:section]]];
        return  header;
    }
    if (section == 0) {
        if (!_orgHeader) {
            self.orgHeader = [[[UINib nibWithNibName:@"LDOrganizationHeaderView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
            [_orgHeader setDelegate:self];
            [_orgHeader setBorder:0.5 withColor:[UIColor lightGrayColor].CGColor];
        }
        return _orgHeader;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return CGFLOAT_MIN;
    }
    if (_showType == show_type_contact) {
        return section == tableView.numberOfSections - 1?40:0;
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    if (_showType == show_type_contact) {
        if (section == tableView.numberOfSections - 1) {
            UILabel *footer = [[UILabel alloc] initWithFrame:(CGRect){0,0,[APP_WINDOW width],40}];
            [footer setText:[NSString stringWithFormat:@"%ld位联系人",(long)[_contactList numberOfItems]]];
            [footer setBackgroundColor:[UIColor whiteColor]];
            [footer setTextColor:[UIColor grayColor]];
            [footer setTextAlignment:NSTextAlignmentCenter];
            return  footer;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        LDContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LDContactCell"];
        LDUserModel *user = (LDUserModel*)_modelAry[indexPath.row];
        [cell setUser:user];
        return cell;
    }
    if (_showType == show_type_contact) {
        LDContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDContactCell"];
        if (_childMenu > 0) {
            if (indexPath.section == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"LDContactCell_other"];
                switch (indexPath.row) {
                    case 0:
                        if ([LDClient sharedInstance].groupListModel.allItems.count > 0) {
                            [cell.nickname setText:@"群组"];
                            [cell.portrait setImage:[UIImage imageNamed:@"GroupIcon"]];
                        }else{
                            [cell.nickname setText:@"服务号"];
                            [cell.portrait setImage:[UIImage imageNamed:@"robot"]];
                        }
                        break;
                    case 1:
                        [cell.nickname setText:@"服务号"];
                        [cell.portrait setImage:[UIImage imageNamed:@"robot"]];
                        break;
                }
                return cell;
            }
            LDContactModel *contact = (LDContactModel*)[_contactList itemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1]];
            [cell setContact:contact];
            return cell;
        }
        LDContactModel *contact = (LDContactModel*)[_contactList itemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        [cell setContact:contact];
        return cell;
    }
    LDOrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDOrganizationCell"];
    if (indexPath.section == 0) {
        [cell initCellUser:(LDEntpriseUserModel*)[_orgList itemAtIndexPath:indexPath]];
    }
    if (indexPath.section == 1) {
        [cell initCellOrg:(LDOrganizationModel*)[_orgList itemAtIndexPath:indexPath]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        LDUserModel *user = [_modelAry objectAtIndex:indexPath.row];
        LDContactModel *contact = [[LDClient sharedInstance] localContact:user.ID];
        LDSingleChatViewController *chatView = [[LDSingleChatViewController alloc] initWithTarget:contact.ID];
        [chatView setSenderDisplayName:contact.name];
        chatView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatView animated:YES];
        return;
    }
    if (_showType == show_type_contact) {
        if (_childMenu > 0) {
            if (indexPath.section == 0) {
                UIStoryboard *contact = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
                switch (indexPath.row) {
                    case 0:
                        if ([LDClient sharedInstance].groupListModel.allItems.count > 0) {
                            LDGroupListViewController *vc = [contact instantiateViewControllerWithIdentifier:@"LDGroupListViewController"];
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            LDRobotListViewController *vc = [contact instantiateViewControllerWithIdentifier:@"LDRobotListViewController"];
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        break;
                    case 1:{
                        LDRobotListViewController *vc = [contact instantiateViewControllerWithIdentifier:@"LDRobotListViewController"];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                return;
            }
            LDContactModel *contact = (LDContactModel*)[_contactList itemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1]];
            LDSingleChatViewController *chatView = [[LDSingleChatViewController alloc] initWithTarget:contact.ID];
            [chatView setSenderDisplayName:contact.name];
            chatView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatView animated:YES];
            return;
        }
        LDContactModel *contact = (LDContactModel*)[_contactList itemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        LDSingleChatViewController *chatView = [[LDSingleChatViewController alloc] initWithTarget:contact.ID];
        [chatView setSenderDisplayName:contact.name];
        chatView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatView animated:YES];
        return;
    }
    if (indexPath.section == 1) {
        LDOrganizationModel *org = (LDOrganizationModel*)[_orgList itemAtIndexPath:indexPath];
        [_orgHeader refreshOrganization:org];
    }
}

#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    if (_showType == show_type_contact) {
        return [_contactList sectionIndexTitles];
    }
    return nil;
}
- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index +1] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
}

#pragma mark SearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchController setActive:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        [self loadIndexView];
        [self.indexView refreshIndexItems];
        [_modelAry removeAllObjects];
        [self.searchDisplayController.searchResultsTableView reloadData];
        return;
    }
    if (searchText.length > 0) {
        [self.indexView removeFromSuperview];
        self.indexView = nil;
    }
    [[LDClient sharedInstance].contactListModel contactsWithKey:searchText.length == 0?@"":searchText onArea:search_area_inside forType:search_type_user_local completion:^(NSError *error, NSDictionary *info) {
        if (!error) {
            if (!_modelAry) {
                _modelAry = [[NSMutableArray alloc] initWithArray:[info objectForKey:@"users"]];
            }else{
                [_modelAry removeAllObjects];
                [_modelAry addObjectsFromArray:[info objectForKey:@"users"]];
            }
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.tabBarController.tabBar.hidden = NO;
    [self loadIndexView];
    [self.indexView refreshIndexItems];
    [self.searchController setActive:NO animated:YES];
}

#pragma mark - scroll view delegate method
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView viewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshView viewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_refreshView scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - LLViewDelegate
- (void)refreshTableDataWithIndex:(NSInteger)seletedIndex
{
    _showType = seletedIndex + 1000;
    [self refreshContactData];
}

#pragma mark - LDOrganizationHeaderDelegate
- (void)loadChildWith:(LDOrganizationModel*)organization
{
    [_orgList queryOrganizationContent:organization completion:^(NSError *error) {
        [self.tableView reloadData];
        [self.indexView removeFromSuperview];
        self.indexView = nil;
    }];
}

@end
