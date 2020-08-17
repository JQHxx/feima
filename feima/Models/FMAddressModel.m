//
//  FMAddressModel.m
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAddressModel.h"

@implementation FMAddressModel

- (NSString *)detailAddress{
    if (_detailAddress) {
        return _detailAddress;
    }
    
    NSString *adresss = @"";
    if(!kIsEmptyString(self.province)){
        adresss = [adresss stringByAppendingString:self.province];
    }
    if (!kIsEmptyString(self.city)) {
        adresss = [adresss stringByAppendingString:self.city];
    }
    if (!kIsEmptyString(self.district)) {
        adresss = [adresss stringByAppendingString:self.district];
    }
    if (!kIsEmptyString(self.town)) {
        adresss = [adresss stringByAppendingString:self.town];
    }
    if (!kIsEmptyString(self.street)) {
        adresss = [adresss stringByAppendingString:self.street];
    }
    if (!kIsEmptyString(self.streetNumber)) {
        adresss = [adresss stringByAppendingString:self.streetNumber];
    }
    if (!kIsEmptyString(self.locationDescribe)) {
        adresss = [adresss stringByAppendingString:self.locationDescribe];
    }
    return adresss;
}

@end
