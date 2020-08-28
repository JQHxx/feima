//
//  FMSalesViewModel.h
//  feima
//
//  Created by fei on 2020/8/26.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMSalesModel.h"
#import "FMTimeDataModel.h"
#import "FMSalesDataModel.h"

@interface FMSalesViewModel : BaseViewModel

@property (nonatomic, strong) FMTimeDataModel *timeDataModel;
@property (nonatomic, strong) FMSalesDataModel *salesDataModel;

/**
 *  销售报表
 *
 *  @param type  0员工 1部门
 *  @param sTime  开始时间
 *  @param eTime  结束时间
 *  @param complete  请求成功
*/
- (void)loadSalesReportWithType:(NSInteger)type
                      startTime:(NSInteger)sTime
                        endTime:(NSInteger)eTime
                       complete:(AdpaterComplete)complete;

- (NSInteger)numberOfSalesReportList;

- (FMSalesModel *)getSalesReportWithIndex:(NSInteger)index;




@end

