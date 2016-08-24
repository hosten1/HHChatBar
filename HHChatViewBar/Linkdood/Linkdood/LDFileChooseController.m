//
//  LegendFileChooseController.m
//  IM
//
//  Created by liuxinbo on 14-8-19.
//  Copyright (c) 2014年 VRV. All rights reserved.
//

#import "LDFileChooseController.h"

#define USER_ROOTCACHE [NSString stringWithFormat:@"%@%lld/Files",NSTemporaryDirectory(),MYSELF.ID]

typedef enum FILE_TYPE {
    FILE_TYPE_TXT,
    FILE_TYPE_DOC,
    FILE_TYPE_XLS,
    FILE_TYPE_PPT,
    FILE_TYPE_PDF,
    FILE_TYPE_LOG,
    FILE_TYPE_MOVIE,
    FILE_TYPE_XML,
    FILE_TYPE_AUDIO,
    FILE_TYPE_IMAGE,
    FILE_TYPE_APK,
    FILE_TYPE_EXE,
    FILE_TYPE_BIN,
    FILE_TYPE_BAT,
    FILE_TYPE_DLL,
    FILE_TYPE_FOLDER,
    FILE_TYPE_UNKONW,
} FILE_TYPE;

@interface LDFileChooseController ()<UIAlertViewDelegate>
{
    NSInteger indexRow;
}

@end

@implementation LDFileChooseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发送文件";
    _files = [NSMutableArray arrayWithCapacity:0];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_ROOTCACHE error:nil];
    [_files removeAllObjects];
    [files enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",USER_ROOTCACHE,obj];
        BOOL isDir = YES;
        [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
        if (!isDir) {
            [_files addObject:filePath];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    if ([_files count] == 0) {
        return 0;
    }
    return [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_ROOTCACHE error:nil] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath{
    static NSString *identify = @"LDFileChoose";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    //文件名称
    NSString *filePath = [_files objectAtIndex:indexPath.row];
    NSDictionary *fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [cell.textLabel setText:filePath.lastPathComponent];
    
    //文件大小
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:11]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.2fM",([[fileAttr objectForKey:NSFileSize] floatValue] / 1024) / 1024]];
    
    switch ([self fileType:cell.textLabel.text]) {
        case FILE_TYPE_DOC:
        case FILE_TYPE_LOG:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_DOC"]];
            break;
        case FILE_TYPE_XLS:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_XLS"]];
            break;
        case FILE_TYPE_EXE:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_EXE"]];
            break;
        case FILE_TYPE_APK:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_APK"]];
            break;
        case FILE_TYPE_TXT:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_TXT"]];
            break;
        case FILE_TYPE_XML:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_CODE"]];
            break;
        case FILE_TYPE_IMAGE:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_ICON"]];
            break;
        case FILE_TYPE_AUDIO:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_AMR"]];
            break;
        case FILE_TYPE_PPT:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_PPT"]];
            break;
        case FILE_TYPE_PDF:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_PDF"]];
            break;
        case FILE_TYPE_BIN:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_BIN"]];
            break;
        case FILE_TYPE_BAT:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_BAT"]];
            break;
        case FILE_TYPE_DLL:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_DLL"]];
            break;
        case FILE_TYPE_FOLDER:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_FLODER"]];
            break;
        case FILE_TYPE_UNKONW:
        case FILE_TYPE_MOVIE:
            [cell.imageView setImage:[UIImage imageNamed:@"MESSAGE_TYPE_UNKNOW"]];
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *filePath = [_files objectAtIndex:indexPath.row];
    NSDictionary *fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    CGFloat fileSize = [[NSString stringWithFormat:@"%.2f",([[fileAttr objectForKey:NSFileSize] floatValue] / 1024) / 1024] floatValue];
    
    if (fileSize >= 20.00) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"暂只支持20M以下文件发送" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendFile:)]) {
            [self.delegate sendFile:filePath];
        }
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *filePath = [_files objectAtIndex:indexPath.row];
        
        NSFileManager* fileManager=[NSFileManager defaultManager];
        BOOL fileE =[[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if(!fileE){
            return;
        }else{
            BOOL resualt = [fileManager removeItemAtPath:filePath error:nil];
            if (resualt) {
                [self.tableView reloadData];
            }else {
            }
        }
        [tableView reloadData];
    }
}

- (FILE_TYPE)fileType:(NSString*)type
{
    if ([type hasSuffix:@".jpg"] || [type hasSuffix:@".JPG"] || [type hasSuffix:@".png"] || [type hasSuffix:@".PNG"]|| [type hasSuffix:@".gif"]|| [type hasSuffix:@".GIF"] || [type hasSuffix:@".jpeg"] || [type hasSuffix:@".JPEG"]) {
        return FILE_TYPE_IMAGE;
    }
    if([type hasSuffix:@".amr"] || [type hasSuffix:@".AMR"]){
        return FILE_TYPE_AUDIO;
    }
    if([type hasSuffix:@".doc"] || [type hasSuffix:@".DOC"] || [type hasSuffix:@".docx"] || [type hasSuffix:@".DOCX"]){
        return FILE_TYPE_DOC;
    }
    if([type hasSuffix:@".xls"] || [type hasSuffix:@".XLS"] || [type hasSuffix:@".xlsx"] || [type hasSuffix:@".XLSX"]){
        return FILE_TYPE_XLS;
    }
    if([type hasSuffix:@".exe"] || [type hasSuffix:@".EXE"]){
        return FILE_TYPE_EXE;
    }
    if([type hasSuffix:@".apk"] || [type hasSuffix:@".APK"]){
        return FILE_TYPE_APK;
    }
    if([type hasSuffix:@".txt"] || [type hasSuffix:@".TXT"] || [type hasSuffix:@".log"]){
        return FILE_TYPE_TXT;
    }
    if([type hasSuffix:@".mp4"]){
        return FILE_TYPE_MOVIE;
    }
    if([type hasSuffix:@".xml"] || [type hasSuffix:@".XML"] || [type hasSuffix:@".xhtml"] || [type hasSuffix:@".XHTML"] || [type hasSuffix:@".htmls"] || [type hasSuffix:@".HTMLS"] || [type hasSuffix:@".html"] || [type hasSuffix:@".HTML"] || [type hasSuffix:@".plist"] || [type hasSuffix:@".PLIST"]){
        return FILE_TYPE_XML;
    }
    if([type hasSuffix:@".pdf"] || [type hasSuffix:@".PDF"]){
        return FILE_TYPE_PDF;
    }
    if([type hasSuffix:@".bin"] || [type hasSuffix:@".BIN"]){
        return FILE_TYPE_BIN;
    }
    if([type hasSuffix:@".pptx"] || [type hasSuffix:@".ppt"] || [type hasSuffix:@".potx"] || [type hasSuffix:@".pot"]){
        return FILE_TYPE_PPT;
    }
    if([type hasSuffix:@".bat"] || [type hasSuffix:@".BAT"]){
        return FILE_TYPE_BAT;
    }
    if([type hasSuffix:@".dll"] || [type hasSuffix:@".DLL"]){
        return FILE_TYPE_DLL;
    }
    if ([type rangeOfString:@"."].location == NSNotFound) {
        return FILE_TYPE_FOLDER;
    }
    return FILE_TYPE_UNKONW;
}

@end
