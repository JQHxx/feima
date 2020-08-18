//
//  FMPunchRecordModel.m
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMPunchRecordModel.h"

@implementation FMRecordTypeModel


@end

@implementation FMPunchRecordModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"recordAfterType" : FMRecordTypeModel.class,
             @"recordType" : FMRecordTypeModel.class
    };
}

@end
