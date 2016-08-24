//
//  LDAddBlacklistTableViewController.m
//  Linkdood
//
//  Created by VRV2 on 16/5/5.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDChooseMemberController.h"
#import <MJNIndexView/MJNIndexView.h>
#import "LDChooseMemberCell.h"
#import "LDGroupListViewController.h"
#import "LDRobotListViewController.h"

@interface LDChooseMemberController ()<MJNIndexViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) LDContactListModel *contactList;
@property (strong,nonatomic) MJNIndexView *indexView;
@property(strong)UISearchDisplayController * searchController;
@property (strong,nonatomic) NSMutableArray *modelAry;
@property (weak,nonatomic) UIBarButtonItem * rightBtn;
//保存多选的值
@property(nonatomic,strong)NSMutableArray*selectIndexPaths;
@end

@implementation LDChooseMemberController
-(NSMutableArray *)selectIndexPaths{
    if (!_selectIndexPaths) {
        _selectIndexPaths = [NSMutableArray array];
    }
    return _selectIndexPaths;
}
- (void)awakeFromNib {
    [self.navigationItem setTitle:LOCALIIZED(@"Contacts")];
    [[[self.tabBarController.tabBar items] objectAtIndex:1] setTitle:LOCALIIZED(@"Contacts")];
        UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnPressedWithSure:)];
        self.rightBtn = rightBtn;
        self.navigationItem.rightBarButtonItem = rightBtn;
}

#pragma mark  --获取并标记黑名单 用户
-(void)rightBtnPressedWithSure:(id)sender{
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSIndexPath *path in self.selectIndexPaths) {
        LDContactModel *contact = (LDContactModel*)[self.contactList itemAtIndexPath:path];
        [temp addObject:contact];
    }
    
  LDBlackContactsModel* blackModel = [[LDBlackContactsModel alloc]init];
  [blackModel addContactsToBlackList:temp completion:^(NSError *error) {
      if (!error) {
          [SVProgressHUD showWithStatus:NSLocalizedString(@"加入成功", nil) maskType:SVProgressHUDMaskTypeBlack];
          [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [self.navigationController popViewControllerAnimated:YES];
              [SVProgressHUD dismiss];
          });

         
      }else{
          [SVProgressHUD showWithStatus:NSLocalizedString(@"加入失败", nil) maskType:SVProgressHUDMaskTypeBlack];
          [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              
              [SVProgressHUD dismiss];
          });
          NSLog(@"%@",error);

      }
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadIndexView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.indexView removeFromSuperview];
    self.indexView = nil;
}

