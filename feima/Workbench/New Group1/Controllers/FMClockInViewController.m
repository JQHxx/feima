//
//  FMClockInViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMClockInViewController.h"
#import "FMClockInRecordViewController.h"
#import "FMLocationView.h"
#import "FMClockInAlertView.h"
#import "UIView+Extend.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h> //引入地图功能所有的头文件
 
@interface FMClockInViewController ()<FMLocationViewDelegate,BMKLocationManagerDelegate>

//当前位置对象
@property (nonatomic, strong) BMKUserLocation    *userLocation;
//定位管理
@property (nonatomic, strong) BMKLocationManager *locationManager;
//单次定位返回Block
@property (nonatomic, copy ) BMKLocatingCompletionBlock completionBlock;
@property (nonatomic, strong) BMKMapView         *mapView; //百度地图
@property (nonatomic, strong) FMLocationView     *contentView;
@property (nonatomic, strong) UIButton           *toWorkBtn; //上班
@property (nonatomic, strong) UIButton           *offWorkBtn; //下班


@property (nonatomic, strong) NSMutableArray     *annotationArr;/** 标记数组*/
@property (nonatomic, strong) NSMutableArray     *circleArr;/** 圆形数组*/

@end

@implementation FMClockInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    [self setupView];
    [self initBlock];
    [self initLocation];
    [self startLoaction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.showsUserLocation = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}

#pragma mark -- Delegate
#pragma mark FMLocationViewDelegate
#pragma mark 返回
- (void)locationViewBackAction:(FMLocationView *)view {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 记录
- (void)locationViewPushToRecords:(FMLocationView *)view {
    FMClockInRecordViewController *clockRecordVC = [[FMClockInRecordViewController alloc] init];
    [self.navigationController pushViewController:clockRecordVC animated:YES];
}

#pragma mark 刷新
- (void)locationViewDidRefreshLocation:(FMLocationView *)view {
     [self startLoaction];
}


#pragma mark BMKLocationManagerDelegate
/**
 *  @brief 为了适配app store关于新的后台定位的审核机制（app store要求如果开发者只配置了使用期间定位，则代码中不能出现申请后台定位的逻辑），当开发者在plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription时，需要在该delegate中调用后台定位api：[locationManager requestAlwaysAuthorization]。开发者如果只配置了NSLocationWhenInUseUsageDescription，且只有使用期间的定位需求，则无需在delegate中实现逻辑。
*/
- (void)BMKLocationManager:(BMKLocationManager *)manager doRequestAlwaysAuthorization:(CLLocationManager *)locationManager {
    [locationManager requestAlwaysAuthorization];
}


#pragma mark -- Event response
#pragma mark 打卡
- (void)clockInAction:(UIButton *)sender {
    FMClockInAlertViewType type;
    if ([sender.currentTitle isEqualToString:@"上班打卡"]) {
        type = FMClockInAlertViewTypeToWork;
    } else {
        type = FMClockInAlertViewTypeOffWork;
    }
    [FMClockInAlertView showClockInAlertWithFrame:CGRectMake(0, 0, kScreen_Width-30, 400) type:type confirmAction:^{
        
    }];
}

#pragma mark -- Private methods
#pragma mark 初始化定位管理
- (void)initLocation {
    _locationManager = [[BMKLocationManager alloc] init];
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
    _locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
}

#pragma mark 定位完成
- (void)initBlock {
    __weak FMClockInViewController *weakSelf = self;
    self.completionBlock = ^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error) {
            MyLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        FMClockInViewController *strongSelf = weakSelf;
        if (location.location) { //得到定位信息，添加annotation
            MyLog(@"LOC = %@",location.location);
            MyLog(@"LOC ID= %@",location.locationID);
            
            if (location.rgcData.poiList) {
                for (BMKLocationPoi * poi in location.rgcData.poiList) {
                    MyLog(@"poi = %@, %@, %f, %@, %@", poi.name, poi.addr, poi.relaiability, poi.tags, poi.uid);
                }
            }
            
            if (location.rgcData.poiRegion) {
                MyLog(@"poiregion = %@, %@, %@", location.rgcData.poiRegion.name, location.rgcData.poiRegion.tags, location.rgcData.poiRegion.directionDesc);
            }
            
            if (!strongSelf.userLocation) {
                strongSelf.userLocation = [[BMKUserLocation alloc] init];
            }
            strongSelf.userLocation.location = location.location;
            [strongSelf.mapView updateLocationData:strongSelf.userLocation];
            
            CLLocationCoordinate2D mycoordinate = location.location.coordinate;
            strongSelf.mapView.centerCoordinate = mycoordinate;
        }
        
        
        if (location.rgcData) {
            MyLog(@"rgc = %@",[location.rgcData description]);
            strongSelf.contentView.addr = [NSString stringWithFormat:@"%@%@%@%@%@",location.rgcData.province,location.rgcData.city,location.rgcData.district,location.rgcData.town,location.rgcData.locationDescribe];
        }
        
    };
}

#pragma mark 开始定位
- (void)startLoaction {
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:self.completionBlock];
}

#pragma mark 界面初始化
- (void)setupView {
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 94));
    }];
    
    [self.view addSubview:self.toWorkBtn];
    [self.view addSubview:self.offWorkBtn];
}

#pragma mark -- Getters
#pragma mark 地图
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        [_mapView setZoomLevel:5];//精确到5米
        _mapView.userTrackingMode = BMKUserTrackingModeNone; //设定定位模式为普通模式
    }
    return _mapView;
}

#pragma mark 头部视图
- (FMLocationView *)contentView {
    if (!_contentView) {
        _contentView = [[FMLocationView alloc] init];
        _contentView.delegate = self;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

#pragma mark 上班
- (UIButton *)toWorkBtn {
    if (!_toWorkBtn) {
        _toWorkBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreen_Width-240)/2.0, kScreen_Height - kTabBar_Height-20, 120, 50)];
        _toWorkBtn.backgroundColor = [UIColor whiteColor];
        [_toWorkBtn setImage:ImageNamed(@"checkIn") forState:UIControlStateNormal];
        [_toWorkBtn setTitle:@"上班打卡" forState:UIControlStateNormal];
        [_toWorkBtn setTitleColor:[UIColor systemColor] forState:UIControlStateNormal];
        _toWorkBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        _toWorkBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_toWorkBtn setCircleCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:25];
        [_toWorkBtn addTarget:self action:@selector(clockInAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toWorkBtn;
}

#pragma mark 上班
- (UIButton *)offWorkBtn {
    if (!_offWorkBtn) {
        _offWorkBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width/2.0, kScreen_Height - kTabBar_Height-20, 120, 50)];
        _offWorkBtn.backgroundColor = [UIColor systemColor];
        [_offWorkBtn setImage:ImageNamed(@"off_work") forState:UIControlStateNormal];
        [_offWorkBtn setTitle:@"下班打卡" forState:UIControlStateNormal];
        [_offWorkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _offWorkBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        _offWorkBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_offWorkBtn setCircleCorner:UIRectCornerTopRight | UIRectCornerBottomRight radius:25];
        [_offWorkBtn addTarget:self action:@selector(clockInAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _offWorkBtn;
}

#pragma mark 标记数组
- (NSMutableArray *)annotationArr {
    if (!_annotationArr) {
        _annotationArr = [[NSMutableArray alloc] init];
    }
    return _annotationArr;
}


- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

@end
