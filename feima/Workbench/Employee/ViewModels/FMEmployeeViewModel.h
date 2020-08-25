//
//  FMEmployeeViewModel.h
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMEmployeeModel.h"
#import "FMOrganizationModel.h"
#import "FMPositionModel.h"

@interface FMEmployeeViewModel : BaseViewModel

@property (nonatomic, copy ) NSArray <FMOrganizationModel *> *organizationArray;
@property (nonatomic, copy ) NSArray <FMPositionModel *> *posisionArray;
@property (nonatomic,assign) NSInteger employeeId;

/**
 *  员工列表
 *
 *  @param pageModel 分页
 *  @param name  姓名
 *  @param status  状态
 *  @param complete  请求成功
*/
- (void)loadEmployeeListDataWithPage:(FMPageModel *)pageModel
                                name:(NSString *)name
                              status:(NSInteger)status
                            complete:(AdpaterComplete)complete;

/**
 *  添加或修改员工
 *
 *  @param type  0添加 1修改
 *  @param employeeId  员工id
 *  @param logo 头像
 *  @param name 姓名
 *  @param sex 性别
 *  @param organizationId  部门id
 *  @param postId      职位id
 *  @param telephone      电话
 *  @param companyId   公司id
 *  @param complete  请求成功
*/
- (void)addOrUpdateEmployeeWithType:(NSInteger)type
                         employeeId:(NSInteger)employeeId
                               logo:(NSString *)logo
                               name:(NSString *)name
                                sex:(NSInteger )sex
                     organizationId:(NSInteger )organizationId
                             postId:(NSInteger)postId
                          telephone:(NSString *)telephone
                          companyId:(NSInteger)companyId
                           complete:(AdpaterComplete)complete;

/**
 *  禁用或启用员工
 *
 *  @param isEnable 是否启用
 *  @param employeeId  员工id
 *  @param complete  请求成功
 */
- (void)setEmployeeEnable:(BOOL)isEnable
               employeeId:(NSInteger)employeeId
                 complete:(AdpaterComplete)complete;


/**
 *  组织机构下拉框
 *
 *  @param complete    请求完成
*/
- (void)loadOrganizationDataComplete:(AdpaterComplete)complete;

/**
 * 职位下拉框
 *
 *  @param complete    请求完成
*/
- (void)loadPositionDataComplete:(AdpaterComplete)complete;

/**
 *  返回员工数
*/
- (NSInteger)numberOfEmployeesList;

/**
 *  返回员工对象
*/
- (FMEmployeeModel *)getEmployeeModelWithIndex:(NSInteger)index;

/**
 *  删除员工
*/
- (void)deleteFromListWithEmployee:(FMEmployeeModel *)employee;

/**
 *  修改员工对象
*/
- (void)replaceEmployeeWithNewGoods:(FMEmployeeModel *)model;


/**
 *  插入员工对象
*/
- (void)insertEmployee:(FMEmployeeModel *)model;

/**
 *  员工已选
*/
- (void)didSelectedEmployeeWithEmployeeId:(NSInteger)employeeId;

@end
