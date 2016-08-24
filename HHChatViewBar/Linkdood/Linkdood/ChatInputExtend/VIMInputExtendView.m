//
//  VIMInputExtendView.m
//  Linkdood
//
//  Created by 熊清 on 16/7/27.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "VIMInputExtendView.h"
#import "VIMInputExtendViewCell.h"

@interface VIMInputExtendView()

@property (strong,nonatomic) IBOutlet UICollectionView *extendCollection;
@property (assign,nonatomic) NSInteger sectionNumber;

@end

@implementation VIMInputExtendView

- (instancetype)initWithExtends:(NSArray*)extends
{
    if (self = [super init]) {
        self = [[[UINib nibWithNibName:NSStringFromClass([VIMInputExtendView class])
                                     bundle:[NSBundle bundleForClass:[VIMInputExtendView class]]] instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.extends = [NSMutableArray arrayWithArray:extends];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [self.extendCollection registerNib:[UINib nibWithNibName:@"VIMInputExtendViewCell" bundle:nil] forCellWithReuseIdentifier:@"VIMInputExtendViewCell"];
        self.extendCollection.collectionViewLayout = layout;
        [self.extendCollection setPagingEnabled:YES];
        self.extendCollection.backgroundColor = [UIColor clearColor];
        self.extendCollection.showsVerticalScrollIndicator = NO;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.extends.count < 4) {
        _sectionNumber = 1;
    }else{
        if (self.extends.count % 4 > 0) {
            _sectionNumber = self.extends.count/4 + 1;
        }else{
            _sectionNumber = self.extends.count/4;
        }
    }
    
    return _sectionNumber;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == _sectionNumber - 1 && self.extends.count % 4 > 0) {
        return self.extends.count % 4;
    }
    return 4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VIMInputExtendViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VIMInputExtendViewCell" forIndexPath:indexPath];
    [cell configExtendIcon:[self.extends objectAtIndex:(indexPath.section * 4 + indexPath.row)]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width / 4, 108);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressExtend:)]) {
        [self.delegate didPressExtend:indexPath.section * 4 + indexPath.row];
    }
}

@end
