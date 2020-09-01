//
//  FMOrderSellModel.m
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMOrderSellModel.h"

@implementation FMOrderSellDetailModel



@end

@implementation FMOrderSellModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderSellDetail": FMOrderSellDetailModel.class,
             @"goods": FMGoodsModel.class
    };
}

@end
