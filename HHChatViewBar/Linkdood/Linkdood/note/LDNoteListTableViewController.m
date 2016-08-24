 //
//  LDNoteListTableViewController.m
//  Linkdood
//
//  Created by VRV2 on 16/8/1.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDNoteListTableViewController.h"
#import "LDEmptyMessageView.h"
#import "SimpleEmojiPanel.h"
#import "XMNPhotoPickerKit.h"
#import "PanelMapView.h"
#import "AudioRecoderPanel.h"
#import "PanelMapView.h"
#import "LDFileChooseController.h"
#import "LDNoteCell.h"
#import "LDEditNoteModelViewController.h"
#import "PhotoBroswerVC.h"

@interface LDNoteListTableViewController ()<SimpleEmojiPanelDelegate,PanelMapViewDelegate,AudioRecoderPanelDelegate,LDFileChooseControllerDelegate>{
    NSArray<XMNAssetModel *> *assetArray;
    NSInteger messageCount;
}
@property (nonatomic, strong)  SimpleEmojiPanel *simpleEmoji;
@property (nonatomic, strong)  JSQMessagesCollectionViewCell *longPressCell;
@property (nonatomic, strong)  UIButton*  noteSourcePositionBtn;
@property (nonatomic, assign)  NoteSource noteSourcePosition;
@property(nonatomic,copy)NSString *sourceString ;
@end

@implementation LDNoteListTableViewController
- (instancetype)initWithSenderTarget:(int64_t)target
{
    self = [super init];
    if (self) {
        _noteList = [[LDNoteListModel alloc]init];
        self.senderId =[NSString stringWithFormat:@"%lld",target];
        self.senderDisplayName = MYSELF.name;
//        [self queryNoteList];
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectButton setTitle:@"位置:本地" forState:normal];
    selectButton.bounds = CGRectMake(0, 0, 70, 30);
    [selectButton.layer setMasksToBounds:YES];
    [selectButton.layer setCornerRadius:6];
//    [selectButton.layer setBorderWidth:1.0f];
    [selectButton setBorder:1.0f withColor:[UIColor colorWithWhite:0.600 alpha:1.000].CGColor];
    _noteSourcePositionBtn = selectButton;
    [selectButton addTarget:self action:@selector(selectLocationOrOnlineWithNote) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    //默认所有的笔记存储在本地
    _noteSourcePosition = NOTE_SOURCE_LOCAL;
 
    IDRange idRange = [[LDClient sharedInstance] idRange:self.originId];
    if (idRange == id_range_USER) {
        _sourceString = MYSELF.name;
    }else if(idRange == id_range_GROUP){ 
       _sourceString =  [[LDClient sharedInstance]localGroup:self.originId].groupName;
    }else if(idRange == id_range_ROBOT){
        _sourceString = [[LDClient sharedInstance]localRobot:self.originId].appName;

    }
    NSLog(@"记事本内容来源：%@",_sourceString);
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeGradient];
        [self queryNoteList];

    }
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];

    //表情面板
    _simpleEmoji = [[[UINib nibWithNibName: @"SimpleEmojiPanel" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    _simpleEmoji.delegate = self;

}

-(void)queryNoteList{
    [_noteList queryNoteByBeginID:0 offset:20 flag:0 completion:^(NSError *error) {
        if (!error) {
            [self.collectionView reloadData];
            [SVProgressHUD dismiss];
        }
    }];
}
#pragma mark 解析各种数据
-(JSQMessage*)jsqMessageFrom:(LDNoteModel*)noteModel{
    
    switch (noteModel.type) {
        case NOTE_TYPE_TEXT: {
            LDNoteCell *cell = [[LDNoteCell alloc]initWithMessage:noteModel];
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",MYSELF.ID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",noteModel.lastChgTime] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                  media:cell];
        }
        case NOTE_TYPE_URL:{
           
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",MYSELF.ID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",noteModel.lastChgTime] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                   text:@"CESHI "];        }
        case NOTE_TYPE_AUDIO: {
            LDNoteCell *cell = [[LDNoteCell alloc]initWithMessage:noteModel];
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",MYSELF.ID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",noteModel.lastChgTime] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                   media:cell];
        }
        case NOTE_TYPE_IMAGE:
        {
            LDNoteCell *cell = [[LDNoteCell alloc]initWithMessage:noteModel];
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",MYSELF.ID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",noteModel.lastChgTime] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                     media:cell];
        }
        case NOTE_TYPE_VIDEO:
        {
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",MYSELF.ID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",noteModel.lastChgTime] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                   text:@"CESHI "];
        }
            
        default:
            return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",MYSELF.ID]
                                      senderDisplayName:@""
                                                   date:[[NSString stringWithFormat:@"%lld",noteModel.lastChgTime] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                                   text:@"暂未支持该类型的内容 "];
    }
    return nil;
}

