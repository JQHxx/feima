//
//  FMLocationManager.m
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMLocationManager.h"

@interface FMLocationManager()<BMKLocationManagerDelegate,BMKLocationAuthDelegate>

@property (nonatomic ,strong) BMKLocationManager *locationManager;

@end

static FMLocationManager * _instance = nil;
@implementation FMLocationManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone ];
        [_instance locationManager];
    });
    return _instance;
}

+ (instancetype) sharedInstance {
    if (_instance == nil) {
        _instance = [[super alloc]init];
    }
    return _instance;
}

- (BMKLocationManager *)locationManager {
    if(!_locationManager){
        [[BMKLocationAuth sharedInstance] checkPermisionWithKey:key_baidu_ak authDelegate:self];
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        _locationManager.allowsBackgroundLocationUpdates = NO;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    return _locationManager;
}

- (void)getAddressDetail:(void (^)(FMAddressModel *))block {
    [self.locationManager requestLocationWithReGeocode:true withNetworkState:true completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            FMAddressModel *moel = [[FMAddressModel alloc]init];
            
            if (error) {
                MyLog(@"%@", [NSString stringWithFormat:@"error:%@",[error.userInfo valueForKey:@"NSLocalizedDescription"]]);
            }else{
                MyLog(@"location ---longitude:%.6f,latitude:%.6f, %@%@%@%@%@%@",location.location.coordinate.longitude,location.location.coordinate.latitude,location.rgcData.province,location.rgcData.city,location.rgcData.district,location.rgcData.street,location.rgcData.town,location.rgcData.locationDescribe);
                moel.latitude = location.location.coordinate.latitude;
                moel.longitude = location.location.coordinate.longitude;
                moel.province = location.rgcData.province;
                moel.city = location.rgcData.city;
                moel.district = location.rgcData.district;
                moel.street = location.rgcData.street;
                moel.streetNumber = location.rgcData.streetNumber;
                moel.town = location.rgcData.town;
                moel.locationDescribe = location.rgcData.locationDescribe;
                moel.userName = location.rgcData.locationDescribe;
            }
            block(moel);
        }];
}

#pragma mark --BMKLocationAuthDelegate
#pragma mark 定位授权
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    if(iError == BMKLocationAuthErrorSuccess){
        MyLog(@"定位授权成功");
    }else{
        MyLog(@"定位授权失败");
    }
}

#pragma mark -- BMKLocationManagerDelegate
#pragma mark 请求后台定位权限的回调方法
//为了适配app store关于新的后台定位的审核机制（app store要求如果开发者只配置了使用期间定位，则代码中不能出现申请后台定位的逻辑），当开发者在plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription时，需要在该delegate中调用后台定位api：[locationManager requestAlwaysAuthorization]。开发者如果只配置了NSLocationWhenInUseUsageDescription，且只有使用期间的定位需求，则无需在delegate中实现逻辑。
- (void)BMKLocationManager:(BMKLocationManager *)manager doRequestAlwaysAuthorization:(CLLocationManager *)locationManager {
    [locationManager requestAlwaysAuthorization];
}

#pragma mark 移动定位
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        MyLog(@"%@", [NSString stringWithFormat:@"error:%@",[error.userInfo valueForKey:@"NSLocalizedDescription"]]);
    }else{
        MyLog(@"didUpdateLocation ---location --- %@%@%@%@%@%@",location.rgcData.province,location.rgcData.city,location.rgcData.district,location.rgcData.street,location.rgcData.town,location.rgcData.locationDescribe);
    }
}

@end
