//
//  FMWorkRouteViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMWorkRouteViewController.h"
#import "FMDistributedBottomView.h"
#import "FMCustomerViewController.h"
#import "FMRouteRecordsViewController.h"
#import "FMCustomerViewModel.h"
#import "FMLocationManager.h"
#import "FMHistoryTrackViewModel.h"
#import "FMHistoryTrackPoint.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h> //引入地图功能所有的头文件

static double const EPSILON = 0.0001;
static NSString * const kStartPositionTitle = @"起点";
static NSString * const kEndPositionTitle = @"终点";

@interface FMWorkRouteViewController ()

@property (nonatomic, strong) UIButton      *routeBtn;
@property (nonatomic, strong) BMKMapView    *mapView; //百度地图
@property (nonatomic, strong) FMDistributedBottomView *bottomView;

@property (nonatomic, strong) FMHistoryTrackModel  *trackModel;

@property (nonatomic, copy) NSArray *historyPoints;

@property (nonatomic, strong) FMCustomerViewModel *customerAdapter;

@end

@implementation FMWorkRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"工作路线";
    
    [self setupView];
    [self startLocation];
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

#pragma mark -- Events response
#pragma mark 历史路线
- (void)showHistoryRouteAction:(UIButton *)sender {
    FMRouteRecordsViewController *recordsVC = [[FMRouteRecordsViewController alloc] init];
    [self.navigationController pushViewController:recordsVC animated:YES];
}

#pragma mark 客户管理
- (void)showCustomerManagerAction:(UITapGestureRecognizer *)sender {
    FMCustomerViewController *customerVC = [[FMCustomerViewController alloc] init];
    customerVC.isShowList = NO;
    [self.navigationController pushViewController:customerVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark 开始定位
- (void)startLocation {
    kSelfWeak;
    [[FMLocationManager sharedInstance] getAddressDetail:^(FMAddressModel *addressModel) {
        [weakSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake(addressModel.latitude, addressModel.longitude) animated:YES];
        BMKPointAnnotation * point = [[BMKPointAnnotation alloc]init];
        point.coordinate = CLLocationCoordinate2DMake(addressModel.latitude, addressModel.longitude);;
        [weakSelf.mapView addAnnotation:point];
        
        //查询历史轨迹
        [weakSelf queryHistoryTrack];
        
        //加载客户信息
        [weakSelf loadCustomersData];
    }];
}

#pragma mark 加载客户信息
- (void)loadCustomersData {
    FMPageModel *page = [[FMPageModel alloc] init];
    page.pageNum = 1;
    kSelfWeak;
    [self.customerAdapter loadCustomerListWithPage:page latitude:0.0 longitude:0.0 contactName:nil visitCode:0 complete:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.bottomView.customerCount = [weakSelf.customerAdapter numberOfCustomerList];
        } else {
            [weakSelf.view makeToast:self.customerAdapter.errorString duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark 查询历史轨迹
- (void)queryHistoryTrack {
    FMHistoryTrackViewModel *adapter = [[FMHistoryTrackViewModel alloc] init];
    adapter.completionHandler = ^(NSArray *points) {
        self.historyPoints = points;
        [self drawHistoryTrackWithPoint:points];
    };
    [adapter queryHistoryWithTrack:self.trackModel];
}

#pragma mark 绘制轨迹
- (void)drawHistoryTrackWithPoint:(NSArray *)points {
    // line代表轨迹
    CLLocationCoordinate2D coors[points.count];
    NSInteger count = 0;
    for (size_t i = 0; i < points.count; i++) {
        CLLocationCoordinate2D p = ((FMHistoryTrackPoint *)points[i]).coordinate;
        if (fabs(p.latitude) < EPSILON || fabs(p.longitude) < EPSILON) {
            continue;
        }
        count++;
        coors[i] = ((FMHistoryTrackPoint *)points[i]).coordinate;
    }
    BMKPolyline *line = [BMKPolyline polylineWithCoordinates:coors count:count];
    //起点
    BMKPointAnnotation *startAnnotation = [[BMKPointAnnotation alloc] init];
    startAnnotation.coordinate = coors[0];
    startAnnotation.title = kStartPositionTitle;
    // 终点annotation
    BMKPointAnnotation *endAnnotation = [[BMKPointAnnotation alloc] init];
    endAnnotation.coordinate = coors[count - 1];
    endAnnotation.title = kEndPositionTitle;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self mapViewFitForCoordinates:points];
        [self.mapView addOverlay:line];
        [self.mapView addAnnotation:startAnnotation];
        [self.mapView addAnnotation:endAnnotation];
    });
}

-(void)mapViewFitForCoordinates:(NSArray *)points {
    double minLat = 90.0;
    double maxLat = -90.0;
    double minLon = 180.0;
    double maxLon = -180.0;
    for (size_t i = 0; i < points.count; i++) {
        minLat = fmin(minLat, ((FMHistoryTrackPoint *)points[i]).coordinate.latitude);
        maxLat = fmax(maxLat, ((FMHistoryTrackPoint *)points[i]).coordinate.latitude);
        minLon = fmin(minLon, ((FMHistoryTrackPoint *)points[i]).coordinate.longitude);
        maxLon = fmax(maxLon, ((FMHistoryTrackPoint *)points[i]).coordinate.longitude);
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) * 0.5, (minLon + maxLon) * 0.5);
    BMKCoordinateSpan span;
    span.latitudeDelta = (maxLat - minLat) + 0.01;
    span.longitudeDelta = (maxLon - minLon) + 0.01;
    BMKCoordinateRegion region;
    region.center = center;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}

#pragma mark 界面初始化
- (void)setupView {
    [self.view addSubview:self.routeBtn];
    [self.routeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(kStatusBar_Height+1);
        make.size.mas_equalTo(CGSizeMake(65, 42));
    }];
    
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, kScreen_Height-kNavBar_Height));
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-(kTabBar_Height-39));
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 56));
    }];
}

