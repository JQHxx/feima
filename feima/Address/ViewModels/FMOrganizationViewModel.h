//
//  FMOrganizationViewModel.h
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMOrganizationModel.h"
#import "FMEmployeeModel.h"

@interface FMOrganizationViewModel : BaseViewModel

/**
 *  组织结构列表
 *
 *  @param pageModel 分页
 *  @param pid   结构id
 *  @param name 员工名 （模糊搜索）
 *  @param complete  请求成功
*/
- (void)loadOrganizationBeansWithPage:(FMPageModel *)pageModel
                                  pid:(NSInteger )pid
                                 name:(NSString *)name
                                complete:(AdpaterComplete)complete;

/**
 *  返回组织数
*/
- (NSInteger)numberOfOrgnazitionsList;

/**
 *  返回组织对象
*/
- (FMOrganizationModel *)getOrganizationModelWithIndex:(NSInteger)index;

/**
 *  组织数组为空
*/
- (BOOL)isOrganizationEmpty;

/**
 *  返回员工数
*/
- (NSInteger)numberOfEmployeeList;

/**
 *  返回员工对象
*/
- (FMEmployeeModel *)getEmployeeModelWithIndex:(NSInteger)index;

/**
 *  员工数组为空
*/
- (BOOL)isEmployeeEmpty;

@end

