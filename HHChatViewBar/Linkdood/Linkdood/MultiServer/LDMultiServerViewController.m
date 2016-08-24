//
//  LDMultiServerViewController.m
//  Linkdood
//
//  Created by 熊清 on 16/8/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDMultiServerViewController.h"
#import "LDMultiServerViewCell.h"
#import "AppDelegate.h"

@interface LDMultiServerViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,LDMultiServerViewCellDelegate>{
    IBOutlet UITableView *multiServerTable;
}

@end

@implementation LDMultiServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"绑定的子账号列表"];
    
    [multiServerTable registerNib:[UINib nibWithNibName:@"LDMultiServerViewCell" bundle:nil] forCellReuseIdentifier:@"LDMultiServerViewCell"];
    
    UIButton *button = [NSString createGoBackButton:@"addItemButton"];
    [button addTarget:self action:@selector(addMultiServer) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *back = [NSString createGoBackButton:@"goback"];
    [back addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
}

- (void)dismissViewController{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addMultiServer
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"子账号登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        textField.placeholder = @"请输入地区码";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        textField.placeholder = @"请输入服务器";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        textField.placeholder = @"请输入手机号";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        textField.placeholder = @"请输入密码";
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *region = [alert.textFields objectAtIndex:0].text;
        NSString *domain = [alert.textFields objectAtIndex:1].text;
        NSString *phone = [alert.textFields objectAtIndex:2].text;
        NSString *password = [alert.textFields objectAtIndex:3].text;
        if (region.length == 0 || domain.length == 0 || phone.length == 0 || password.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入完整信息" maskType:SVProgressHUDMaskTypeGradient];
            return;
        }
        LDMultiServerModel *multiServer = [[LDMultiServerModel alloc] initWithCachePath:@"multiServer"];
        [multiServer loginWithAccount:[alert.textFields objectAtIndex:2].text password:[alert.textFields objectAtIndex:3].text loginType:user_type_phone region:[alert.textFields objectAtIndex:0].text domain:[alert.textFields objectAtIndex:1].text completion:^(NSError *error) {
            if (!error) {
                [multiServerTable reloadData];
            }
        }];
        objc_setAssociatedObject(self, "multiServer", multiServer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [LDClient sharedInstance].multiServerInfo.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDMultiServerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDMultiServerViewCell"];
    [cell setDelegate:self];
    [cell setMultiServer:[[LDClient sharedInstance].multiServerInfo objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LDMultiServerViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LDMultiServerModel *multiServer = [[LDClient sharedInstance].multiServerInfo objectAtIndex:indexPath.row];
    if (multiServer.isOnline) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更多选项" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"解除绑定" otherButtonTitles:@"退出登录", nil];
        [actionSheet showInView:self.view];
        objc_setAssociatedObject(actionSheet, "multiServer", cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更多选项" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"解除绑定" otherButtonTitles:@"通过密码登录", nil];
        [actionSheet showInView:self.view];
        objc_setAssociatedObject(actionSheet, "multiServer", cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    LDMultiServerViewCell *cell = objc_getAssociatedObject(actionSheet, "multiServer");
    LDMultiServerModel *multiServer;
    if (cell) {
        NSIndexPath *indexPath = [multiServerTable indexPathForCell:cell];
        multiServer = [[LDClient sharedInstance].multiServerInfo objectAtIndex:indexPath.row];
    }
    if (buttonIndex == 0) {
        [[LDClient sharedInstance] unbindMultiServer:multiServer completion:^(bool success) {
            if (success) {
                [multiServerTable reloadData];
            }
        }];
    }
    if (buttonIndex == 1) {
        if (multiServer.isOnline) {
            [cell exitLogin:^(bool success) {
                if (success) {
                    [multiServerTable reloadData];
                }
            }];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                [textField setBorderStyle:UITextBorderStyleRoundedRect];
                textField.text = [NSString stringWithFormat:@"服务器:%@",multiServer.address];
                textField.enabled = NO;
            }];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                [textField setBorderStyle:UITextBorderStyleRoundedRect];
                textField.text = [NSString stringWithFormat:@"账号:%@",[multiServer.loginAccount substringToIndex:4]];
                textField.enabled = NO;
            }];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                [textField setBorderStyle:UITextBorderStyleRoundedRect];
                textField.placeholder = @"请输入账号密码";
            }];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *password = [alert.textFields objectAtIndex:2].text;
                if (password == nil || password.length == 0) {
                    [SVProgressHUD showErrorWithStatus:@"请输入账号密码" maskType:SVProgressHUDMaskTypeGradient];
                    return;
                }
                [cell loginWithPassword:[alert.textFields objectAtIndex:2].text];
            }]];
            
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark LDMultiServerViewCellDelegate
- (void)switchMultiServer:(LDMultiServerModel *)multiServer
{
    [[LDClient sharedInstance] switchMultiServer:multiServer];
    [(AppDelegate*)SYS_DELEGATE loginSuccess];
}

@end
