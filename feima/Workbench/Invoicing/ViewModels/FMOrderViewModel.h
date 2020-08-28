//
//  FMOrderViewModel.h
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMOrderModel.h"
#import "FMOrderDetaiModel.h"

@interface FMOrderViewModel : BaseViewModel

/**
 *  配货列表
 *
 *  @param orderTypes 订单类型
 *  @param name      名称
 *  @param complete  请求成功
*/
- (void)loadOrderListWithOrderTypes:(NSString *)orderTypes
                               name:(NSString *)name
                           complete:(AdpaterComplete)complete;

/**
 *  查询配货详情
 *
 *  @param orderGoodsId 订单id
 *  @param complete  请求成功
*/
- (void)loadOrderDetailListWithOrderGoodsId:(NSInteger)orderGoodsId
                                   complete:(AdpaterComplete)complete;

/**
 *  申请配货
 *
 *  @param goodsInfo  商品信息
 *  @param complete  请求成功
*/
- (void)applyDistributionWithGoodsInfo:(NSString *)goodsInfo complete:(AdpaterComplete)complete;

/**
 *  申请退换货
 *
 *  @param goodsInfo  商品信息
 *  @param orderTypes  订单类型
 *  @param complete  请求成功
*/
- (void)applyReturnWithGoodsInfo:(NSString *)goodsInfo orderTypes:(NSString *)orderTypes complete:(AdpaterComplete)complete;

/**
 *  配货发货 退换货发货
 *
 *  @param type  0配货发货 1退货发货 2换货发货
 *  @param orderGoodsId  订单id
 *  @param complete  请求成功
*/
- (void)deliveryWithType:(NSInteger)type
            orderGoodsId:(NSInteger)orderGoodsId
                complete:(AdpaterComplete)complete;

/**
 *  同意配货  同意退货 同意换货
 *
 *  @param type  0同意配货 1同意退货  2同意换货
 *  @param orderGoodsId  订单id
 *  @param orderGoodsDetailInfo  订单详情
 *  @param complete  请求成功
*/
- (void)agreeOrderApplyWithType:(NSInteger)type
                   orderGoodsId:(NSInteger)orderGoodsId
           orderGoodsDetailInfo:(NSString *)orderGoodsDetailInfo
                       complete:(AdpaterComplete)complete;

/**
 *  拒绝配货  拒绝退货 拒绝换货
 *
 *  @param type  0拒绝配货 1拒绝退货  2拒绝换货
 *  @param orderGoodsId  订单id
 *  @param complete  请求成功
*/
- (void)refuseOrderApplyWithType:(NSInteger)type
                   orderGoodsId:(NSInteger)orderGoodsId
                       complete:(AdpaterComplete)complete;

/**
 *  配货完成  退货完成 换货完成
 *
 *  @param type  0配货完成 1退货完成  2换货完成
 *  @param orderGoodsId  订单id
 *  @param complete  请求成功
*/
- (void)confirmReceiptWithType:(NSInteger)type
                  orderGoodsId:(NSInteger)orderGoodsId
                      complete:(AdpaterComplete)complete;

/**
 * 配货数
 */
- (NSInteger)numberOfOrderList;

/**
 *  返回配货对象
*/
- (FMOrderModel *)getOrderModelWithIndex:(NSInteger)index;


/**
 *  商品数
*/
- (NSInteger)numberOfOrderGoodsList;

/**
 *  返回商品对象
*/
- (FMOrderDetaiModel *)getOrderGoodsModelWithIndex:(NSInteger)index;



@end

