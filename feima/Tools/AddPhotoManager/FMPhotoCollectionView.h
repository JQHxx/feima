//
//  FMPhotoCollectionView.h
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMPhotoCollectionView : UICollectionView

@property (nonatomic,assign) NSInteger maxImagesCount;

- (NSArray *)getAllImages;

@end

NS_ASSUME_NONNULL_END
