//
//  FMUserModel.m
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMUserModel.h"

@implementation FMUserBeanModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"users": FMUserModel.class};
}

@end

@implementation FMUserModel



@end
