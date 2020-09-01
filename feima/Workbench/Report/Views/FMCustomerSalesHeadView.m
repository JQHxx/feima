//
//  FMCustomerSalesHeadView.m
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerSalesHeadView.h"
#import "FMDateToolView.h"
#import "FMStatisticsView.h"

@interface FMCustomerSalesHeadView ()<FMDateToolViewDelegate>

@property (nonatomic, strong) UIView   *rootView;
@property (nonatomic, strong) FMDateToolView *dateView;
@property (nonatomic, strong) FMStatisticsView *statisticsView;

@end

@implementation FMCustomerSalesHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
        
        [self setupUI];
    }
    return self;
}

#pragma mark -- FMDateToolViewDelegate
#pragma mark 设置时间
- (void)dateToolViewDidSelectedDate:(NSString *)date {
    NSInteger time = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:date format:@"yyyy.MM"];
    if (self.selDateBlock) {
        self.selDateBlock(time);
    }
}

#pragma mark 选择部门
- (void)dateToolViewDidSelectedOrganizationWithOriganizationId:(NSInteger)organizationId {
    if (self.selOrganiztionBlock) {
        self.selOrganiztionBlock(organizationId);
    }
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.top.mas_equalTo(7);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-16, 202));
    }];
    
    [self.rootView addSubview:self.dateView];
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(40);
    }];
    
    [self.rootView addSubview:self.statisticsView];
    [self.statisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateView.mas_bottom);
        make.centerX.mas_equalTo(self.rootView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
}

- (void)setValueStr:(NSString *)valueStr {
    _valueStr = valueStr;
    self.statisticsView.valueStr = valueStr;
}

#pragma mark -- Getters
#pragma mark root
- (UIView *)rootView {
    if (!_rootView) {
        _rootView = [[UIView alloc] init];
        _rootView.backgroundColor = [UIColor whiteColor];
        _rootView.layer.cornerRadius = 4;
        _rootView.clipsToBounds = YES;
    }
    return _rootView;
}

#pragma mark 时间选择
- (FMDateToolView *)dateView {
    if (!_dateView) {
        _dateView = [[FMDateToolView alloc] initWithFrame:CGRectZero type:FMDateToolViewTypeMonth];
        _dateView.delegate = self;
    }
    return _dateView;
}

#pragma mark 数据统计
- (FMStatisticsView *)statisticsView {
    if (!_statisticsView) {
        _statisticsView = [[FMStatisticsView alloc] initWithFrame:CGRectZero type:FMStatisticsViewTypeCustomer];
    }
    return _statisticsView;
}

@end
