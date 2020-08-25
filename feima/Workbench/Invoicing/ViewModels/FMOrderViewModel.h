//
//  FMOrderViewModel.h
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMOrderModel.h"

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
 * 配货数
 */
- (NSInteger)numberOfOrderList;

/**
 *  返回配货对象
*/
- (FMOrderModel *)getOrderModelWithIndex:(NSInteger)index;

@end

