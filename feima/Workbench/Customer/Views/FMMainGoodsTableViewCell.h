//
//  FMMainGoodsTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMGoodsModel.h"

@protocol FMMainGoodsTableViewCellDelegate <NSObject>

- (void)mainGoodsTableViewCellDidUpdateQuantityWithGoods:(FMGoodsModel *)model;

@end

@interface FMMainGoodsTableViewCell : BaseTableViewCell

@property (nonatomic, weak ) id<FMMainGoodsTableViewCellDelegate>cellDelegate;

@end

