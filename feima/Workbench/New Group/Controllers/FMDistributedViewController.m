//
//  FMDistributedViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDistributedViewController.h"
#import "FMEmployeeViewController.h"
#import "FMEmployeeListViewController.h"
#import "FMDistributedBottomView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h> //引入地图功能所有的头文件

@interface FMDistributedViewController ()

@property (nonatomic, strong) UIButton      *routeBtn; //历史路线
@property (nonatomic, strong) BMKMapView    *mapView; //百度地图
@property (nonatomic, strong) FMDistributedBottomView  *bottomView;

@end

@implementation FMDistributedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"员工分布";
    [self setupView];
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

#pragma mark -- Event response
#pragma mark 历史路线
- (void)showRouteListAction:(UIButton *)sender {
    FMEmployeeViewController *employeeVC = [[FMEmployeeViewController alloc] init];
    [self.navigationController pushViewController:employeeVC animated:YES];
}

#pragma mark 员工列表
- (void)showEmployeeListAction:(UIGestureRecognizer *)sender {
    FMEmployeeListViewController *listVC = [[FMEmployeeListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark -- Private methods
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
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(-(kTabBar_Height-39));
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-16, 46));
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
        [_routeBtn addTarget:self action:@selector(showRouteListAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _routeBtn;
}

#pragma mark 地图
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        [_mapView setZoomLevel:5];//精确到5米
        _mapView.userTrackingMode = BMKUserTrackingModeNone; //设定定位模式为普通模式
    }
    return _mapView;
}

#pragma mark 客户数
- (FMDistributedBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[FMDistributedBottomView alloc] init];
        _bottomView.type = FMDistributedBottomViewTypeEmployee;
        [_bottomView addTapPressed:@selector(showEmployeeListAction:) target:self];
    }
    return _bottomView;
}


@end
