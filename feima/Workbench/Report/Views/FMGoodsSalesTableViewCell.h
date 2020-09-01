//
//  FMGoodsSalesTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMGoodsSalesModel.h"


@interface FMGoodsSalesTableViewCell : BaseTableViewCell

- (void)fillContentWithData:(FMGoodsSalesModel *)model type:(NSInteger)type;

+ (CGFloat)getCellHeightWithModel:(FMGoodsSalesModel *)model;

@end

