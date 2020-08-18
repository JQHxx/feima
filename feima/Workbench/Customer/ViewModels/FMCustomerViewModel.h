//
//  FMCustomerViewModel.h
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMCustomerModel.h"

@interface FMCustomerViewModel : BaseViewModel

/**
 *  客户列表
 *
 *  @param pageModel 分页
 *  @param contactName      联系人
 *  @param visitCode      1 未拜访 2 已拜访
 *  @param complete  请求成功
*/
- (void)loadCustomerListWithPage:(FMPageModel *)pageModel
                             contactName:(NSString *)contactName
                               visitCode:(NSInteger)visitCode
                                complete:(AdpaterComplete)complete;

/**
 *  添加或修改客户
 *
 *  @param type  0添加 1修改
 *  @param businessName 商户名称
 *  @param nickName 简称
 *  @param contactName 联系人
 *  @param telephone  手机号码
 *  @param address      位置
 *  @param images   门头照
 *  @param industryType  行业类型
 *  @param grade   客户等级
 *  @param displayArea      陈列面积
 *  @param progress      进度
 *  @param employeeId      跟进人
 *  @param complete  请求成功
*/
- (void)addOrUpdateCustomerWithType:(NSInteger)type
                       businessName:(NSString *)businessName
                           nickName:(NSString *)nickName
                        contactName:(NSString *)contactName
                          telephone:(NSString *)telephone
                            address:(NSString *)address
                          doorPhoto:(NSArray *)images
                       industryType:(NSInteger)industryType
                              grade:(NSInteger)grade
                        displayArea:(NSString *)displayArea
                           progress:(NSInteger)progress
                         employeeId:(NSInteger)employeeId
                           complete:(AdpaterComplete)complete;


/**
 * 客户总数
 */
- (NSInteger)numberOfCustomerList;

/**
 *  返回客户对象
*/
- (FMCustomerModel *)getCustomerModelWithIndex:(NSInteger)index;

@end

