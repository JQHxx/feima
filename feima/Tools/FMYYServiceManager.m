//
//  FMYYServiceManager.m
//  feima
//
//  Created by fei on 2020/8/21.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMYYServiceManager.h"

@implementation FMYYServiceManager

+(FMYYServiceManager *)defaultManager {
    static FMYYServiceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMYYServiceManager alloc] init];
    });
    return manager;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _isServiceStarted = NO;
    }
    return self;
}

#pragma mark -- Public methods
#pragma mark 开启轨迹服务
-(void)startServiceWithOption:(BTKStartServiceOption *)startServiceOption {
    dispatch_async(GLOBAL_QUEUE, ^{
        [[BTKAction sharedInstance] startService:startServiceOption delegate:self];
    });
}

#pragma mark 停止轨迹服务
-(void)stopService {
    dispatch_async(GLOBAL_QUEUE, ^{
        [[BTKAction sharedInstance] stopService:self];
    });
}

#pragma mark 开始采集
-(void)startGather {
    dispatch_async(GLOBAL_QUEUE, ^{
        [[BTKAction sharedInstance] startGather:self];
    });
}

#pragma mark 停止采集
-(void)stopGather {
    dispatch_async(GLOBAL_QUEUE, ^{
        [[BTKAction sharedInstance] stopGather:self];
    });
}

#pragma mark - BTKTraceDelegate
#pragma mark 请求后台定位权限的回调方法
// 需要保活以及后台轨迹追踪时，需要在Info.plist文件中增加后台定位相关配置，同时实现此回调
-  (void)onRequestAlwaysLocationAuthorization:(CLLocationManager *)locationManager {
    [locationManager requestAlwaysAuthorization];
}

#pragma mark 开启轨迹服务的回调方法
- (void)onStartService:(BTKServiceErrorCode)error {
    // 维护状态标志
    if (error == BTK_START_SERVICE_SUCCESS ||
        error == BTK_START_SERVICE_SUCCESS_BUT_OFFLINE ||
        error == BTK_START_SERVICE_SUCCESS_BUT_NO_AUTH_TO_KEEP_ALIVE) {
        MyLog(@"轨迹服务开启成功");
        self.isServiceStarted = YES;
        [self startGather]; //开始采集
    } else {
        MyLog(@"轨迹服务开启失败");
    }
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_START_SERVICE_SUCCESS:
            title = @"轨迹服务开启成功";
            message = @"成功登录到服务端";
            break;
        case BTK_START_SERVICE_SUCCESS_BUT_OFFLINE:
            title = @"轨迹服务开启成功";
            message = @"当前网络不畅，未登录到服务端。网络恢复后SDK会自动重试";
            break;
        case BTK_START_SERVICE_PARAM_ERROR:
            title = @"轨迹服务开启失败";
            message = @"参数错误,点击右上角设置按钮设置参数";
            break;
        case BTK_START_SERVICE_INTERNAL_ERROR:
            title = @"轨迹服务开启失败";
            message = @"SDK服务内部出现错误";
            break;
        case BTK_START_SERVICE_NETWORK_ERROR:
            title = @"轨迹服务开启失败";
            message = @"网络异常";
            break;
        case BTK_START_SERVICE_AUTH_ERROR:
            title = @"轨迹服务开启失败";
            message = @"鉴权失败，请检查AK和MCODE等配置信息";
            break;
        case BTK_START_SERVICE_IN_PROGRESS:
            title = @"轨迹服务开启失败";
            message = @"正在开启服务，请稍后再试";
            break;
        case BTK_SERVICE_ALREADY_STARTED_ERROR:
            title = @"轨迹服务开启失败";
            message = @"已经成功开启服务，请勿重复开启";
            break;
        case BTK_START_SERVICE_SUCCESS_BUT_NO_AUTH_TO_KEEP_ALIVE:
            title = @"轨迹服务开启成功";
            message = @"轨迹服务开启成功，要求开启保活，但没有定位权限导致无法保活";
            break;
        default:
            title = @"通知";
            message = @"轨迹服务开启结果未知";
            break;
    }
    MyLog(@"onStartService,title:%@,message:%@",title,message);
}

