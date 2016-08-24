//
//  XMNPhotoPicker.m
//  XMNPhotoPickerKitExample
//
//  Created by XMFraker on 16/2/1.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNPhotoPicker.h"
#import "XMNAssetCell.h"

#import "XMNPhotoPickerController.h"
#import "XMNPhotoPreviewController.h"
#import "XMNVideoPreviewController.h"

#import "XMNPhotoManager.h"
#import "XMNPhotoPickerDefines.h"

#import "UIView+Animations.h"
#import "UIViewController+XMNPhotoHUD.h"
#import <JSQMessagesViewController/UIImage+JSQMessages.h>
@interface XMNPhotoPicker   () <UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PHPhotoLibraryChangeObserver>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIView *cameraLineView;
@property (weak, nonatomic) IBOutlet UIButton *photoLibraryButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) XMNAlbumModel *displayAlbum;
@property (nonatomic, copy) NSArray <XMNAssetModel *>* assets;
@property (nonatomic, strong) NSMutableArray <XMNAssetModel *> *selectedAssets;

@property (nonatomic, assign, readonly) CGFloat contentViewHeight;

@end

@implementation XMNPhotoPicker

+ (instancetype)sharePhotoPicker {
    static id photoPicker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoPicker = [[[self class] alloc] initWithMaxCount:9];
    });
    return photoPicker;
}

- (instancetype)initWithMaxCount:(NSUInteger)maxCount {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"XMNPhotoPicker" owner:nil options:nil];
    if ((self = (XMNPhotoPicker *)[array firstObject])) {
        [self _setup];
        self.maxCount = maxCount ? : self.maxCount;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)dealloc {
    NSLog(@"XMNPhotoPicker dealloc");
}

#pragma mark - Methods
- (void)showPhotoPickerwithController:(UIViewController *)controller animated:(BOOL)animated {
    [self.selectedAssets removeAllObjects];
    [self.assets makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    [self _updatePhotoLibraryButton];
    [self.collectionView setContentOffset:CGPointZero];
    [self.collectionView reloadData];
    self.hidden = NO;
    self.parentController = controller;
    if (!self.parentView) {
        self.parentView = controller.view;
    }
    
    [self setBackgroundColor:_parentView.backgroundColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height = self.height;
    frame.origin.y = _parentView.height;
    self.frame = frame;
    
    self.assets ? nil : [self _loadAssets];
}

- (void)_setup {
    
    self.maxPreviewCount = 20;
    self.maxCount = MIN(self.maxPreviewCount, NSUIntegerMax);
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height = self.height;
    self.frame = frame;
    
    [_cameraButton setImage:[UIImage jsq_bubbleImageFromBundleWithName:@"camera"] forState:UIControlStateNormal];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.contentViewHeight);
    cancelButton.tag = kXMNCancel;
    [cancelButton addTarget:self action:@selector(_handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    iOS8Later ? [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self] : nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.cameraButton.hidden = NO;
        self.cameraLineView.hidden = NO;
    }else {
        self.cameraButton.hidden = YES;
        self.cameraLineView.hidden = YES;
    }
        
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = kXMNMargin;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);

    [self.collectionView registerNib:[UINib nibWithNibName:@"XMNAssetCell" bundle:nil] forCellWithReuseIdentifier:@"XMNAssetCell"];
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.selectedAssets = [NSMutableArray array];
    self.assets ? nil : [self _loadAssets];
}

- (void)_loadAssets {
    
    __weak typeof(*&self) wSelf = self;
    self.loadingView.hidden = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[XMNPhotoManager sharedManager] getAlbumsPickingVideoEnable:YES completionBlock:^(NSArray<XMNAlbumModel *> *albums) {
            if (albums && [albums firstObject]) {
                self.displayAlbum = [albums firstObject];
                [[XMNPhotoManager sharedManager] getAssetsFromResult:[[albums firstObject] fetchResult] pickingVideoEnable:YES completionBlock:^(NSArray<XMNAssetModel *> *assets) {
                    __weak typeof(*&self) self = wSelf;
                    NSMutableArray *tempAssets = [NSMutableArray array];
                    [assets enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(XMNAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        __weak typeof(*&self) self = wSelf;
                        [tempAssets addObject:obj];
                        *stop = ( tempAssets.count > self.maxPreviewCount);
                    }];
                    self.assets = [NSArray arrayWithArray:tempAssets];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __weak typeof(*&self) self = wSelf;
                        [self.contentView setHidden:NO];
                        [self.tipLabel setHidden:YES];
                        self.loadingView.hidden = YES;
                        [self.collectionView reloadData];
                    });
                }];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.contentView setHidden:YES];
                    [self.tipLabel setHidden:NO];
                });
            }
        }];
    });
}

