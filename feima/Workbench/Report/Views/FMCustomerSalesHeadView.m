//
//  FMCustomerSalesHeadView.m
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerSalesHeadView.h"
#import "FMDateToolView.h"

@interface FMCustomerSalesHeadView ()<FMDateToolViewDelegate>

@property (nonatomic, strong) UIView   *rootView;
@property (nonatomic, strong) FMDateToolView *dateView;
@property (nonatomic, strong) UIView   *circleView;
@property (nonatomic, strong) UIView   *circleview2;
@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, strong) UILabel  *valueLabel;
@property (nonatomic, strong) UILabel  *titleLabel;

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
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-16, 242));
    }];
    
    [self.rootView addSubview:self.dateView];
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(40);
    }];

    [self.rootView addSubview:self.circleView];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.rootView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(140, 140));
    }];
    
    
    [self.rootView addSubview:self.circleview2];
    [self.circleview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circleView.mas_top).offset(-8);
        make.left.mas_equalTo(self.circleView.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(140, 140));
    }];

    
    [self.rootView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circleView.mas_top);
        make.left.mas_equalTo(self.circleView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(140, 140));
    }];
    
    
    [self.rootView addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(40);
        make.left.mas_equalTo(self.bgView.mas_left).offset(0);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-5);
        make.height.mas_greaterThanOrEqualTo(40);
    }];
    
    [self.rootView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.valueLabel.mas_bottom);
        make.left.mas_equalTo(self.bgView.mas_left).offset(0);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-5);
        make.height.mas_equalTo(22);
    }];
    
}

- (void)setValueStr:(NSString *)valueStr {
    _valueStr = valueStr;
    self.valueLabel.text = valueStr;
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

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc] init];
        _circleView.backgroundColor = [UIColor colorWithHexString:@"#3AA1FF"];
        _circleView.alpha = 0.78;
        _circleView.layer.cornerRadius = 70;
    }
    return _circleView;
}

- (UIView *)circleview2 {
    if (!_circleview2) {
        _circleview2 = [[UIView alloc] init];
        _circleview2.backgroundColor = [UIColor colorWithHexString:@"#3AA1FF"];
        _circleview2.alpha = 0.39;
        _circleview2.layer.cornerRadius = 70;
    }
    return _circleview2;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"#3AA1FF"];
        _bgView.alpha = 0.55;
        _bgView.layer.cornerRadius = 70;
    }
    return _bgView;
}

#pragma mark 数值
- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont mediumFontWithSize:24];
        _valueLabel.textColor = [UIColor whiteColor];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.text = @"0/0";
    }
    return _valueLabel;
}

#pragma mark 标题
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont mediumFontWithSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"新增/总客户数";
    }
    return _titleLabel;
}

@end
