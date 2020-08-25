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

#pragma mark 配货数
- (NSInteger)numberOfOrderList {
    return self.orderList.count;
}

#pragma mark 配货对象
- (FMOrderModel *)getOrderModelWithIndex:(NSInteger)index {
    FMOrderModel *model = [self.orderList safe_objectAtIndex:index];
    return model;
}

@end
