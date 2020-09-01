//
//  FMVisitRateModel.m
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMVisitRateModel.h"

@implementation FMRateModel



@end

@implementation FMVisitRateModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"visitRates": [FMRateModel class]};
}

@end
