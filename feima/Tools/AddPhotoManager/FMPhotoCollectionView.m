//
//  FMPhotoCollectionView.m
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMPhotoCollectionView.h"
#import "FMPhotoCollectionViewCell.h"
#import "FMUploadPhotoViewModel.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <YBImageBrowser/YBImageBrowser.h>
#import "MXActionSheet.h"

@interface FMPhotoCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic ,strong)UIImagePickerController *imgPicker;

@property (nonatomic,strong) FMUploadPhotoViewModel *adapter;

@end

@implementation FMPhotoCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0); //设置其边界
        self.collectionViewLayout = layout;
        
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self registerClass:[FMPhotoCollectionViewCell class] forCellWithReuseIdentifier:[FMPhotoCollectionViewCell identifier]];
    }
    return self;
}

#pragma mark -- UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger imagesCount = [self.adapter numberOfImages];
    if (imagesCount < self.maxImagesCount) {
        return imagesCount + 1;
    } else {
        return imagesCount;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FMPhotoCollectionViewCell identifier] forIndexPath:indexPath];
    NSString *imgUrl = [self.adapter getImageUrlWithIndex:indexPath.row];
    BOOL showAdd = indexPath.row == [self.adapter numberOfImages] && [self.adapter numberOfImages] < self.maxImagesCount;
    [cell fillDataWithImage:imgUrl showAdd:showAdd];
    kSelfWeak;
    cell.deleteSeletedImage = ^(NSString * _Nonnull imageUrl) {
        [weakSelf.adapter deleteImage:imgUrl];
        [weakSelf reloadData];
        if (weakSelf.handleComplete) {
            weakSelf.handleComplete();
        }
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.adapter numberOfImages]) {
        [self addPhoto];
    } else {
        //图片浏览
        NSInteger count = [self.adapter numberOfImages];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:count];
        for(NSInteger i = 0; i < count; i++){
            NSString *imageUrl = [self.adapter getImageUrlWithIndex:i];
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
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [FMPhotoCollectionViewCell itemSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

#pragma mark -- Public methods
#pragma mark 获取所有图片
- (NSArray *)getAllImages {
    return [self.adapter allImages];
}

#pragma mark 添加图片
- (void)addPickedImages:(NSArray *)images {
    [self.adapter insertImages:images];
    [self reloadData];
}

#pragma mark -- Delegate
#pragma mark  UIImagePickerControllerDelegate
#pragma mark  取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 确定选择图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage* curImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    kSelfWeak;
    [self.adapter uploadPhotoRequestWithImage:curImage complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [self reloadData];
            if (weakSelf.handleComplete) {
                weakSelf.handleComplete();
            }
        } else {
            [kKeyWindow makeToast:self.adapter.errorString duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark -- Private methods
#pragma mark 添加图片
- (void)addPhoto {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                if (self.canSelectedAlbum) {
                    NSArray *buttonTitles = @[@"拍照",@"从手机相册选择",];
                    [MXActionSheet showWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:buttonTitles selectedBlock:^(NSInteger index) {
                         self.imgPicker=[[UIImagePickerController alloc]init];
                         self.imgPicker.delegate=self;
                        self.findViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                        if (index==1) {
                           if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) //判断设备相机是否可用
                           {
                               self.imgPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                               [self.findViewController presentViewController:self.imgPicker animated:YES completion:nil];
                           }else{
                               [kKeyWindow makeToast:@"您的相机不可用" duration:1.0 position:CSToastPositionCenter];
                               return ;
                           }
                        }else if (index==2){
                            self.imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                            [self.findViewController presentViewController:self.imgPicker animated:YES completion:nil];
                        }
                        
                    }];
                } else {
                    self.imgPicker=[[UIImagePickerController alloc]init];
                    self.imgPicker.delegate=self;
                    self.findViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){  //判断设备相机是否可用
                        self.imgPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                        [kKeyWindow.rootViewController presentViewController:self.imgPicker animated:YES completion:nil];
                    }else{
                        [kKeyWindow makeToast:@"您的相机不可用" duration:1.0 position:CSToastPositionCenter];
                        return ;
                    }
                }
            }
        });
    }];
}

- (FMUploadPhotoViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMUploadPhotoViewModel alloc] init];
    }
    return _adapter;
}

@end
