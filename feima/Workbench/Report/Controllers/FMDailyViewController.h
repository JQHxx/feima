//
//  FMDailyViewController.h
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"
#import "FMDailyReportModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FMDailyViewControllerDelegate <NSObject>

- (void)dailyViewControllerDidSelectedRowWithModel:(FMDailyReportModel *)model;

@end

@interface FMDailyViewController : BaseViewController

@property (nonatomic, weak )id<FMDailyViewControllerDelegate>controlerDelegate;

@end

NS_ASSUME_NONNULL_END
