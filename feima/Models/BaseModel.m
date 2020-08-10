//
//  BaseModel.m
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)encodeWithCoder:(NSCoder *)coder {
    [self yy_modelEncodeWithCoder:coder];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    return [self yy_modelInitWithCoder:coder];
}

-  (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

@end