#pragma mark -- Getters
#pragma mark 列表
- (UIButton *)routeBtn {
    if (!_routeBtn) {
        _routeBtn = [[UIButton alloc] init];
        [_routeBtn setTitle:@"历史路线" forState:UIControlStateNormal];
        [_routeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _routeBtn.titleLabel.font = [UIFont mediumFontWithSize:14];
        [_routeBtn addTarget:self action:@selector(showHistoryRouteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _routeBtn;
}

#pragma mark 地图
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        [_mapView setZoomLevel:19];
        _mapView.userTrackingMode = BMKUserTrackingModeNone; //设定定位模式为普通模式
    }
    return _mapView;
}

#pragma mark 客户数
- (FMDistributedBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[FMDistributedBottomView alloc] init];
        _bottomView.type = FMDistributedBottomViewTypeCustomer;
        [_bottomView addTapPressed:@selector(showCustomerManagerAction:) target:self];
    }
    return _bottomView;
}

- (FMCustomerViewModel *)customerAdapter {
    if (!_customerAdapter) {
        _customerAdapter = [[FMCustomerViewModel alloc] init];
    }
    return _customerAdapter;
}

- (FMHistoryTrackModel *)trackModel {
    if (!_trackModel) {
        _trackModel = [[FMHistoryTrackModel alloc] init];
        _trackModel.entityName = [FeimaManager sharedFeimaManager].userBean.account;
        _trackModel.startTime = [[NSDate date] timeIntervalSince1970] - 24 * 60 *60;
        _trackModel.endTime = [[NSDate date] timeIntervalSince1970];
        _trackModel.isProcessed = NO;
        
        // 设置纠偏选项
        BTKQueryTrackProcessOption *option = [[BTKQueryTrackProcessOption alloc] init];
        option.denoise = TRUE;  //设置纠偏时是否需要去噪
        option.vacuate = TRUE;  //设置纠偏时是否需要抽稀
        option.mapMatch = FALSE;  //设置纠偏时是否需要绑路
        option.radiusThreshold = 10; //设置定位精度过滤阈值，用于过滤掉定位精度较差的轨迹点
        option.transportMode = BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING; //查询纠偏后的实时位置时，指定被监控对象的交通方式
        _trackModel.processOption = option;
        _trackModel.supplementMode = BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING; //里程补偿
    }
    return _trackModel;
}

@end