- (IBAction)_handleButtonAction:(UIButton *)sender {
    switch (sender.tag) {
        case kXMNCancel:
//            [self hideAnimated:YES];
            break;
        case kXMNConfirm:
        {
            if (self.selectedAssets.count == 1 && [self.selectedAssets firstObject].type == XMNAssetTypeVideo) {
                self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock([self.selectedAssets firstObject].previewImage,[self.selectedAssets firstObject]) : nil;
            }else {
                NSMutableArray *images = [NSMutableArray array];
                [self.selectedAssets enumerateObjectsUsingBlock:^(XMNAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [images addObject:obj.previewImage];
                }];
                self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(images,self.selectedAssets) : nil;
            }
            
            for (XMNAssetModel *asset in self.selectedAssets) {
                [asset setSelected:NO];
            }
            [self.selectedAssets removeAllObjects];
            [self _updatePhotoLibraryButton];
            [self.collectionView reloadData];
        }
            
            break;
        case kXMNCamera:
        {
            [self _showImageCameraController];
        }
            break;
        case kXMNPhotoLibrary:
        {
            [self _showPhotoPickerController];
        }
            break;
        default:
            break;
    }
}

- (void)_updatePhotoLibraryButton {
    if (self.selectedAssets.count == 0) {
        self.photoLibraryButton.tag = kXMNPhotoLibrary;
        [self.photoLibraryButton setTitle:[NSString stringWithFormat:@"相册"] forState:UIControlStateNormal];
        [self.photoLibraryButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }else {
        self.photoLibraryButton.tag = kXMNConfirm;
        [self.photoLibraryButton setTitle:[NSString stringWithFormat:@"发送(%d)",(int)self.selectedAssets.count] forState:UIControlStateNormal];
        [self.photoLibraryButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)_showPhotoPickerController {
    XMNPhotoPickerController *photoPickerController = [[XMNPhotoPickerController alloc] initWithMaxCount:self.maxCount delegate:nil];
    __weak typeof(*&self) wSelf = self;
    [photoPickerController setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
        __weak typeof(*&self) self = wSelf;
        self.didFinishPickingPhotosBlock ?self.didFinishPickingPhotosBlock(images,assets) : nil;
        [self.parentController dismissViewControllerAnimated:YES completion:nil];
    }];
    [photoPickerController setDidFinishPickingVideoBlock:^(UIImage *coverImage, id asset) {
        __weak typeof(*&self) self = wSelf;
        self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(coverImage,asset) : nil;
        [self.parentController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.parentController presentViewController:photoPickerController animated:YES completion:nil];
}

- (void)_showImageCameraController {
    UIImagePickerController *imagePickerC = [[UIImagePickerController alloc] init];
    imagePickerC.delegate = self;
    imagePickerC.allowsEditing = NO;
    imagePickerC.videoQuality = UIImagePickerControllerQualityTypeLow;
    imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.parentController presentViewController:imagePickerC animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMNAssetCell *assetCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMNAssetCell" forIndexPath:indexPath];
    [assetCell configPreviewCellWithItem:self.assets[indexPath.row]];
    
    __weak typeof(*&self) wSelf = self;
    // 设置assetCell willChangeBlock
    [assetCell setWillChangeSelectedStateBlock:^BOOL(XMNAssetModel *asset) {
        if (!asset.selected) {
            __weak typeof(*&self) self = wSelf;
            if (asset.type == XMNAssetTypeVideo) {
                if ([self.selectedAssets firstObject] && [self.selectedAssets firstObject].type != XMNAssetTypeVideo) {
                    [self.parentController showAlertWithMessage:@"不能同时选择照片和视频"];
                }else if ([self.selectedAssets firstObject]){
                    [self.parentController showAlertWithMessage:@"一次只能发送1个视频"];
                }else {
                    return YES;
                }
                return NO;
            }else if (self.selectedAssets.count > self.maxCount){
                [self.parentController showAlertWithMessage:[NSString stringWithFormat:@"一次最多只能选择%d张图片",(int)self.maxCount]];
                return NO;
            }
            return YES;
        }else {
            return NO;
        }
    }];
    
    // 设置assetCell didChangeBlock
    [assetCell setDidChangeSelectedStateBlock:^(BOOL selected, XMNAssetModel *asset) {
        __weak typeof(*&self) self = wSelf;
        if (selected) {
            [self.selectedAssets containsObject:asset] ? nil : [self.selectedAssets addObject:asset];
            asset.selected = YES;
        }else {
            [self.selectedAssets containsObject:asset] ? [self.selectedAssets removeObject:asset] : nil;
            asset.selected = NO;
        }
        [self _updatePhotoLibraryButton];
    }];
    
    [assetCell setDidSendAsset:^(XMNAssetModel *asset, CGRect frame) {
        if (asset.type == XMNAssetTypePhoto) {
            self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(@[asset.previewImage],@[asset]) : nil;
        }else {
            self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(asset.previewImage , asset) : nil;
        }
    }];
    
    return assetCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMNAssetModel *asset = self.assets[indexPath.row];
    CGSize size = asset.previewImage.size;
    CGFloat scale = (size.width - 10)/size.height;
    return CGSizeMake(scale * (self.collectionView.frame.size.height),self.collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XMNAssetModel *assetModel = self.assets[indexPath.row];
    if (assetModel.type == XMNAssetTypeVideo) {
        XMNVideoPreviewController *videoPreviewC = [[XMNVideoPreviewController alloc] init];
        videoPreviewC.selectedVideoEnable = self.selectedAssets.count == 0;
        videoPreviewC.asset = assetModel;
        __weak typeof(*&self) wSelf = self;
        [videoPreviewC setDidFinishPickingVideo:^(UIImage *coverImage, XMNAssetModel *asset) {
            __weak typeof(*&self) self = wSelf;
            self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(coverImage,asset) : nil;
            [self.parentController dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.parentController presentViewController:videoPreviewC animated:YES completion:nil];
    }else {
        XMNPhotoPreviewController *previewC = [[XMNPhotoPreviewController alloc] initWithCollectionViewLayout:[XMNPhotoPreviewController photoPreviewViewLayoutWithSize:[UIScreen mainScreen].bounds.size]];
        previewC.assets = self.assets;
        previewC.maxCount = self.maxCount;
        previewC.selectedAssets = [NSMutableArray arrayWithArray:self.selectedAssets];
        previewC.currentIndex = indexPath.row;
        __weak typeof(*&self) wSelf = self;
        [previewC setDidFinishPreviewBlock:^(NSArray<XMNAssetModel *> *selectedAssets) {
            __weak typeof(*&self) self = wSelf;
            self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
            [self _updatePhotoLibraryButton];
            [self.collectionView reloadData];
            [self.parentController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [previewC setDidFinishPickingBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
            __weak typeof(*&self) self = wSelf;
            [self.selectedAssets removeAllObjects];
            self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(images,assets) : nil;
            [self.parentController dismissViewControllerAnimated:YES completion:^{
                for (XMNAssetModel *asset in assets) {
                    [asset setSelected:NO];
                }
                [self.selectedAssets removeAllObjects];
                [self _updatePhotoLibraryButton];
                [self.collectionView reloadData];
            }];
        }];
        
        [self.parentController presentViewController:previewC animated:YES completion:nil];
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.hidden = YES;
    [self removeFromSuperview];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(@[image], nil) : nil;
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PHPhotoLibraryChangeObserver


- (void)photoLibraryDidChange:(PHChange *)changeInfo {
    __weak typeof(*&self) wSelf = self;
    // Photos may call this method on a background queue;
    // switch to the main queue to update the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        // Check for changes to the list of assets (insertions, deletions, moves, or updates).
        PHFetchResultChangeDetails *collectionChanges = [changeInfo changeDetailsForFetchResult:self.displayAlbum.fetchResult];
        if (collectionChanges) {
            // Get the new fetch result for future change tracking.
            XMNAlbumModel *changeAlbumModel = [XMNAlbumModel albumWithResult:collectionChanges.fetchResultAfterChanges name:@"afterChange"];
            self.displayAlbum = changeAlbumModel;
            if (collectionChanges.hasIncrementalChanges)  {
                [[XMNPhotoManager sharedManager] getAssetsFromResult:self.displayAlbum.fetchResult pickingVideoEnable:YES completionBlock:^(NSArray<XMNAssetModel *> *assets) {
                    __weak typeof(*&self) self = wSelf;
                    NSMutableArray *tempAssets = [NSMutableArray array];
                    [assets enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(XMNAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        __weak typeof(*&self) self = wSelf;
                        [tempAssets addObject:obj];
                        *stop = ( tempAssets.count > self.maxPreviewCount);
                    }];
                    self.assets = [NSArray arrayWithArray:tempAssets];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __weak typeof(*&self) self = wSelf;
                        [self.collectionView reloadData];
                    });
                }];
            } else {
                // Detailed change information is not available;
                // repopulate the UI from the current fetch result.
                [self.collectionView reloadData];
            }
        }
    });
}

- (NSArray <NSIndexPath *> *)_indexPathsFromIndexSet:(NSIndexSet *)indexSet {
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:self.displayAlbum.count - idx inSection:0]];
    }];
    return indexPaths;
}
#pragma mark - Getters

- (CGFloat)contentViewHeight {
    return self.height;
}

@end
