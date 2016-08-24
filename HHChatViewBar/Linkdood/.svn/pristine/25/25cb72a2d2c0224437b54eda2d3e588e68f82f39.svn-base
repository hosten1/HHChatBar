//
//  LDAddNearbyBuddyCollectionController.m
//  Linkdood
//
//  Created by VRV2 on 16/8/8.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDAddNearbyBuddyCollectionController.h"
#import "LDNearbyAddBuddyCollectionCell.h"
#define kBottomViewHeight  100
@interface LDAddNearbyBuddyCollectionController ()
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,assign)UILabel *titleLable;
@property(nonatomic,copy)NSMutableArray *oldUserList;
@property(nonatomic,copy)NSMutableArray *SelectUserList;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger overTime;
@end

@implementation LDAddNearbyBuddyCollectionController

static NSString * const reuseIdentifier = @"LDNearbyAddBuddyCollectionCell";
-(NSMutableArray *)oldUserList{//懒加载初始化可变数组
    if (!_oldUserList) {
        _oldUserList = [NSMutableArray array];
    }
    return _oldUserList;
}
-(NSMutableArray *)SelectUserList{
    if (!_SelectUserList) {
        _SelectUserList = [NSMutableArray array];
    }
    return _SelectUserList;
}
-(instancetype)init
{
    WEAKSELF
    self.fromValueBlock = ^(int from,LDFaceToFaceModel* faceToface,int isGroup,UINavigationController* nc){
        weakSelf.fromToInputCodeView = from;
        weakSelf.faceToFace = faceToface;
        weakSelf.isGroup = isGroup;
        weakSelf.nc = nc;
    };
    //设置流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    return [super initWithCollectionViewLayout:layout];
    
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"passWorld"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.passWorld && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //有用户退出房间
    if (self.fromToInputCodeView ==1 && self.faceToFace) {
        if (self.isGroup) {
            [self.faceToFace exitGroupRoom:^(NSError *error) {
                if (!error) {
                    [SVProgressHUD showErrorWithStatus:@"退出加群房间成功"];
                }
            }];
        }else{
            [self.faceToFace exitBuddyRoom:^(NSError *error) {
                if (!error) {
                     [SVProgressHUD showErrorWithStatus:@"退出房间成功"];
                }
            }];

        }
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置监听
    [self addObserver:self forKeyPath:@"passWorld" options:NSKeyValueObservingOptionNew context:nil];
    if (self.isGroup) {
        self.view.backgroundColor = [UIColor colorWithRed:0.295 green:0.409 blue:1.000 alpha:1.000];
    }else{
        self.view.backgroundColor = [UIColor colorWithRed:0.272 green:0.773 blue:1.000 alpha:1.000];
    }
    //开启一个定时器
    _overTime = 5;
    if (!self.passWorld) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    }
   
    [self.collectionView registerNib:[UINib nibWithNibName:@"LDNearbyAddBuddyCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView .allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    
    [self addHeaderAndBottom];
    //加载数据 用户进入/退出房间回调
    if (self.faceToFace) {
        [self loadMonitarData];
    }
    
    CGFloat topMaxY = CGRectGetMaxY(self.topView.frame);
    self.collectionView.contentInset = UIEdgeInsetsMake(-topMaxY+10, 0, 0, 0);
    self.collectionView.frame = CGRectMake(0,topMaxY, SCREEN_WIDTH, SCREEN_HEIGHT-topMaxY);

    if(self.fromToInputCodeView != 1){
        [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeGradient];
    }else{
        //发起人完成群或添加联系人的监听回调
        [self didFinishedSelectUserWithRoom];
    }
    if (self.passWorld) {
        [SVProgressHUD dismiss];
         self.titleLable.text = [NSString stringWithFormat:@"房间码：%@",self.passWorld];
    }
}
-(void)didFinishedSelectUserWithRoom{
    if (self.isGroup) {
        self.title = @"加群房间";
        if (self.faceToFace) {
            [self.faceToFace groupCreated:^(int64_t groupID) {
                if (groupID) {
                    [SVProgressHUD showSuccessWithStatus:@"发起人完成群的创建"];
                    [self.nc popViewControllerAnimated:YES];
                }
            }];
        }
    }else{
        self.title = @"加好友房间";
        if (self.faceToFace) {
            [self.faceToFace BuddyConfirmed:^(BOOL flag) {
                if (flag) {
                    [SVProgressHUD showSuccessWithStatus:@"发起人完成好友添加"];
                    [self.nc popViewControllerAnimated:YES];
                }
            }];
        }
    }

}
- (void)updateTimer:(NSTimer *)sender{
    _overTime--;
    if (_overTime == 0) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请检查你的网络和定位是否打开"];
        [self.timer invalidate];
         self.timer=nil;
    }
}
#pragma mark -- 加载初始化数据及用户进入房间监听
-(void)loadMonitarData{
    if (self.oldUserList.count > 0) {
       [self.oldUserList removeAllObjects];
    }
    if (self.SelectUserList.count > 0) {
        [self.SelectUserList removeAllObjects];
    }
    [self.oldUserList setArray:self.faceToFace.userList];
    if (self.isGroup) {
        //循环数组 防止用户重复用户进入房间
        if (self.fromToInputCodeView != 1) {
            if (self.oldUserList.count == 0) {
                 [self.oldUserList addObject:MYSELF];
            }else{
                for (NSInteger i = 0; i<self.oldUserList.count; i++) {
                    LDUserModel *user = self.oldUserList[i];
                    if (user.ID != MYSELF.ID && i == self.oldUserList.count-1) {
                        [self.oldUserList addObject:MYSELF];
                    }
                }

            }
            
        }
        [self.SelectUserList addObject:MYSELF];
    }
    if (self.oldUserList.count>0) {
        [self.collectionView reloadData];
    }
    [self.faceToFace userJoinedRoom:^(LDUserModel *user) {
        if (user) {
            //循环数组 防止用户重复用户进入房间
            for (LDUserModel *userModel in self.oldUserList) {
                if (userModel.ID == user.ID) {
                    return ;
                }
            }
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@,加入房间",user.name]];
            [self.oldUserList setArray:self.faceToFace.userList];
            if (self.isGroup) {
                [self.oldUserList insertObject:MYSELF atIndex:0];
            }
            [self.collectionView reloadData];
        }
    }];
    //有用户退出房间
    [self.faceToFace userExitedRoom:^(int64_t userID){
        if (userID != 0) {
            //获取退出房间用户的信息
            LDUserModel *user = nil;
            for (LDUserModel *userModel in self.oldUserList) {
                if (userModel.ID == userID) {
                    user = userModel;
                    break;
                }
            }
            if (userID != MYSELF.ID) {
                if (self.fromToInputCodeView == 1) {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"房主已经解散房间"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@,退出房间",user.name]];
                    [self.oldUserList removeAllObjects];
                    [self.oldUserList setArray:self.faceToFace.userList];
                    if (self.isGroup) {
                        [self.oldUserList addObject:MYSELF];
                    }
                    [self.collectionView reloadData];
                }
               
            }
            
        }
    }];
}
-(void)addHeaderAndBottom{
    /**
     顶部view
     */
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    topView.backgroundColor = [UIColor colorWithRed:0.380 green:0.668 blue:1.000 alpha:1.000];
    [self.collectionView.superview addSubview:topView];
    self.topView = topView;
    UILabel *titileLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    titileLable.text = @"房间码:";
    titileLable.textColor = [UIColor whiteColor];
    self.titleLable = titileLable;
    titileLable.textAlignment = NSTextAlignmentCenter;
    if (self.fromToInputCodeView == 1) {
        self.titleLable.hidden = YES;
    }
    [topView addSubview:titileLable];
    UILabel *codeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titileLable.frame)+10, SCREEN_WIDTH, 30)];
    if (self.fromToInputCodeView == 1) {
        codeLable.text = @"当前房间的人:";
    }else{
       codeLable.text = @"选择添加的人:";
    }
    codeLable.textColor = [UIColor colorWithRed:0.915 green:0.935 blue:0.766 alpha:1.000];
    [topView addSubview:codeLable];
    /**
     底部弹出view
     */
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kBottomViewHeight)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.380 green:0.668 blue:1.000 alpha:1.000];
    [self.collectionView.superview addSubview:bottomView];
    _bottomView = bottomView;
    if (self.fromToInputCodeView == 1) {
        bottomView.hidden = NO;
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-160, SCREEN_WIDTH, 100);
    }else{
        bottomView.hidden = YES;
    }
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.frame = CGRectMake(25, 10, bottomView.size.width*0.4, 50);
    confirmBtn.backgroundColor = [UIColor clearColor];
    confirmBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    confirmBtn.layer.borderWidth = 2;
    [bottomView addSubview:confirmBtn];
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.fromToInputCodeView == 1) {
        [cancleBtn setTitle:@"退出房间" forState:UIControlStateNormal];
        cancleBtn.layer.borderColor = [UIColor colorWithRed:1.000 green:0.222 blue:0.000 alpha:1.000].CGColor;
        cancleBtn.layer.borderWidth = 2;
        [cancleBtn setTitleColor:[UIColor colorWithRed:1.000 green:0.222 blue:0.000 alpha:1.000] forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor colorWithRed:0.500 green:0.256 blue:0.000 alpha:1.000] forState:UIControlStateHighlighted];
        [cancleBtn addTarget:self action:@selector(CancleAddUserToContact:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [confirmBtn addTarget:self action:@selector(addUserToContact:) forControlEvents:UIControlEventTouchUpInside];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancleBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        cancleBtn.layer.borderWidth = 2;
        [cancleBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [cancleBtn addTarget:self action:@selector(CancleFaceToFaceRoom:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    cancleBtn.frame = CGRectMake(bottomView.size.width*0.5+15, 10, bottomView.size.width*0.4, 50);
    cancleBtn.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:cancleBtn];
    

}
#pragma mark -- 点击确定按钮时
-(void)addUserToContact:(id)sender{
    WEAKSELF
    [self selectedStateWithOldSeletlist:self.SelectUserList];
    if (self.SelectUserList.count > 0 && self.faceToFace) {
        if (self.isGroup) {
             [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"你已选择%d个好友",[self.SelectUserList count]]];
            if (self.SelectUserList.count  == 1) {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"你没有选择除自己之外的好友"]];
                return;
            }
            [self.faceToFace createGroupWithInviteMembers:self.SelectUserList completion:^(NSError *error) {
                if (!error) {
                    [weakSelf loadMonitarData];
                    [weakSelf startCancleSelectAnimation];
                    [SVProgressHUD showSuccessWithStatus:@"近距离加好友创建群成功"];
                }else{
                   
                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                }
            }];
     }else{
              [self alertViewTextFild];
              self.alertCallBack = ^(NSString *title){
                  [weakSelf.faceToFace addBuddysWithInviteMembers:weakSelf.SelectUserList verifyInfo:title completion:^(NSError *error) {
                      if (!error) {
                           [weakSelf loadMonitarData];
                           [weakSelf startCancleSelectAnimation];
                           [SVProgressHUD showSuccessWithStatus:@"近距离添加好友成功"];
                      }else{
                          [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                      }
                  }];
            };
           
        }
       
    }else{
        [SVProgressHUD showErrorWithStatus:@"请选择房间内的人"];
    }
}
-(void)selectedStateWithOldSeletlist:(NSArray*)selectUserlist{
    int i = 0;
    for (LDUserModel *user in self.oldUserList) {//取消全部选中状态
        i++;
        for (LDUserModel *selectUser in selectUserlist) {
            if (user.ID == selectUser.ID) {
                NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:i-1];
                LDNearbyAddBuddyCollectionCell *cell = (LDNearbyAddBuddyCollectionCell*)[self.collectionView cellForItemAtIndexPath:index];
                if (![cell.selectView isHidden]) {
                    cell.selectView.hidden = YES;
                    cell.selectImage.hidden = YES;
                    break;
                }
            }
        }
    }

}
-(void)alertViewTextFild{
    //    __block  NSMutableArray *mutArray = [NSMutableArray array];
    UIAlertController * registerAlertC = [UIAlertController alertControllerWithTitle:@"验证信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [registerAlertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请填写验证信息";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [registerAlertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }]];
    
    [registerAlertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *name  = [registerAlertC.textFields objectAtIndex:0];
        if ([name.text isEmpty]) {
            UIAlertController * worning1 = [UIAlertController alertControllerWithTitle:@"验证信息不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [worning1 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ;
            }]];
            [self presentViewController:worning1 animated:YES completion:^{
                
            }];
            
        }else{
            if (self.alertCallBack) {
                self.alertCallBack(name.text);
            }

        }
        
    }]];
    [self presentViewController:registerAlertC animated:YES completion:^{
    }];
    return ;
}
#pragma mark -- 房间主人解散房间
-(void)CancleFaceToFaceRoom:(id)sender{
    if (self.faceToFace) {
        [self exitFaceTofaceRoom];
        
    }
}
#pragma mark -- 退出房间
-(void)CancleAddUserToContact:(id)sender{
    if (self.faceToFace) {
        [self exitFaceTofaceRoom];

    }
}
-(void)exitFaceTofaceRoom{
    if (self.fromToInputCodeView == 1) {
        if (self.isGroup) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
                    
            
        }
        
    }else{
        if (self.isGroup) {
            [self.faceToFace exitGroupRoom:^(NSError *error) {
                if (!error) {
                    if (self.fromToInputCodeView != 1) {
                        [SVProgressHUD showErrorWithStatus:@"解散加群房间成功"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.nc popViewControllerAnimated:YES];

                        });
                    }
                }
            }];
        }else{
            [self.faceToFace exitBuddyRoom:^(NSError *error) {
                if (!error) {
                    if (self.fromToInputCodeView != 1) {
                        [SVProgressHUD showErrorWithStatus:@"解散房间成功"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.nc popViewControllerAnimated:YES];
                        });
                        
                    }
                }
            }];
        }
        
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.oldUserList.count;
//    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LDNearbyAddBuddyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (self.oldUserList.count > 0) {
        LDUserModel * user = self.oldUserList[indexPath.row];
        if (user.ID == MYSELF.ID && self.fromToInputCodeView != 1) {
            if ([cell.selectView isHidden]) {
                cell.selectView.hidden = NO;
                cell.selectImage.hidden = NO;
            }
        }
        cell.userModelCell = user;
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75, 100);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 0, 10);//分别为上、左、下、右
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={320,45};
    return size;
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={320,45};
    return size;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
       if(self.fromToInputCodeView == 1){//不是房间主 不能选择
           return;
      }
   
        LDNearbyAddBuddyCollectionCell *cell = (LDNearbyAddBuddyCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if ([cell.selectView isHidden]) {
            cell.selectView.hidden = NO;
            cell.selectImage.hidden = NO;
        }
        if (self.bottomView.isHidden) {
            [UIView animateWithDuration:0.2 delay:0.0  options:0 animations:^{
                self.bottomView.hidden = NO;
                self.collectionView.contentInset = UIEdgeInsetsMake(kBottomViewHeight-50, 0, 0, 0);
                self.collectionView.transform = CGAffineTransformTranslate(self.collectionView.transform, 0, -kBottomViewHeight);
                self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-160, SCREEN_WIDTH, kBottomViewHeight);
            }completion:^(BOOL finished) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            }];
        }

 
    if (self.oldUserList.count > 0) {
        LDUserModel *selectUser = self.oldUserList[indexPath.row];
        if (self.SelectUserList.count > 0) {
            for (LDUserModel *userModel in self.SelectUserList) {
                if (userModel.ID != selectUser.ID) {
                    [self.SelectUserList addObject:selectUser];
                }
            }
            
        }else{
            [self.SelectUserList addObject:selectUser];
        }

    }
    
}
//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.fromToInputCodeView == 1){
        return;
    }
    LDUserModel *selectUser = self.oldUserList[indexPath.row];
    if (selectUser.ID != MYSELF.ID) {
        LDNearbyAddBuddyCollectionCell *cell = (LDNearbyAddBuddyCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if (![cell.selectView isHidden]) {
            cell.selectView.hidden = YES;
            cell.selectImage.hidden = YES;
        }
    }
   
    if (self.oldUserList.count > 0) {
        
        if (self.SelectUserList.count > 0) {
            for (LDUserModel *userModel in self.SelectUserList) {
                if (userModel.ID == selectUser.ID) {//如果取消选中的在选中的数组中 则取消选中好友
                    if (userModel.ID != MYSELF.ID) {
                        [self.SelectUserList removeObject:selectUser];
                        if([self.SelectUserList count] == 0){
                            [self startCancleSelectAnimation];
                        }

                    }else{
                        break;
                    }
                }
            }
            
        }else{//如果数组为空 隐藏按钮
            [self startCancleSelectAnimation];
        }

    }else{
        [self startCancleSelectAnimation];
    }
   
}
-(void)startCancleSelectAnimation{
    [UIView animateWithDuration:0.2 delay:0.0  options:0 animations:^{
        self.collectionView.contentInset = UIEdgeInsetsMake(-kBottomViewHeight+50, 0, 0, 0);
        self.collectionView.transform = CGAffineTransformTranslate(self.collectionView.transform, 0, kBottomViewHeight);
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kBottomViewHeight);
    }completion:^(BOOL finished) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        self.bottomView.hidden = YES;
    }];
}
//值监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    self.passWorld = change[new];
    self.titleLable.text = [NSString stringWithFormat:@"房间码：%@",self.passWorld];
    [self loadMonitarData];
    [SVProgressHUD dismiss];
    [self.timer invalidate];
    self.timer=nil;
}
@end
