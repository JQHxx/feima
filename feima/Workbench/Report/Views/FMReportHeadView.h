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

//个人销售报表
- (void)displayViewWithTimeData:(FMTimeDataModel *)timeData;

//部门销售报表
- (void)displayViewWithTimeData:(FMTimeDataModel *)timeData salesData:(FMSalesDataModel *)salesData;

//产品销售报表
- (void)goodsSalesViewFillGoodsSalesData:(NSArray <FMGoodsSalesDataModel *> *)goodsSalesData salesData:(FMSalesDataModel *)salesData;

@end

