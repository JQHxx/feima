//
//  BaseCollectionViewCell.h
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionViewCell : UICollectionViewCell

+ (NSString*)identifier;

- (void)fillContentWithData:(id)obj;


@end

NS_ASSUME_NONNULL_END
