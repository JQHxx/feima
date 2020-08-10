//
//  FMMessageModel.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMessageModel.h"

@implementation FMMessageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"employee": FMEmployeeModel.class};
}

@end
