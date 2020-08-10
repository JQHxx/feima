//
//  FMStatisticsView.m
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMStatisticsView.h"
#import "FMCircleView.h"

@interface FMStatisticsView ()

@property (nonatomic, strong) FMCircleView *bgView;
@property (nonatomic, strong) FMCircleView *bgCircleView;
@property (nonatomic, strong) FMCircleView *rootView;
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

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(130, 130));
    }];
    
    [self addSubview:self.bgCircleView];
    [self.bgCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(150, 130));
    }];
    
    [self addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(129, 129));
    }];
}

#pragma mark -- Getters
- (FMCircleView *)bgView {
    if (!_bgView) {
        _bgView = [[FMCircleView alloc] init];
        _bgView.backgroundColor = RGB(179, 219, 254);
    }
    return _bgView;
}

- (FMCircleView *)bgCircleView {
    if (!_bgCircleView) {
        _bgCircleView = [[FMCircleView alloc] init];
        _bgCircleView.backgroundColor = RGB(179, 219, 254);
    }
    return _bgCircleView;
}

- (FMCircleView *)rootView {
    if (!_rootView) {
        _rootView = [[FMCircleView alloc] init];
        _rootView.backgroundColor = [UIColor colorWithHexString:@"#3AA1FF"];
    }
    return _rootView;
}

@end
