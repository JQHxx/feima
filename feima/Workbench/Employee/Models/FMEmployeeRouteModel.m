//
//  FMEmployeeRouteModel.m
//  feima
//
//  Created by fei on 2020/8/31.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMEmployeeRouteModel.h"


@implementation FMWorkRouteModel



@end


@implementation FMEmployeeRouteModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"workRoute": FMWorkRouteModel.class,
             @"employee": FMEmployeeModel.class
    };
}

@end
