//
//  FMSalesReportTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/26.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMSalesModel.h"

@interface FMSalesReportTableViewCell : BaseTableViewCell

- (void)fillContentWithData:(FMSalesModel *)model type:(NSInteger)type;

@end

