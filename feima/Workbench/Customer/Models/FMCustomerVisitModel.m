//
//  FMCustomerVisitModel.m
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerVisitModel.h"

@implementation FMVisitRecordInfoModel



@end

@implementation FMCompeteGoodsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc":@"description"};
}

@end

@implementation FMCustomerStockModel


@end

@implementation FMCustomerVisitModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"customerInfo": FMCustomerModel.class,
             @"visitRecordInfo": FMVisitRecordInfoModel.class,
             @"goodSellInfos" : [FMOrderSellModel class],
             @"competeGoodsInfos" : [FMCompeteGoodsModel class],
             @"customerStockInfos": [FMCustomerStockModel class]
    };
}

@end
