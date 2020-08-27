//
//  FMOrderViewModel.m
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMOrderViewModel.h"

@interface FMOrderViewModel ()

@property (nonatomic,strong) NSMutableArray *orderList;
@property (nonatomic,strong) NSArray <FMOrderDetaiModel *>*orderGoodsList;


@end

@implementation FMOrderViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.orderList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark 配货列表
- (void)loadOrderListWithOrderTypes:(NSString *)orderTypes
                               name:(NSString *)name
                           complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"orderTypes"] = orderTypes;
    parameters[@"name"] = name;
    [[HttpRequest sharedInstance] getRequestWithUrl:api_orderGoods_distribution_list parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSArray *data = [json safe_objectForKey:@"data"];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FMOrderModel class] json:data];
            [self.orderList removeAllObjects];
            [self.orderList addObjectsFromArray:arr];
            if (complete) {
                complete(YES);
            }
        } else {
            if (complete) {
                complete(NO);
            }
        }
    }];
}

#pragma mark 查询配货详情
- (void)loadOrderDetailListWithOrderGoodsId:(NSInteger)orderGoodsId complete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] getRequestWithUrl:api_orderGoods_detail_list parameters:@{@"orderGoodsId":@(orderGoodsId)} complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSArray *data = [json safe_objectForKey:@"data"];
            self.orderGoodsList = [NSArray yy_modelArrayWithClass:[FMOrderDetaiModel class] json:data];
            if (complete) {
                complete(YES);
            }
        } else {
            if (complete) {
                complete(NO);
            }
        }
    }];
}

#pragma mark 申请配货
- (void)applyDistributionWithGoodsInfo:(NSString *)goodsInfo
                              complete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] postWithUrl:api_orderGoods_distribution_apply parameters:@{@"goodsInfo":goodsInfo} complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) {
                complete(YES);
            }
        } else {
            if (complete) {
                complete(NO);
            }
        }
    }];
}

#pragma mark 申请退换货
- (void)applyReturnWithGoodsInfo:(NSString *)goodsInfo
                      orderTypes:(NSString *)orderTypes
                        complete:(AdpaterComplete)complete {
    NSString *url = [orderTypes isEqualToString:@"RETURN"] ? api_orderGoods_return_apply : api_orderGoods_exchange_apply;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"orderType"] = orderTypes;
    parameters[@"goodsInfo"] = goodsInfo;
    [[HttpRequest sharedInstance] postWithUrl:url parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) {
                complete(YES);
            }
        } else {
            if (complete) {
                complete(NO);
            }
        }
    }];
}

#pragma mark 配货发货 退换货发货
- (void)deliveryWithType:(NSInteger)type
            orderGoodsId:(NSInteger)oderGoodsId
                complete:(AdpaterComplete)complete {
    NSString *url = nil;
    if (type == 0) { //配货发货
        url = api_orderGoods_distribution_delivery;
    } else if (type == 1) { //退货发货
        url = api_orderGoods_return_delivery;
    } else { //换货发货
        url = api_orderGoods_exchange_delivery;
    }
    [[HttpRequest sharedInstance] postWithUrl:url parameters:@{@"oderGoodsId":@(oderGoodsId)} complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 同意配货  同意退货 同意换货
- (void)agreeOrderApplyWithType:(NSInteger)type
                   orderGoodsId:(NSInteger)oderGoodsId
           orderGoodsDetailInfo:(NSString *)orderGoodsDetailInfo
                       complete:(AdpaterComplete)complete {
    NSString *url = nil;
    if (type == 0) { //同意配货
        url = api_orderGoods_distribution_agree;
    } else if (type == 1) { //同意退货
        url = api_orderGoods_return_agree;
    } else { //同意换货
        url = api_orderGoods_exchange_agree;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oderGoodsId"] = @(oderGoodsId);
    parameters[@"orderGoodsDetailInfo"] = orderGoodsDetailInfo;
    [[HttpRequest sharedInstance] postWithUrl:url parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 拒绝配货  拒绝退货 拒绝换货
- (void)refuseOrderApplyWithType:(NSInteger)type
                    orderGoodsId:(NSInteger)oderGoodsId
                        complete:(AdpaterComplete)complete {
    NSString *url = nil;
    if (type == 0) { //拒绝配货
        url = api_orderGoods_distribution_refuse;
    } else if (type == 1) { //拒绝退货
        url = api_orderGoods_return_refuse;
    } else { //拒绝换货
        url = api_orderGoods_exchange_refuse;
    }
    [[HttpRequest sharedInstance] postWithUrl:url parameters:@{@"oderGoodsId":@(oderGoodsId)} complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 配货完成 退货完成
- (void)confirmReceiptWithType:(NSInteger)type
                  orderGoodsId:(NSInteger)oderGoodsId
                      complete:(AdpaterComplete)complete {
    NSString *url = nil;
    if (type == 0) { //配货完成
        url = api_orderGoods_distribution_confirm;
    } else if (type == 1) { //退货完成
        url = api_orderGoods_return_confirm;
    } else { //换货完成
        url = api_orderGoods_exchange_confirm;
    }
    [[HttpRequest sharedInstance] postWithUrl:url parameters:@{@"oderGoodsId":@(oderGoodsId)} complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 配货数
- (NSInteger)numberOfOrderList {
    return self.orderList.count;
}

#pragma mark 配货对象
- (FMOrderModel *)getOrderModelWithIndex:(NSInteger)index {
    FMOrderModel *model = [self.orderList safe_objectAtIndex:index];
    return model;
}

#pragma mark 配货商品数
- (NSInteger)numberOfOrderGoodsList {
    return self.orderGoodsList.count;
}

- (FMOrderDetaiModel *)getOrderGoodsModelWithIndex:(NSInteger)index {
    FMOrderDetaiModel *model = [self.orderGoodsList safe_objectAtIndex:index];
    return model;
}

@end