#pragma mark - JSQMessages CollectionView DataSource
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LDNoteModel  * noteModel;

//    NSLog(@">>>>>>>>>>>>>>>itemAtIndexpath:item:%d.......row:%d............section:%d",[_noteList numberOfItems],indexPath.row,indexPath.section);
    noteModel = (LDNoteModel*)[_noteList itemAtIndexPath:indexPath];

    if (!noteModel) {
        return [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lld",MYSELF.ID]
                                      senderDisplayName:@""
                                        date:[[NSString stringWithFormat:@"%lld",_noteModel.lastChgTime] dateValue:@"yyyy-MM-dd" forTimeZone:nil]
                                           text:@"tedttt"];
    }
        
    
     return [self jsqMessageFrom:noteModel];

    
}
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [cell.textView setTextColor:[UIColor blackColor]];
    cell.avatarImageView.hidden = YES;
    [cell.cellBottomLabel setTextAlignment:NSTextAlignmentCenter];
    cell.cellBottomLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc]init];
    UIColor *buddleColor = [UIColor colorWithRed:200/255.0 green:220/255.0 blue:1 alpha:1];
    return [bubbleFactory incomingMessagesBubbleImageWithColor:buddleColor];
}


#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_noteList numberOfSections];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return 2;
    return [_noteList numberOfRowsInSection:section];
}

