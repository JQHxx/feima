//
//  FMDailyTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMDailyReportModel.h"


@interface FMDailyTableViewCell : BaseTableViewCell

- (void)fillContentWithData:(FMDailyReportModel *)model index:(NSInteger)index;

@end

