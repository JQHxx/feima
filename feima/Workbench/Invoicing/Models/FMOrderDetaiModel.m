//
//  FMOrderDetaiModel.m
//  feima
//
//  Created by fei on 2020/8/25.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMOrderDetaiModel.h"

@implementation FMOrderDetaiModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods": FMGoodsModel.class,
             @"orderGoodsDetail": FMOrderGoodsModel.class};
}

@end
