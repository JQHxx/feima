//
//  FMPhotoCollectionViewCell.h
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMPhotoCollectionViewCell : BaseCollectionViewCell

@property(nonatomic, copy) void (^ _Nonnull deleteSeletedImage)(NSString *imageUrl);

//大小
+ (CGSize)itemSize;

- (void)fillDataWithImage:(NSString *)imageUrl showAdd:(BOOL)showAdd;

@end

NS_ASSUME_NONNULL_END