#pragma mark 停止轨迹服务的回调方法
-(void)onStopService:(BTKServiceErrorCode)error {
    // 维护状态标志
    if (error == BTK_STOP_SERVICE_NO_ERROR) {
        NSLog(@"轨迹服务停止成功");
        self.isServiceStarted = NO;
    } else {
        NSLog(@"轨迹服务停止失败");
    }
    // 构造广播内容
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_STOP_SERVICE_NO_ERROR:
            title = @"轨迹服务停止成功";
            message = @"SDK已停止工作";
            break;
        case BTK_STOP_SERVICE_NOT_YET_STARTED_ERROR:
            title = @"轨迹服务停止失败";
            message = @"还没有开启服务，无法停止服务";
            break;
        case BTK_STOP_SERVICE_IN_PROGRESS:
            title = @"轨迹服务停止失败";
            message = @"正在停止服务，请稍后再试";
            break;
        default:
            title = @"通知";
            message = @"轨迹服务停止结果未知";
            break;
    }
    MyLog(@"onStopService,title:%@,message:%@",title,message);
}

#pragma mark  开启采集的回调方法
-(void)onStartGather:(BTKGatherErrorCode)error {
    // 维护状态标志
    if (error == BTK_START_GATHER_SUCCESS) {
        MyLog(@"开始采集成功");
    } else {
        MyLog(@"开始采集失败");
    }
    // 构造广播内容
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_START_GATHER_SUCCESS:
            title = @"开始采集成功";
            message = @"开始采集成功";
            break;
        case BTK_GATHER_ALREADY_STARTED_ERROR:
            title = @"开始采集失败";
            message = @"已经在采集轨迹，请勿重复开始";
            break;
        case BTK_START_GATHER_BEFORE_START_SERVICE_ERROR:
            title = @"开始采集失败";
            message = @"开始采集必须在开始服务之后调用";
            break;
        case BTK_START_GATHER_LOCATION_SERVICE_OFF_ERROR:
            title = @"开始采集失败";
            message = @"没有开启系统定位服务";
            break;
        case BTK_START_GATHER_LOCATION_ALWAYS_USAGE_AUTH_ERROR:
            title = @"开始采集失败";
            message = @"没有开启后台定位权限";
            break;
        case BTK_START_GATHER_INTERNAL_ERROR:
            title = @"开始采集失败";
            message = @"SDK服务内部出现错误";
            break;
        default:
            title = @"通知";
            message = @"开始采集轨迹的结果未知";
            break;
    }
    NSDictionary *info = @{@"type":@(YY_SERVICE_OPERATION_TYPE_START_GATHER),
                           @"title":title,
                           @"message":message,
                           };
    MyLog(@"onStartGather--info:%@",info);
}

#pragma mark 停止采集的回调方法
-(void)onStopGather:(BTKGatherErrorCode)error {
    // 维护状态标志
    if (error == BTK_STOP_GATHER_NO_ERROR) {
        MyLog(@"停止采集成功");
        [self stopService];
    } else {
        MyLog(@"停止采集失败");
    }
    // 构造广播内容
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_STOP_GATHER_NO_ERROR:
            title = @"停止采集成功";
            message = @"SDK停止采集本设备的轨迹信息";
            break;
        case BTK_STOP_GATHER_NOT_YET_STARTED_ERROR:
            title = @"开始采集失败";
            message = @"还没有开始采集，无法停止";
            break;
        default:
            title = @"通知";
            message = @"停止采集轨迹的结果未知";
            break;
    }
    NSDictionary *info = @{@"type":@(YY_SERVICE_OPERATION_TYPE_STOP_GATHER),
                           @"title":title,
                           @"message":message,
                           };
    MyLog(@"onStopGather---info:%@",info);
}


@end
