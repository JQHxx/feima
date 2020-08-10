//
//  FMGoodsTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FMGoodsTableViewCell;
@protocol FMGoodsTableViewCellDelegate <NSObject>

- (void)tableViewCell:(FMGoodsTableViewCell *)cell didSelectedGoods:(FMGoodsModel *)model withBtnTag:(NSInteger)tag;

@end

@interface FMGoodsTableViewCell : BaseTableViewCell

@property (nonatomic, weak ) id<FMGoodsTableViewCellDelegate>cellDelegate;

@end

NS_ASSUME_NONNULL_END
