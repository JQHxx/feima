//
//  FMVisitViewModel.h
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMGoodsModel.h"

@interface FMVisitViewModel : BaseViewModel

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



@end

