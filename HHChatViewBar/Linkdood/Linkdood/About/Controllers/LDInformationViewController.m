//
//  Linkdood
//
//  Created by renxin-.- on 16/3/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDInformationViewController.h"
#import "LDInformationCell.h"
#import "LDPersonalChangeViewController.h"
#import "LDDatePickerView.h"
#import "LDContactHeaderView.h"
#import "SelectCountryViewController.h"


@interface LDInformationViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LDDatePickerViewDelegate,CountryDelegate,LDContactHeaderViewDelegate>{
    LDContactHeaderView *header;
    LDDatePickerView *datePick;
}

@end

@implementation LDInformationViewController

-(void)loadView
{
    [super loadView];
    
    //个人信息头部信息
    header = [[LDContactHeaderView alloc] initWithHeight:160];
    header.delegate = self;
    [self.tableView setTableHeaderView:header];
    
    //日期选择控件
    datePick = [[LDDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    datePick.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [header refreshWithMyselInfo:MYSELF];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
}

#pragma mark - Table view dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        return 5;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"基本信息";
            break;
        case 1:
            return @"联系方式";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LDMyselfTextCell" forIndexPath:indexPath];
    [cell initCell:indexPath.section rowNum:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"informationToChange" sender:@"昵称"];
    }else if(indexPath.section == 0 && indexPath.row == 1){
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",@"保密", nil];
        sheet.tag = 260;
        [sheet showInView:self.view];
    }else if(indexPath.section == 0 && indexPath.row == 2){
        NSDate *date = [[NSString stringWithFormat:@"%lld",MYSELF.birthday / 1000] dateValue:@"yyyy-MM-dd" forTimeZone:nil];
        [datePick datePickView:date];
        [self.navigationController.view addSubview:datePick];
    }else if (indexPath.section == 0 && indexPath.row == 3){
        SelectCountryViewController *selectCountry = [[SelectCountryViewController alloc] init];
        [selectCountry setDelegate:self];
        [self.navigationController pushViewController:selectCountry animated:YES];
        [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    }else if (indexPath.section == 0 && indexPath.row == 4){
        [self performSegueWithIdentifier:@"informationToChange" sender:@"个性签名"];
    }else if(indexPath.section == 1 && indexPath.row == 0){
        [self performSegueWithIdentifier:@"informationToBindPhone" sender:nil];
    }else if(indexPath.section == 1 && indexPath.row == 1){
        [self performSegueWithIdentifier:@"informationToBindEmail" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LDPersonalChangeViewController *change = segue.destinationViewController;
    if (sender) {
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
        }else{
            if (buttonIndex == actionSheet.cancelButtonIndex) {
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
        LDMyselfModel *selfModel = [[LDMyselfModel alloc] initWithID:MYSELF.ID];
        switch (buttonIndex) {
            case 0:
                selfModel.sex = 1;
                break;
            case 1:
                selfModel.sex = 2;
                break;
            case 2:
                selfModel.sex = 0;
                break;
            case 3:
                return;
        }
        [self setMySelf:selfModel];
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [[info objectForKey:@"UIImagePickerControllerEditedImage"] fixOrientation];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSString *avatar_Path = [APP_TMPPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"avatar_%f.jpg", time]];
    [UIImageJPEGRepresentation(image,0.6) writeToFile:avatar_Path atomically:YES];
    NSString *srcAvatar_Path = [APP_TMPPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"srcAvatar_%f.jpg",time]];
    [UIImageJPEGRepresentation(image,0.8) writeToFile:srcAvatar_Path atomically:YES];
    
    LDMyselfModel *selfModel = [[LDMyselfModel alloc] initWithID:MYSELF.ID];
    selfModel.avatar = avatar_Path;
    selfModel.srcAvatar = srcAvatar_Path;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"修改中...", nil) maskType:SVProgressHUDMaskTypeBlack];
    [selfModel modifyMyselfHeader:^(NSError *error, LDMyselfModel *myself) {
        [header refreshWithMyselInfo:myself];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [header statusChangeScroll:scrollView];
}

#pragma mark CountryDelegate
- (void)choiceCountry:(NSDictionary *)country
{
    LDMyselfModel *selfModel = [[LDMyselfModel alloc] initWithID:MYSELF.ID];
    selfModel.area = [[country allValues] firstObject];
    [self setMySelf:selfModel];
}

#pragma mark - LDContactHeaderViewDelegate
- (void)changePhoto
{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
}

- (void)changeDoodNum
{
    [self performSegueWithIdentifier:@"informationToChange" sender:@"豆豆号"];
}

#pragma mark - LDDatePickerViewDelegate
- (void)sureAction:(NSTimeInterval)date
{
    LDMyselfModel *selfModel = [[LDMyselfModel alloc] initWithID:MYSELF.ID];
    selfModel.birthday = date * 1000;
    [self setMySelf:selfModel];
}

- (void)setMySelf:(LDMyselfModel*)mySelf
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"修改中...", nil) maskType:SVProgressHUDMaskTypeBlack];
    [mySelf modifyMyselfBasicInfo:^(NSError *error, LDMyselfModel *myself) {
        [self.tableView reloadData];
        if (mySelf.sex != -1) {
            [header refreshWithMyselInfo:myself];
        }
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
