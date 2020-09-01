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
#import "FMCustomerViewModel.h"
#import "FMLocationManager.h"
#import "FMCustomerPopView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h> //引入地图功能所有的头文件

@interface FMCustomerDistributedViewController ()<BMKMapViewDelegate>

@property (nonatomic, strong) UIButton      *listBtn;
@property (nonatomic, strong) BMKMapView    *mapView; //百度地图
@property (nonatomic, strong) FMDistributedBottomView *bottomView;
@property (nonatomic, strong) UIView        *maskView;
@property (nonatomic, strong) FMCustomerPopView  *popView;

@property (nonatomic, strong) FMCustomerViewModel  *adapter;

@property (nonatomic, strong) NSMutableArray *customersData;

@end

@implementation FMCustomerDistributedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"客户分布";
    
    [self setupView];
    [self loadCustomerData];
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

#pragma mark -- BMKMapViewDelegate
#pragma mark 地图区域改变完成后会调用此接口
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MyLog(@"regionDidChangeAnimated");
    [self renderMapWithData];
}

#pragma mark 当点击一个annotation view时，调用此接口
- (void)mapView:(BMKMapView *)mapView clickAnnotationView:(BMKAnnotationView *)view {
    MyLog(@"clickAnnotationView");
    FMCustomerModel *customer;
    for (FMCustomerModel *model in self.customersData) {
        if (model.longitude == view.annotation.coordinate.longitude && model.latitude == view.annotation.coordinate.latitude) {
            customer = model;
            break;
        }
    }
    [self showPopViewWithModel:customer];
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    MyLog(@"didSelectAnnotationView");
}

#pragma mark 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]){
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation  reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = ImageNamed(@"location_annotatio");
        return annotationView;
    }
    return nil;
}

#pragma mark -- Event response
#pragma mark 列表
- (void)showListAction:(UIButton *)sender {
    FMCustomerViewController *customerVC = [[FMCustomerViewController alloc] init];
    customerVC.isShowList = YES;
    [self.navigationController pushViewController:customerVC animated:YES];
}

