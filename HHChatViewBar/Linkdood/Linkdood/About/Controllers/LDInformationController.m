//
//  LDInformationController.m
//  Linkdood
//
//  Created by renxin-.- on 16/3/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDInformationController.h"
#import "LDInformationCell.h"
#import "LDPersonalChangeViewController.h"


@interface LDInformationController ()<UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myselfTableView;

@end

@implementation LDInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.myselfTableView.tableFooterView = view;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_myselfTableView reloadData];
}

#pragma mark - Table view dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        return 6;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        LDInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDMyselfImageCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LDMyselfImageCell" forIndexPath:indexPath];
        }
        [cell initCell];
        return cell;
    }else{
        LDInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDMyselfTextCell" forIndexPath:indexPath];
        [cell initCell:indexPath.section rowNum:indexPath.row];
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIActionSheet *sheet;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        }
        else{
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        }
        sheet.tag = 255;
//        [sheet showInView:self.view];
    }else if(indexPath.section == 0 && indexPath.row == 2) {
        [self performSegueWithIdentifier:@"informationToChange" sender:@"名称"];
    }else if(indexPath.section == 0 && indexPath.row == 3){
        [self performSegueWithIdentifier:@"informationToChange" sender:@"个性签名"];
    }else if(indexPath.section == 0 && indexPath.row == 4){
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        sheet.tag = 260;
        [sheet showInView:self.view];
    }else if(indexPath.section == 1 && indexPath.row == 0){
        [self performSegueWithIdentifier:@"informationToBindPhone" sender:nil];
    }else if(indexPath.section == 1 && indexPath.row == 1){
        [self performSegueWithIdentifier:@"informationToBindEmail" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LDPersonalChangeViewController *change = segue.destinationViewController;
    if ([sender isEqualToString:@"名称"]) {
        change.changeName = sender;
    }
    if ([sender isEqualToString:@"个性签名"]) {
        change.changeName = sender;
    }
}

#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                default:
                    return;
                    break;
            }
        }
        else{
            if (buttonIndex == 0) {
                return;
            }
            else{
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    if (actionSheet.tag == 260) {
        LDUserModel *selfModel = [LDClient sharedInstance].mySelfInfo;
        switch (buttonIndex) {
            case 0:
                if ([LDClient sharedInstance].mySelfInfo.sex != 1) {
                    selfModel.sex = 1;
                    [self setMySelf:selfModel];
                }
                break;
            case 1:
                if ([LDClient sharedInstance].mySelfInfo.sex != 2) {
                    selfModel.sex = 2;
                    [self setMySelf:selfModel];
                }
                break;
            default:
                return;
                break;
        }
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    CGSize size = CGSizeMake(10.0f, 10.0f);
    UIImage *thumbnail = [self thumbnailWithImageWithoutScale:image size:size];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_%@.jpg", timeString]];   // 保存文件的名称
    [UIImagePNGRepresentation(image)writeToFile: filePath    atomically:YES];
    NSString *filePath1 = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic1_%@.jpg", timeString]];   // 保存文件的名称
    [UIImagePNGRepresentation(thumbnail)writeToFile: filePath1    atomically:YES];
    
//    NSMutableDictionary *path = [[NSMutableDictionary alloc]init];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_%d.png", conut_]];   // 保存文件的名称
//    
//    [path setObject:filePath forKey:@"img"];
//    [specialArr addObject:info];
    LDUserModel *selfModel = [[LDUserModel alloc] initWithUserID:[LDClient sharedInstance].mySelfInfo.ID];
    selfModel.avatar = filePath1;
    selfModel.srcAvatar = filePath;
    [[LDRegisterListener createListerner] sendRequestToSDK:cmd_setHeadImg postData:selfModel completion:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myselfTableView reloadData];
            [SVProgressHUD dismiss];
        });
    }];
    
    
}

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        }
        
        else{
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    
    return newimage;
}

- (void)setMySelf:(LDUserModel*)mySelf
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"修改中...", nil) maskType:SVProgressHUDMaskTypeClear];
    [[LDRegisterListener createListerner] sendRequestToSDK:cmd_setMyself postData:mySelf completion:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myselfTableView reloadData];
            [SVProgressHUD dismiss];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
