//
//  FMVisitViewModel.h
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMGoodsModel.h"
#import "FMOrderSellModel.h"
#import "FMVisitRateModel.h"
#import "FMCustomerVisitModel.h"

@interface FMVisitViewModel : BaseViewModel

@property (nonatomic,assign) NSInteger  importantSum;
@property (nonatomic, copy ) NSArray <FMOrderSellModel *> *orderSellStatistics;
@property (nonatomic, copy ) FMVisitRateModel *visitRate;

/**
 *  商品列表(权限控制) （销售）
 *
 *  @param complete  请求成功
*/
- (void)loadEmployeeGoodsListWithComplete:(AdpaterComplete)complete;

/**
 * 商品总数
 */
- (NSInteger)numberOfGoodsList;

/**
 *  返回商品对象
*/
- (FMGoodsModel *)getGoodsModelWithIndex:(NSInteger)index;


/**
 *  本品在售商品列表 （库存）
 *
 *  @param complete  请求成功
*/
- (void)loadSalesGoodsListWithComplete:(AdpaterComplete)complete;

/**
 * 库存商品总数
 */
- (NSInteger)numberOfStockGoodsList;

/**
 *  返回库存商品对象
*/
- (FMGoodsModel *)getStockGoodsModelWithIndex:(NSInteger)index;

/**
 *  更改商品信息
*/
- (void)replaceGoodsModelWithNewGoods:(FMGoodsModel *)model;


/**
 *  竞品在售商品列表
 *
 *  @param complete  请求成功
*/
- (void)loadCompeteGoodsListWithComplete:(AdpaterComplete)complete;

/**
 *  竞品在售商品列表
*/
- (NSArray<FMGoodsModel *> *)getAllCompeteGoodsList;

/**
 *  更改竞品商品信息
*/
- (void)replaceCompetitorGoodsModelWithNewGoods:(FMGoodsModel *)model;


/**
 *  离店，添加拜访记录
 *
 *  @param customerId  客户id
 *  @param visitRecordInfo  拜访记录信息
 *  @param goodSellInfo  商品信息
 *  @param goodStockInfo  商品库存信息
 *  @param competeGoodsInfo  竞品信息
 *  @param complete  请求成功
*/
- (void)addVisitRecordWithCustomerId:(NSInteger)customerId
                     visitRecordInfo:(NSString *)visitRecordInfo
                        goodSellInfo:(NSString *)goodSellInfo
                       goodStockInfo:(NSString *)goodStockInfo
                    competeGoodsInfo:(NSString *)competeGoodsInfo
                            complete:(AdpaterComplete)complete;

/**
 *  获取拜访记录
 *
 *  @param customerId  客户id
 *  @param sTime  开始时间
 *  @param eTime  结束时间
 *  @param complete  请求成功
*/
- (void)loadVisitRecordDataWithCustomerId:(NSInteger)customerId
                                    sTime:(NSInteger)sTime
                                    eTime:(NSInteger)eTime
                                 complete:(AdpaterComplete)complete;

/**
 * 拜访记录数
 */
- (NSInteger)numberOfVisitRecordList;

/**
 *  返回拜访记录对象
*/
- (FMCustomerVisitModel *)getVisitRecordModelWithIndex:(NSInteger)index;

@end

