//
//  FMDistributionTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMGoodsModel.h"

@protocol FMDistributionTableViewCellDelegate <NSObject>

- (void)distributionTableViewDidSelectedGoods:(FMGoodsModel *)goods;

@end

@interface FMDistributionTableViewCell : BaseTableViewCell

@property (nonatomic, weak ) id<FMDistributionTableViewCellDelegate>cellDelegate;

- (void)fillContentWithData:(FMGoodsModel *)model type:(NSInteger)type;

@end

