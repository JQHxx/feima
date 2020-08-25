//
//  FMPhotoCollectionView.h
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HandleComplte)(void);

@interface FMPhotoCollectionView : UICollectionView

@property (nonatomic,assign) BOOL     canSelectedAlbum;
@property (nonatomic,assign) NSInteger maxImagesCount;
@property (nonatomic, copy ) HandleComplte handleComplete;

- (NSArray *)getAllImages;

- (void)addPickedImages:(NSArray *)images;

@end

NS_ASSUME_NONNULL_END
