//
//  FMContactViewModel.h
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMEmployeeModel.h"
#import "FMCustomerModel.h"

@interface FMContactViewModel : BaseViewModel

/**
 *  员工通讯录
 *
 *  @param pageModel 分页
 *  @param name 员工名 （模糊搜索）
 *  @param complete  请求成功
*/
- (void)loadEmployeeContactsDataWithPage:(FMPageModel *)pageModel
                                    name:(NSString *)name
                                complete:(AdpaterComplete)complete;

/**
 *  客户通讯录
 *
 *  @param pageModel 分页
 *  @param contactName      客户名称或者店铺名称，联系方式 模糊
 *  @param action      “total” 只取数量 默认列表
 *  @param complete  请求成功
*/
- (void)loadCustomerContactsDataWithPage:(FMPageModel *)pageModel
                             contactName:(NSString *)contactName
                                  action:(NSString *)action
                                complete:(AdpaterComplete)complete;

/**
 *员工总数
 */
- (NSInteger)employeeTotalCount;

/**
 *  返回员工数
*/
- (NSInteger)numberOfEmployeesList;

/**
 *  返回员工对象
*/
- (FMEmployeeModel *)getEmployeeModelWithIndex:(NSInteger)index;

/**
 *  是否还有更多员工
*/
- (BOOL)hasMoreEmployeeData;

/**
 *客户总数
 */
- (NSInteger)customerTotalCount;

/**
 *  返回客户数
*/
- (NSInteger)numberOfCustomersList;

/**
 *  返回客户对象
*/
- (FMCustomerModel *)getCustomerModelWithIndex:(NSInteger)index;

/**
 *  是否还有更多客户
*/
- (BOOL)hasMoreCustomerData;


@end

