//
//  FMCustomerSalesViewModel.h
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMCustomerSalesModel.h"

@interface FMCustomerSalesViewModel : BaseViewModel

@property (nonatomic,strong) FMCustomerDataModel *customerData;

/**
 *  客户销售报表
 *
 *  @param time  当日时间
 *  @param organizationIds  指定部门 逗号分隔
 *  @param complete  请求成功
*/
- (void)loadCustomerSalesReportWithTime:(NSInteger)time
                        organizationIds:(NSString *)organizationIds
                               complete:(AdpaterComplete)complete;

/*
* 客户销售报表数量
*/
- (NSInteger)numberOfCustomerSalesReportList;

/*
 * 客户销售报表对象
*/
- (FMCustomerSalesModel *)getCustomerSalesReportWithIndex:(NSInteger)index;

@end

