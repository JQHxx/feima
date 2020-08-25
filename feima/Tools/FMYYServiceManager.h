//
//  FMYYServiceManager.h
//  feima
//
//  Created by fei on 2020/8/21.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduTraceSDK/BaiduTraceSDK.h>

typedef NS_ENUM(NSUInteger, ServiceOperationType) {
    YY_SERVICE_OPERATION_TYPE_START_SERVICE,
    YY_SERVICE_OPERATION_TYPE_STOP_SERVICE,
    YY_SERVICE_OPERATION_TYPE_START_GATHER,
    YY_SERVICE_OPERATION_TYPE_STOP_GATHER,
};


@interface FMYYServiceManager : NSObject<BTKTraceDelegate>

+(FMYYServiceManager *)defaultManager;

/**
 标志是否已经开始采集
 */
@property (nonatomic, assign) BOOL isServiceStarted;


/**
 开启轨迹服务

 @param startServiceOption 开启服务的选项
 */
-(void)startServiceWithOption:(BTKStartServiceOption *)startServiceOption;

/**
 停止轨迹服务
 */
-(void)stopGather;

@end

