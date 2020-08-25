//
//  FMInstrucationModel.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInstrucationModel.h"

@implementation FMInstrucationModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"employees" : [FMEmployeeModel class]};
}

@end
