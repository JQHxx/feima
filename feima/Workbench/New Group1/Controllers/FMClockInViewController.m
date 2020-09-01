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
#import "FMLocationManager.h"
#import "FMClockInViewModel.h"
#import "FMYYServiceManager.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h> //引入地图功能所有的头文件
 
@interface FMClockInViewController ()<FMLocationViewDelegate>

@property (nonatomic, strong) BMKMapView         *mapView; //百度地图
@property (nonatomic, strong) FMLocationView     *contentView;
@property (nonatomic, strong) UIButton           *toWorkBtn; //上班
@property (nonatomic, strong) UIButton           *offWorkBtn; //下班

@property (nonatomic, strong) FMAddressModel     *userAddress;
@property (nonatomic, strong) FMClockInViewModel *adapter;


@end

@implementation FMClockInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    [self setupView];
    [self startLocation];
    [self loadPunchTimesData];
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
    [self startLocation];
}

#pragma mark -- Event response
#pragma mark 打卡
- (void)clockInAction:(UIButton *)sender {
    FMClockInType type;
    NSString *startTime;
    NSString *endTime;
    if ([sender.currentTitle isEqualToString:@"上班打卡"]) {
        type = FMClockInTypeToWork;
        startTime = self.adapter.punchStartTime;
        endTime = self.adapter.punchEndTime;
    } else {
        type = FMClockInTypeOffWork;
        startTime = self.adapter.punchAfterStartTime;
        endTime = self.adapter.punchAfterEndTime;
    }
    kSelfWeak;
    [FMClockInAlertView showClockInAlertWithFrame:CGRectMake(0, 0, kScreen_Width-30, 400) type:type address:self.userAddress.detailAddress startTime:startTime endTime:endTime confirmAction:^(NSArray *images) {
        [weakSelf clockInWithType:type images:images];
    }];
}

#pragma mark -- Private methods
#pragma mark 定位
- (void)startLocation {
    kSelfWeak;
    [[FMLocationManager sharedInstance] getAddressDetail:^(FMAddressModel *addressModel) {
        weakSelf.userAddress = addressModel;
        [weakSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake(addressModel.latitude, addressModel.longitude) animated:YES];
        BMKPointAnnotation * point = [[BMKPointAnnotation alloc]init];
        point.coordinate = CLLocationCoordinate2DMake(addressModel.latitude, addressModel.longitude);;
        point.title = addressModel.street;
        [weakSelf.mapView addAnnotation:point];
        
        MyLog(@"rgc = %@",addressModel.detailAddress);
        weakSelf.contentView.addr = addressModel.detailAddress;
    }];
}

#pragma mark 获取打卡时间
- (void)loadPunchTimesData {
    [self.adapter loadPunchTimeDataComplete:^(BOOL isSuccess) {
        
    }];
}

#pragma mark 打卡
- (void)clockInWithType:(FMClockInType)type images:(NSArray *)images{
    kSelfWeak;
    [self.adapter addPunchRequetWithType:type address:self.userAddress.detailAddress images:images longtude:self.userAddress.longitude latitude:self.userAddress.latitude complete:^(BOOL isSuccess) {
        if (isSuccess) {
            if (type == FMClockInTypeToWork) { //上班打卡
                if (![FMYYServiceManager defaultManager].isServiceStarted) {
                    // 开启服务之间先配置轨迹服务的基础信息
                    BTKServiceOption *basicInfoOption = [[BTKServiceOption alloc] initWithAK:key_baidu_ak mcode:key_budle_identifier serviceID:key_baidu_service_id keepAlive:YES];
                    [[BTKAction sharedInstance] initInfo:basicInfoOption];
                    
                    // 开启服务
                    NSString *account = [FeimaManager sharedFeimaManager].userBean.account;
                    BTKStartServiceOption *startServiceOption = [[BTKStartServiceOption alloc] initWithEntityName:account];
                    [[FMYYServiceManager defaultManager] startServiceWithOption:startServiceOption];
                }
            } else {
                if ([FMYYServiceManager defaultManager].isServiceStarted) {
                    [[FMYYServiceManager defaultManager] stopGather];
                }
            }
            [weakSelf.view makeToast:@"打卡成功" duration:2.0 position:CSToastPositionCenter];
        }
    }];
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
        [_mapView setZoomLevel:17];//精确50米
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
        _toWorkBtn.adjustsImageWhenHighlighted = NO;
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
        _offWorkBtn.adjustsImageWhenHighlighted = NO;
        [_offWorkBtn setCircleCorner:UIRectCornerTopRight | UIRectCornerBottomRight radius:25];
        [_offWorkBtn addTarget:self action:@selector(clockInAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _offWorkBtn;
}

- (FMClockInViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMClockInViewModel alloc] init];
    }
    return _adapter;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

@end
