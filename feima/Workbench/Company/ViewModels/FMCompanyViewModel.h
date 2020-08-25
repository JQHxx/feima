//
//  FMCompanyViewModel.h
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMCompanyModel.h"

@interface FMCompanyViewModel : BaseViewModel

@property (nonatomic,assign) NSInteger companyId;

/**
 *  公司列表
 *
 *  @param pageModel 分页
 *  @param name      公司名称
 *  @param complete  请求成功
*/
- (void)loadCompanyListWithPage:(FMPageModel *)pageModel
                           name:(NSString *)name
                       complete:(AdpaterComplete)complete;

/**
 *  添加或修改公司
 *
 *  @param type  0添加 1修改
 *  @param companyId  公司id
 *  @param name   名称
 *  @param phone 电话
 *  @param address      位置
 *  @param complete  请求成功
*/
- (void)addOrUpdateCompanyWithType:(NSInteger)type
                         companyId:(NSInteger)companyId
                              name:(NSString *)name
                             phone:(NSString *)phone
                           address:(NSString *)address
                          complete:(AdpaterComplete)complete;

/**
 *  删除公司
 *
 *  @param companyId  公司id
 *  @param complete  请求成功
*/
- (void)deleteCompanyWithCompanyId:(NSInteger)companyId
                          complete:(AdpaterComplete)complete;

/**
 * 公司总数
 */
- (NSInteger)numberOfCompanyList;

/**
 *  返回公司对象
*/
- (FMCompanyModel *)getCompanyModelWithIndex:(NSInteger)index;

/**
 *  修改公司对象
*/
- (void)replaceCompanyWithNewCompany:(FMCompanyModel *)model;


/**
 *  插入公司对象
*/
- (void)insertCompany:(FMCompanyModel *)model;

/**
 *  选择员工
*/
- (void)didSelectedCompanyWithCompanyId:(NSInteger)companyId;


@end

