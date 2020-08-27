//
//  FMSelectGoodsModel.m
//  feima
//
//  Created by fei on 2020/8/26.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSelectGoodsModel.h"

@implementation FMSelectGoodsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods": FMGoodsModel.class,
             @"employeeGoods": FMOwnGoodsModel.class,
             @"employee": FMEmployeeModel.class
    };
}

@end
