//
//  FMGoodsSalesViewModel.h
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMGoodsSalesModel.h"
#import "FMSalesDataModel.h"

@interface FMGoodsSalesViewModel : BaseViewModel

@property (nonatomic,  copy ) NSArray <FMGoodsSalesDataModel *> *goodsSalesData;
@property (nonatomic, strong) FMSalesDataModel      *salesData;

/**
 *  产品销售报表
 *
 *  @param type  0员工 1部门
 *  @param sTime  开始时间
 *  @param eTime  结束时间
 *  @param complete  请求成功
 */
 - (void)loadGoodsSalesReportWithType:(NSInteger)type
                            startTime:(NSInteger)sTime
                              endTime:(NSInteger)eTime
                             complete:(AdpaterComplete)complete;
/*
* 产品销售报表数量
*/
- (NSInteger)numberOfGoodsSalesReportList;

/*
 * 产品销售报表对象
*/
- (FMGoodsSalesModel *)getGoodsSalesReportWithIndex:(NSInteger)index;



@end