#pragma mark - Responding to collection view tap events
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    LDNoteModel *notemodel = (LDNoteModel*)[_noteList itemAtIndexPath:indexPath];
    if (notemodel.type == NOTE_TYPE_IMAGE) {
        NSArray *visibCell = [collectionView visibleCells];
        __block NSUInteger index = -1;
        [visibCell enumerateObjectsUsingBlock:^(JSQMessagesCollectionViewCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[collectionView indexPathForCell:cell] isEqual:indexPath]) {
                *stop = YES;
            }
            if (cell.mediaView && [cell.mediaView isKindOfClass:[UIImageView class]]) {
                index += 1;
            }
        }];
        [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
            NSMutableArray *localImages = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:localImages.count];
            for (NSUInteger i = 0; i< visibCell.count; i++) {
                JSQMessagesCollectionViewCell *cell = [visibCell objectAtIndex:i];
                if (!cell.mediaView || ![cell.mediaView isKindOfClass:[UIImageView class]]) {
                    continue;
                }
                PhotoModel *pbModel=[[PhotoModel alloc] init];
                pbModel.mid = i + 1;
             
                NSArray *subViews = [cell.mediaView.subviews[0] subviews];
                UIImageView *imageView;
                for (UIView *view  in subViews) {
                    if (view.tag == 100002) {
                        imageView = (UIImageView*)view;
                    }
                }
                NSString *nameString = [[notemodel.content componentsSeparatedByString:@"/"] lastObject];
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                NSString *resoucesPath = [path stringByAppendingPathComponent:nameString];
                UIImage *image = [UIImage imageWithContentsOfFile:resoucesPath];
                pbModel.image = image;
                pbModel.image_HD_U = @"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=网络图片&pn=0&spn=0&di=140501382670&pi=&rn=1&tn=baiduimagedetail&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=1414664594%2C2171329517&os=964253411%2C3153774711&simid=3419101897%2C379450959&adpicid=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=&objurl=http%3A%2F%2Fpic.58pic.com%2F58pic%2F15%2F66%2F29%2F76Y58PICik6_1024.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bcbrtv_z%26e3Bv54AzdH3Ffitstwg2p7AzdH3F8cmmdl0m_z%26e3Bip4s&gsm=0";
                //源frame
                pbModel.sourceImageView = (UIImageView*)cell.mediaView;
                [modelsM addObject:pbModel];
            }
            return modelsM;
        }];
    }else if(notemodel.type == NOTE_TYPE_AUDIO){
         JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
         NSArray *subViews = [cell.mediaView.subviews[0] subviews];
         UIImageView *imageView;
         for (UIView *view  in subViews) {
             if (view.tag == 100001) {
                  imageView = (UIImageView*)view;
             }
         }
         if(imageView){
            [imageView setAnimationImages:@[[[UIImage imageNamed:@"AudioIncoming1"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 10) resizingMode:UIImageResizingModeTile]
                                                               ,[[UIImage imageNamed:@"AudioIncoming2"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 10) resizingMode:UIImageResizingModeTile]
                                                               ,[[UIImage imageNamed:@"AudioIncoming"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 10) resizingMode:UIImageResizingModeTile]]];
            
            [imageView setAnimationDuration:1.2];
            [imageView startAnimating];
//            NSString *nameString = [[notemodel.content componentsSeparatedByString:@"/"] lastObject];
//            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) firstObject];
//            NSString *resoucesPath = [path stringByAppendingPathComponent:nameString];
            LDAudioMessageModel *message = [[LDAudioMessageModel alloc]initWithAudio:notemodel.content];
            [message playAudio:^(bool result){
                if (result) {
                    [imageView stopAnimating];
                    
                }
            }];
 
        }
        
        
    }
    
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didLongPressMessageBubbleAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.longPressCell = cell;
    UIMenuController *sharedMenuController = [UIMenuController sharedMenuController];
    UIMenuItem *revokeItem = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteItemClicked:)];
    UIMenuItem *item = [[UIMenuItem alloc]initWithTitle:@"编辑" action:@selector(editItemClicked:)];
    [sharedMenuController setMenuItems:@[revokeItem,item]];
    [sharedMenuController setTargetRect:CGRectMake(SCREEN_WIDTH*0.2, 30, SCREEN_WIDTH, SCREEN_HEIGHT) inView:cell.messageBubbleContainerView];
    [sharedMenuController setMenuVisible:YES animated:YES];

}
#pragma mark --- UIMenuController
-(void)deleteItemClicked:(UIMenuItem*)item{
    //支持多选
    self.collectionView.allowsMultipleSelection = YES;
//    self.showMessageSelector = !self.showMessageSelector;
//    [self.inputToolbar hideExtendViewWithAnimated:YES];
//    [UIView animateWithDuration:0.2 animations:^{
//        self.inputToolbar.preferredDefaultHeight = 0;
//    } completion:^(BOOL finished) {
//        [self.inputToolbar setHidden:YES];
//        self.inputToolbar.preferredDefaultHeight = 80;
//        
//    }];
//    [self.collectionView reloadData];
    NSIndexPath *index = [self.collectionView indexPathForCell:self.longPressCell];
    [self.longPressCell setSelected:YES];
    if (index) {
        LDNoteModel *changeModel = (LDNoteModel*)[_noteList itemAtIndexPath:index];
        [self.noteList deleteNotes:@[[NSNumber numberWithLongLong:changeModel.ID]] completion:^(NSError *error) {
            if (!error) {
                if (changeModel.type == NOTE_TYPE_IMAGE) {//删除本地文件
                    NSFileManager *fileMgr =[NSFileManager defaultManager];
                    NSString *nameString = [[changeModel.content componentsSeparatedByString:@"/"] lastObject];
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                    NSString *resoucesPath = [path stringByAppendingPathComponent:nameString];
                    BOOL bRet = [fileMgr fileExistsAtPath:resoucesPath];
                    if (bRet) {
                        NSError *err;
                        [fileMgr removeItemAtPath:resoucesPath error:&err];
                    }

                }
            [self queryNoteList];
            }
        }];
    }
}
-(void)editItemClicked:(UIMenuItem*)item{
    NSIndexPath *index = [self.collectionView indexPathForCell:self.longPressCell];
//    NSArray *sub = self.longPressCell.messageBubbleContainerView.subviews;
//    if ([sub[0] isKindOfClass:[UIImageView class]]) {
//        NSLog(@"ddddddd");
//    }
    if (index) {
        LDEditNoteModelViewController * editNote = [[LDEditNoteModelViewController alloc]init];
         LDNoteModel *changeModel = (LDNoteModel*)[_noteList itemAtIndexPath:index];
         editNote.noteModel = changeModel;
         editNote.noteList = self.noteList;
         [self.navigationController pushViewController:editNote animated:YES];

    }
  }
