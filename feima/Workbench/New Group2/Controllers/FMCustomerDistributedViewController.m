//
//  FMCustomerDistributedViewController.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerDistributedViewController.h"
#import "FMCustomerViewController.h"
#import "FMDistributedBottomView.h"
#import "FMHomepageViewController.h"
#import "FMCustomerModel.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h> //引入地图功能所有的头文件

@interface FMCustomerDistributedViewController ()

@property (nonatomic, strong) UIButton      *listBtn;
@property (nonatomic, strong) BMKMapView    *mapView; //百度地图
@property (nonatomic, strong) FMDistributedBottomView *bottomView;

@end

@implementation FMCustomerDistributedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"客户分布";
    
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
#pragma mark 列表
- (void)showListAction:(UIButton *)sender {
    FMCustomerModel *model = [[FMCustomerModel alloc] init];
    model.businessName = @"俊哥铺子";
    model.contactName = @"俊哥";
    model.telephone = 18974022637;
    model.employeeName = @"业务员";
    model.address = @"湖南省长沙市岳麓区文轩路185号靠近成城工业园文轩路185号靠近成城工业园";
    model.statusName = @"未拜访";
    model.nickName = @"铺子";
    model.industryName =  @"商超";
    model.gradeName = @"C";
    model.displayArea = 3;
    model.progressName = @"签约";
    model.employeeName = @"李氏";
    FMHomepageViewController *homepageVC = [[FMHomepageViewController alloc] init];
    homepageVC.customer = model;
    [self.navigationController pushViewController:homepageVC animated:YES];
    /*
    FMCustomerViewController *customerVC = [[FMCustomerViewController alloc] init];
    customerVC.isShowList = YES;
    [self.navigationController pushViewController:customerVC animated:YES];
     */
}

#pragma mark 客户管理
- (void)showCustomerManagerAction:(UITapGestureRecognizer *)sender {
    FMCustomerViewController *customerVC = [[FMCustomerViewController alloc] init];
    customerVC.isShowList = NO;
    [self.navigationController pushViewController:customerVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark 界面初始化
- (void)setupView {
    [self.view addSubview:self.listBtn];
    [self.listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(kStatusBar_Height+1);
        make.size.mas_equalTo(CGSizeMake(42, 42));
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
- (UIButton *)listBtn {
    if (!_listBtn) {
        _listBtn = [[UIButton alloc] init];
        [_listBtn setImage:ImageNamed(@"customer_list") forState:UIControlStateNormal];
        [_listBtn addTarget:self action:@selector(showListAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listBtn;
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
        _bottomView.type = FMDistributedBottomViewTypeCustomer;
        _bottomView.customerCount = 186;
        [_bottomView addTapPressed:@selector(showCustomerManagerAction:) target:self];
    }
    return _bottomView;
}

@end
