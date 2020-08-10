//
//  FMProductTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMGoodsSalesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMProductTableViewCell : BaseTableViewCell

+ (CGFloat)getCellHeightWithModel:(FMEmployeeGoodsModel *)model;

@end

NS_ASSUME_NONNULL_END
