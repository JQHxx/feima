//
//  FMCustomerChartView.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerChartView.h"

@interface FMCustomerChartView ()

@property (nonatomic,strong) UIView   *rootView;

@end

@implementation FMCustomerChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- Private methods
#pragma mark setup UI
- (void)setupUI {
    [self addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-20, 115));
    }];
    
}

#pragma mark -- Getters
#pragma mark root
- (UIView *)rootView {
    if (!_rootView) {
        _rootView = [[UIView alloc] init];
        _rootView.backgroundColor = [UIColor whiteColor];
        [_rootView drawShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 3) opacity:0.2 radius:4];
        _rootView.layer.cornerRadius = 4;
    }
    return _rootView;
}

@end
