//
//  FMReportHeadView.h
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMTimeDataModel.h"
#import "FMSalesDataModel.h"
#import "FMGoodsSalesModel.h"
#import "FMCustomerSalesModel.h"

@protocol FMReportHeadViewDelegate <NSObject>

- (void)reportHeadViewDidSelectedMonthWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime;

@end

@interface FMReportHeadView : UIView

@property (nonatomic, weak ) id<FMReportHeadViewDelegate>delegate;

- (void)displayViewWithTimeData:(FMTimeDataModel *)timeData;

- (void)displayViewWithTimeData:(FMTimeDataModel *)timeData salesData:(FMSalesDataModel *)salesData;

- (void)displayViewWithGoodsData:(NSArray *)goodsData salesData:(FMSalesDataModel *)salesData;

- (void)displayViewWithCustomerData:(FMCustomerDataModel *)customerData;

- (void)displayViewWithCompetitorData;

@end

