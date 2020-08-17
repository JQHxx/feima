//
//  FMGoodsSalesDataModel.m
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMGoodsSalesModel.h"

@implementation FMGoodsSalesModel

@end

@implementation FMEmployeeGoodsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods": [FMGoodsSalesModel class]};
}

@end