#pragma mark 客户管理
- (void)showCustomerManagerAction:(UITapGestureRecognizer *)sender {
    FMCustomerViewController *customerVC = [[FMCustomerViewController alloc] init];
    customerVC.isShowList = NO;
    [self.navigationController pushViewController:customerVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadCustomerData {
    kSelfWeak;
    FMPageModel *page = [[FMPageModel alloc] init];
    page.pageNum = 1;
    [self.adapter loadCustomerListWithPage:page latitude:0.0 longitude:0.0 contactName:nil visitCode:0 complete:^(BOOL isSuccess) {
        if (isSuccess) {
            NSInteger count = [weakSelf.adapter numberOfCustomerList];
            if (count > 0) {
                FMCustomerModel *model = [weakSelf.adapter getCustomerModelWithIndex:count/2];
                [weakSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake(model.latitude, model.longitude) animated:YES];
                [weakSelf renderMapWithData];
            }
        } else {
            [weakSelf.view makeToast:self.adapter.errorString duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark 地图渲染
- (void)renderMapWithData {
    //当前屏幕中心点的经纬度
     CGFloat centerLongitude = self.mapView.region.center.longitude;
     CGFloat centerLatitude = self.mapView.region.center.latitude;

     //当前屏幕显示范围的经纬度
     CLLocationDegrees pointssLongitudeDelta = self.mapView.region.span.longitudeDelta;
     CLLocationDegrees pointssLatitudeDelta = self.mapView.region.span.latitudeDelta;

     //左上角
     CGFloat leftUpLong = centerLongitude - pointssLongitudeDelta/2.0;
     CGFloat leftUpLati = centerLatitude - pointssLatitudeDelta/2.0;

     //右上角
     CGFloat rightUpLong = centerLongitude + pointssLongitudeDelta/2.0;
     CGFloat rightUpLati = centerLatitude - pointssLatitudeDelta/2.0;

     //左下角
     CGFloat leftDownLong = centerLongitude - pointssLongitudeDelta/2.0;
     CGFloat leftDownlati = centerLatitude + pointssLatitudeDelta/2.0;

     //右下角
     CGFloat rightDownLong = centerLongitude + pointssLongitudeDelta/2.0;
     CGFloat rightDownLati = centerLatitude + pointssLatitudeDelta/2.0;

     MyLog(@"\n 左上   %f,%f---------\n 右上   %f,%f-------\n 左下  %f,%f----- \n 右下  %f,%f",leftUpLong,leftUpLati,rightUpLong,rightUpLati,leftDownLong,leftDownlati,rightDownLong,rightDownLati);
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<[self.adapter numberOfCustomerList]; i++) {
        FMCustomerModel *model = [self.adapter getCustomerModelWithIndex:i];
        if (model.longitude > leftUpLong && model.longitude < rightUpLong && model.latitude > leftUpLati && model.latitude < leftDownlati ) {
            [tempArr addObject:model];
            MyLog(@"latitude:%.3f,longitude:%.3f",model.latitude,model.longitude);
            BMKPointAnnotation * point = [[BMKPointAnnotation alloc]init];
            point.coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
            [self.mapView addAnnotation:point];
        }
    }
    self.customersData = tempArr;
    self.bottomView.customerCount = tempArr.count;
}

#pragma mark 显示弹框
- (void)showPopViewWithModel:(FMCustomerModel *)model {
    [kKeyWindow addSubview:self.maskView];
    [kKeyWindow addSubview:self.popView];
    [self.popView displayViewWithModel:model];
    [UIView animateWithDuration:0.25 animations:^{
        self.popView.frame = CGRectMake(10, kScreen_Height-168-(kTabBar_Height-40), kScreen_Width-20, 168);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 关闭弹框
- (void)dismissMaskView {
    [UIView animateWithDuration:0.25 animations:^{
        self.popView.frame = CGRectMake(10, kScreen_Height, kScreen_Width-20, 168);
    } completion:^(BOOL finished) {
        if (self.popView) {
            [self.popView removeFromSuperview];
            self.popView = nil;
        }
        if (self.maskView) {
            [self.maskView removeFromSuperview];
            self.maskView = nil;
        }
    }];
}

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
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-(kTabBar_Height-39));
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 56));
    }];
}

#pragma mark -- Getters
#pragma mark 列表
- (UIButton *)listBtn {
    if (!_listBtn) {
        _listBtn = [[UIButton alloc] init];
        _listBtn.adjustsImageWhenHighlighted = NO;
        [_listBtn setImage:ImageNamed(@"customer_list") forState:UIControlStateNormal];
        [_listBtn addTarget:self action:@selector(showListAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listBtn;
}

#pragma mark 地图
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        [_mapView setZoomLevel:15];
        _mapView.delegate = self;
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

#pragma mark 蒙层
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50];
        [_maskView addTapPressed:@selector(dismissMaskView) target:self];
    }
    return _maskView;
}

#pragma mark 弹出视图
- (FMCustomerPopView *)popView {
    if (!_popView) {
        _popView = [[FMCustomerPopView alloc] initWithFrame:CGRectMake(10, kScreen_Height, kScreen_Width-20, 168)];
        kSelfWeak;
        _popView.clickAction = ^(FMCustomerModel *model) {
            [weakSelf dismissMaskView];
            FMHomepageViewController *homeVC = [[FMHomepageViewController alloc] init];
            homeVC.customer = model;
            [weakSelf.navigationController pushViewController:homeVC animated:YES];
        };
    }
    return _popView;
}

- (FMCustomerViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMCustomerViewModel alloc] init];
    }
    return _adapter;
}

- (NSMutableArray *)customersData {
    if (!_customersData) {
        _customersData = [[NSMutableArray alloc] init];
    }
    return _customersData;
}

@end
