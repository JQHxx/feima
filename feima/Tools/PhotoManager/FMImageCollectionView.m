//
//  FMImageCollectionView.m
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMImageCollectionView.h"
#import "FMImageCollectionViewCell.h"
#import <YBImageBrowser/YBImageBrowser.h>

#define kItemSpacing 8.0
#define kLineSpacing 5.0

@interface FMImageCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation FMImageCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0); //设置其边界
        self.collectionViewLayout = layout;
        
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self registerClass:[FMImageCollectionViewCell class] forCellWithReuseIdentifier:[FMImageCollectionViewCell identifier]];
    }
    return self;
}

#pragma mark -- UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FMImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FMImageCollectionViewCell identifier] forIndexPath:indexPath];
    NSString *imageUrl = self.images[indexPath.row];
    [cell fillContentWithData:imageUrl];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //图片浏览
    NSInteger count = self.images.count;
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:count];
    for(NSInteger i = 0; i < count; i++){
        NSString *imageUrl = self.images[indexPath.row];
        YBIBImageData *data1 = [YBIBImageData new];
        if (!kIsEmptyString(imageUrl)) {
            data1.imageURL = [NSURL URLWithString:imageUrl];
        }
        [arr addObject:data1];
    }
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = arr;
    browser.currentPage = indexPath.row;
    [browser show];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [FMImageCollectionViewCell itemSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kItemSpacing;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    [self reloadData];
}

@end
