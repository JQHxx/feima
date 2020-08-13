//
//  FMContactViewModel.h
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMContactViewModel : BaseViewModel

/**
 *  员工通讯录
 *
 *  @param pageModel 分页
 *  @param complete  请求成功
*/
- (void)loadEmployeeContactsDataWithPage:(FMPageModel *)pageModel
                                complete:(AdpaterComplete)complete;

/**
 *  客户通讯录
 *
 *  @param pageModel 分页
 *  @param action      “total” 只取数量 默认列表
 *  @param complete  请求成功
*/
- (void)loadCustomerContactsDataWithPage:(FMPageModel *)pageModel
                                  action:(NSString *)action
                                complete:(AdpaterComplete)complete;

@end

NS_ASSUME_NONNULL_END
