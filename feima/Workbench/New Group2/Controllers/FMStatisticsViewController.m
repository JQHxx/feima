//
//  FMStatisticsViewController.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMStatisticsViewController.h"
#import "FMCustomerHeadView.h"
#import "FMCustomerChartView.h"

@interface FMStatisticsViewController ()

@property (nonatomic,strong) UIScrollView         *rootScrollView;
@property (nonatomic,strong) FMCustomerHeadView   *headView;
@property (nonatomic,strong) FMCustomerChartView  *chartView;


@end

@implementation FMStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"数据统计";
    
    [self setupUI];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNavBar_Height);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
    
    [self.rootScrollView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(140);
    }];
    
    [self.rootScrollView addSubview:self.chartView];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.height.mas_equalTo(140);
    }];
}

#pragma mark -- Getters
#pragma mark 滚动视图
- (UIScrollView *)rootScrollView {
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] init];
    }
    return _rootScrollView;
}

#pragma mark 头部视图
- (FMCustomerHeadView *)headView {
    if (!_headView) {
        _headView = [[FMCustomerHeadView alloc] init];
        [_headView displayViewWithData:self.customer];
    }
    return _headView;
}

#pragma mark 图表
- (FMCustomerChartView *)chartView {
    if (!_chartView) {
        _chartView = [[FMCustomerChartView alloc] init];
    }
    return _chartView;
}


@end
