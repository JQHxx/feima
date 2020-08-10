//
//  FMOrderModel.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMOrderModel.h"

@implementation FMOrderModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"employee": FMEmployeeModel.class,
             @"orderGoods": FMOrderGoodsModel.class};
}

@end