#pragma mark - Messages view controller 消息发送
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    //发送文本消息后清空输入框
    [self.inputToolbar.contentView.textView setText:@""];
    [self.inputToolbar toggleSendButtonEnabled];
    
     WEAKSELF
    //设置标题和关键词
    [self alertViewTextFild];
    //通过 alertView回调获取 设置的头像和关键词
    self.alertCallBack = ^(NSString *title,NSString *keyWorld){
        LDNoteModel *noteModel = [LDNoteModel buildWithTitle:title content:text keyword:keyWorld type:NOTE_TYPE_TEXT sourceType:weakSelf.noteSourcePosition];
        
        [weakSelf.noteList addNote:noteModel completion:^(NSError *error) {
            if (!error) {
                NSLog(@"存储成功");
              [weakSelf queryNoteList];
            [weakSelf.inputToolbar toggleSendButtonEnabled];
                
            }
        }];

    };
   }

- (void)didPressPhotoButton:(UIButton *)sender
{
    
    //1. 推荐使用XMNPhotoPicker 的单例
    //2. 设置选择完照片的block回调
    WEAKSELF
    [[XMNPhotoPicker sharePhotoPicker] setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
        if (!assets) {
            for (UIImage *image in images) {
                LDImageMessageModel *message = [[LDImageMessageModel alloc] initWithImage:image];
                [message setFileName:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] *1000]];
                LDNoteModel *noteModel = [LDNoteModel buildWithTitle:@"测试笔记" content:message.thumbUrl keyword:@"测试" type:NOTE_TYPE_IMAGE sourceType:weakSelf.noteSourcePosition];
                [weakSelf.noteList addNote:noteModel completion:^(NSError *error) {
                    if (!error) {
                        NSLog(@"存储成功");
                        [weakSelf queryNoteList];
                    }
                }];

            }
            return ;
        }
        assetArray = [assets copy];
        for (XMNAssetModel *assetModel in assetArray) {
//            PHAsset *asset = assetModel.asset;
            UIImage *pickerImage = [assetModel originImage];
//            LDImageMessageModel *message = [[LDImageMessageModel alloc] initWithImage:pickerImage];
//            [message setFileName:[asset valueWithProperty:@"filename"]];
            NSString *path_document = NSHomeDirectory();
            //设置一个图片的存储路径
            NSDate *current = [NSDate date];
            NSTimeInterval timeInterval = [current timeIntervalSince1970];
            NSString *path = [NSString stringWithFormat:@"/Documents/pic_%ld.png",(long)timeInterval];
            NSString *imagePath = [path_document stringByAppendingString:path];
            //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
            [UIImagePNGRepresentation(pickerImage) writeToFile:imagePath atomically:YES];
             [self alertViewTextFild];
            self.alertCallBack = ^(NSString *title,NSString *keyWorld){
            LDNoteModel *noteModel = [LDNoteModel buildWithTitle:title content:imagePath keyword:keyWorld type:NOTE_TYPE_IMAGE sourceType:weakSelf.noteSourcePosition];
            [weakSelf.noteList addNote:noteModel completion:^(NSError *error) {
                if (!error) {
                     NSLog(@"存储成功");
                    [weakSelf queryNoteList];
                    [weakSelf.inputToolbar toggleSendButtonEnabled];
                }
            }];
        };

        }
    }];
    
    //需要指定弹出相机和相册的controller--用jsq第三方扩展显示
    [[XMNPhotoPicker sharePhotoPicker] setParentController:self];
    [self.inputToolbar showExtendView:[XMNPhotoPicker sharePhotoPicker]];
}
- (void)didPressAudioButton:(UIButton*)sender
{
    AudioRecoderPanel *audioRecoderPanel = [[[UINib nibWithNibName: @"AudioRecoderPanel" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [audioRecoderPanel setDelegate:self];
    [self.inputToolbar showExtendView:audioRecoderPanel];
}

- (void)cancelRecoder
{
    
}
#pragma mark  -- 音频消息
- (void)completeRecoder:(NSURL *)audioPath
{
    LDAudioMessageModel *message = [[LDAudioMessageModel alloc] initWithAudio:audioPath.relativeString];
    WEAKSELF
    //设置标题和关键词
    [self alertViewTextFild];
    //通过 alertView回调获取 设置的头像和关键词
    self.alertCallBack = ^(NSString *title,NSString *keyWorld){
        LDNoteModel *noteModel = [LDNoteModel buildWithTitle:title content:message.localUrl keyword:keyWorld type:NOTE_TYPE_AUDIO sourceType:weakSelf.noteSourcePosition];
        [weakSelf.noteList addNote:noteModel completion:^(NSError *error) {
            if (!error) {
                NSLog(@"存储成功");
                [weakSelf queryNoteList];
                
            }
        }];
        
    };

}
- (void)didPressExpressionButton:(UIButton *)sender
{
    [self.inputToolbar showExtendView:_simpleEmoji];
}
//表情选择
- (void)fillEmoji:(NSString*)emoji{
    [self.inputToolbar.contentView.textView setText:[self.inputToolbar.contentView.textView.text stringByAppendingString:emoji]];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.inputToolbar.contentView.textView];
    [self.inputToolbar toggleSendButtonEnabled];
}

//发送动态表情
- (void)sendDynamicExpression:(NSInteger)type{
   
    
}

- (void)didPressLocationButton:(UIButton *)sender
{
    PanelMapView *mapView = [[[UINib nibWithNibName:@"PanelMapView" bundle:nil] instantiateWithOwner:self options:nil]objectAtIndex:0];
    mapView.delegate = self;
    __weak typeof(self) mySelf = self;
    mapView.locationBlock = ^(double latitude,double longitude,NSString *address){
       
    
    
    };
    [self.inputToolbar showExtendView:mapView];
}
-(void)didPressDirectiveButton:(UIButton *)sender{
    
}

#pragma mark PanelMapView Delegate

- (void)locationButtonPressed:(id)sender{
    UIView *view = (UIView *)sender;
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [blurView setFrame:view.frame];
    [view addSubview:blurView];
    UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){0,0,SCREEN_WIDTH,50}];
    [label setText:@"位置消息发送中"];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setCenter:CGPointMake(SCREEN_WIDTH/2, 216/2)];
    [blurView addSubview:label];
}
#pragma mark LDInputExtendViewDelegate
-(void)didPressExtend:(NSInteger)index
{
    if (index == 2) {
       
        
    }
}

