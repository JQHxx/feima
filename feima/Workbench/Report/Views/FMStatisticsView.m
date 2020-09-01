//
//  FMStatisticsView.m
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMStatisticsView.h"

@interface FMStatisticsView ()

@property (nonatomic, strong) UIView  *bgView;
@property (nonatomic, strong) UIView  *bgview2;
@property (nonatomic, strong) UIView  *rootView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) FMStatisticsViewType type;

@end

@implementation FMStatisticsView

- (instancetype)initWithFrame:(CGRect)frame type:(FMStatisticsViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        
        [self setupUI];
    }
    return self;
}

- (void)setValueStr:(NSString *)valueStr {
    _valueStr = valueStr;
    self.valueLabel.text = valueStr;
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(140, 140));
    }];
    
    [self addSubview:self.bgview2];
    [self.bgview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2);
        make.left.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(140, 140));
    }];

    [self addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(140, 140));
    }];
    
    [self addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rootView.mas_top).offset(30);
        make.left.mas_equalTo(self.rootView.mas_left).offset(0);
        make.right.mas_equalTo(self.rootView.mas_right).offset(-5);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.valueLabel.mas_bottom);
        make.left.mas_equalTo(self.rootView.mas_left).offset(0);
        make.right.mas_equalTo(self.rootView.mas_right).offset(-5);
        make.height.mas_equalTo(22);
    }];
}

#pragma mark -- Getters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = self.type == FMStatisticsViewTypeCustomer ? [UIColor colorWithHexString:@"#3AA1FF"]:[UIColor colorWithHexString:@"#17BB84"] ;
        _bgView.alpha = 0.78;
        _bgView.layer.cornerRadius = 70;
    }
    return _bgView;
}

- (UIView *)bgview2 {
    if (!_bgview2) {
        _bgview2 = [[UIView alloc] init];
        _bgview2.backgroundColor = self.type == FMStatisticsViewTypeCustomer ? [UIColor colorWithHexString:@"#3AA1FF"]:[UIColor colorWithHexString:@"#17BB84"] ;
        _bgview2.alpha = 0.39;
        _bgview2.layer.cornerRadius = 70;
    }
    return _bgview2;
}

- (UIView *)rootView {
    if (!_rootView) {
        _rootView = [[UIView alloc] init];
        _rootView.backgroundColor = self.type == FMStatisticsViewTypeCustomer ? [UIColor colorWithHexString:@"#3AA1FF"]:[UIColor colorWithHexString:@"#17BB84"] ;
        _rootView.alpha = 0.55;
        _rootView.layer.cornerRadius = 70;
    }
    return _rootView;
}

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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont mediumFontWithSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = self.type == FMStatisticsViewTypeCustomer ? @"新增/总客户数":@"打卡人数/应到人数";
    }
    return _titleLabel;
}

@end
