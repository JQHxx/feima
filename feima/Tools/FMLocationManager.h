//
//  FMLocationManager.h
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationkit/BMKLocationAuth.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import "FMAddressModel.h"

@interface FMLocationManager : NSObject

+(instancetype) sharedInstance;

/**
 获取地理位置

 @param block 返回
 */
-(void)getAddressDetail:(void(^)(FMAddressModel *addressModel))block;

@end

