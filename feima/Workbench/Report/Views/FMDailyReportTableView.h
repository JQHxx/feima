//
//  FMDailyReportTableView.h
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDailyReportModel.h"

@protocol FMDailyReportTableViewDelegate <NSObject>

- (void)dailyReportTableViewDidSelectedRowWithModel:(FMDailyReportModel *)dailyModel;

@end

@interface FMDailyReportTableView : UITableView

@property (nonatomic, weak ) id<FMDailyReportTableViewDelegate>viewDelegate;

@end