- (void)loadIndexView
{
    if (!self.indexView) {
        self.indexView = [[MJNIndexView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height)];
        self.indexView.dataSource = self;
        self.indexView.font = [UIFont systemFontOfSize:13];
        self.indexView.fontColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        [self.navigationController.view addSubview:self.indexView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type !=0) {
        self.rightBtn.enabled = NO;
        self.navigationItem.rightBarButtonItem = nil;

    }
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate=self;
    self.searchBar.delegate = self;
    self.searchController.searchResultsDataSource=self;
    self.searchController.searchResultsDelegate=self;
    [self.searchController setActive:NO];
    
    _contactList = [[LDClient sharedInstance] contactListModel];
    if (_contactList.numberOfSections == 0) {
        [_contactList assembleData];
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    if(self.type == 1){
         return [_contactList numberOfSections]+1;
    }else{
         return [_contactList numberOfSections];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_modelAry count];
    }
    if(self.type == 1){
        if (section == 0) {
            return 2;
        }else{
            return [_contactList numberOfRowsInSection:section-1];

        }
    }
    return [_contactList numberOfRowsInSection:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    UILabel *header = [[UILabel alloc] initWithFrame:(CGRect){0,0,[APP_WINDOW width],30}];
    if (self.type == 1) {
        [header setText: [NSString stringWithFormat:@"   %@",[_contactList sectionIndexTitle:section-1]]];
        
    }else{
        [header setText: [NSString stringWithFormat:@"   %@",[_contactList sectionIndexTitle:section]]];
        
    }
    [header setBackgroundColor:[UIColor clearColor]];
    [header setTextColor:[UIColor grayColor]];
    [header setFont:[UIFont systemFontOfSize:14]];
    return  header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LDChooseMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDChooseMemberCell"];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"LDAddBlacklist_other"];
        LDContactModel *contact = (LDContactModel*)_modelAry[indexPath.row];
        [cell setContact:contact];
    }else{

        if (self.type == 0) {
   
            if([self.selectIndexPaths containsObject:indexPath]){//如果这个数组中有当前所点击的下标，那就标记为打钩
        
                    cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
        
                }else{
        
                    cell.accessoryType=UITableViewCellAccessoryNone;
        
                }
        
                LDContactModel *contact = (LDContactModel*)[_contactList itemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                [cell setContact:contact];
            
       
            return cell;
        
        }else{
            if (indexPath.section == 0) {
                switch (indexPath.row) {
                    case 0:
                        [cell.addBlockName setText:@"群组"];
                        [cell.addBlockAvara setImage:[UIImage imageNamed:@"GroupIcon"]];
                        break;
                    case 1:
                        [cell.addBlockName setText:@"机器人"];
                        [cell.addBlockAvara setImage:[UIImage imageNamed:@"robot"]];
                        break;
                    default:
                        break;
                }
            }else{
          
                
                LDContactModel *contact = (LDContactModel*)[_contactList itemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1]];
                [cell setContact:contact];
            }
            return cell;
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDContactModel *contact;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact = (LDContactModel*)[_modelAry objectAtIndex:indexPath.row];
    }else{
        if(self.type == 0){
            contact = (LDContactModel*)[_contactList itemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];

        }else{
            if (indexPath.section != 0) {
                contact = (LDContactModel*)[_contactList itemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]];
            }

        }
    }
    

    if (self.type == 0) {

            if([self.selectIndexPaths containsObject:indexPath]){//存在以选中的，就执行（为真就执行）把存在的移除
        
                [self.selectIndexPaths removeObject:indexPath];//把这个cell的标记移除
        
            }else{
                [self.selectIndexPaths addObject:indexPath];
            }
    
        [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationFade];//重新刷新这行
    }else{
        if (indexPath.section == 0) {
            UIStoryboard *contact = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];

            switch (indexPath.row) {
                case 0:
                {
                    LDGroupListViewController *vc = [contact instantiateViewControllerWithIdentifier:@"LDGroupListViewController"];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.FromPushWithSelectCard = YES;
                    vc.backContactBlock= ^(LDItemModel* item){
                        if (self.backContactBlock) {
                            self.backContactBlock(item);
                            [self.navigationController popViewControllerAnimated:YES];

                        } ;
                    };
                    vc.qrCodeBlock = ^(LDItemModel* item){
                        if (self.qrCodeBlock) {
                            self.qrCodeBlock(item);
                            [self.navigationController popViewControllerAnimated:YES];
                        } ;
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:{
                    LDRobotListViewController *robotVc = [contact instantiateViewControllerWithIdentifier:@"LDRobotListViewController"];
                    robotVc.hidesBottomBarWhenPushed = YES;
                    robotVc.FromPushWithSelectCard = YES;
                    robotVc.backContactBlock= ^(LDItemModel* item){
                        if (self.backContactBlock) {
                            self.backContactBlock(item);
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        } ;
                    };
                    robotVc.qrCodeBlock = ^(LDItemModel* item){
                        if (self.qrCodeBlock) {
                            self.qrCodeBlock(item);
                            [self.navigationController popViewControllerAnimated:YES];
                        } ;
                    };
                    [self.navigationController pushViewController:robotVc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            if (self.backContactBlock && self.qrCodeBlock) {
                
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"普通名片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self.backContactBlock) {
                    self.backContactBlock(contact);
                } ;
                [self.navigationController popViewControllerAnimated:YES];

            }];
            UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"二维码名片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self.qrCodeBlock) {
                    self.qrCodeBlock(contact);
                } ;
                [self.navigationController popViewControllerAnimated:YES];

            }];
            [alertController addAction:cancelAction];
            [alertController addAction:actionOne];
            [alertController addAction:actionTwo];
            [self presentViewController:alertController animated:YES completion:nil];

            }else if(self.backContactBlock){
                self.backContactBlock(contact);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    return [_contactList sectionIndexTitles];
}
- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.type == 1) {
        index++;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
}

@end