-(void)alertViewTextFild{
//    __block  NSMutableArray *mutArray = [NSMutableArray array];
    UIAlertController * registerAlertC = [UIAlertController alertControllerWithTitle:@"设置标题和关键词" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [registerAlertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"标题";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [registerAlertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"关键词";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [registerAlertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }]];
    
    [registerAlertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *name  = [registerAlertC.textFields objectAtIndex:0];
        UITextField *keyWorld = [registerAlertC.textFields objectAtIndex:1];
        if ([name.text isEmpty] ||[keyWorld.text isEmpty] ) {
            UIAlertController * worning1 = [UIAlertController alertControllerWithTitle:@"标题/关键词不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [worning1 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ;
            }]];
            [self presentViewController:worning1 animated:YES completion:^{
                
            }];
            
        }else{
            if (self.alertCallBack) {
                self.alertCallBack(name.text,keyWorld.text);
            }
//            [mutArray addObject:name.text];
//            [mutArray addObject:keyWorld.text];
        }
        
    }]];
    [self presentViewController:registerAlertC animated:YES completion:^{
        }];
    return ;
}
-(void)didPressMoreButton:(UIButton *)sender{
    
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(void)selectLocationOrOnlineWithNote{
   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存位置" message:@"默认为本地,取消则设置为默认值" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        _noteSourcePosition = NOTE_SOURCE_LOCAL;
       [_noteSourcePositionBtn setTitle:@"位置:本地" forState:normal];
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"服务器" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _noteSourcePosition = NOTE_SOURCE_ONLINE;
         [_noteSourcePositionBtn setTitle:@"位置:在线" forState:normal];
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"本地" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         _noteSourcePosition = NOTE_SOURCE_LOCAL;
        [_noteSourcePositionBtn setTitle:@"位置:本地" forState:normal];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
