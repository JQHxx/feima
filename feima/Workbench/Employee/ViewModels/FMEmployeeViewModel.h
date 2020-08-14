//
//  FMEmployeeViewModel.h
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMEmployeeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMEmployeeViewModel : BaseViewModel

/**
 *  员工通讯录
 *
 *  @param pageModel 分页
 *  @param complete  请求成功
*/
- (void)loadEmployeeContactsDataWithPage:(FMPageModel *)pageModel
                                complete:(AdpaterComplete)complete;

/**
 * 员工总数
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

@end

NS_ASSUME_NONNULL_END
