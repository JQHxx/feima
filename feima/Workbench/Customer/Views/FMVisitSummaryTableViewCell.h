//
//  FMVisitSummaryTableViewCell.h
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMCustomerVisitModel.h"

@interface FMVisitSummaryTableViewCell : BaseTableViewCell

+ (CGFloat)getCellHeightWithModel:(FMVisitRecordInfoModel *)model;

@end
