//
//  FMDateToolView.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDateToolView.h"
#import "NSDate+Extend.h"

@interface FMDateToolView ()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *valueBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, assign) FMDateToolViewType type;

@end

@implementation FMDateToolView

- (instancetype)initWithFrame:(CGRect)frame type:(FMDateToolViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self setupUI];
    }
    return self;
}

#pragma mark -- Events
#pragma mark 设置时间
- (void)selectedDateAction:(UIButton *)sender {
    
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self addSubview:self.valueBtn];
    [self.valueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(30);
    }];
    
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark -- Getters
#pragma mark 上一页
- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setImage:[UIImage drawImageWithName:@"arrow_left" size:CGSizeMake(22, 22)] forState:UIControlStateNormal];
        _leftBtn.tag = 0;
        [_leftBtn addTarget:self action:@selector(selectedDateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

#pragma mark 日期
- (UIButton *)valueBtn {
    if (!_valueBtn) {
        _valueBtn = [[UIButton alloc] init];
        [_valueBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _valueBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        NSString *dateStr = [NSDate currentYearMonthWithFormat:self.type == FMDateToolViewTypeMonth ? @"yyyy.MM":@"yyyy.MM.dd"];
        [_valueBtn setTitle:dateStr forState:UIControlStateNormal];
        _valueBtn.tag = 1;
        [_valueBtn addTarget:self action:@selector(selectedDateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _valueBtn;
}

#pragma mark 下一页
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setImage:[UIImage drawImageWithName:@"arrow_right" size:CGSizeMake(22, 22)] forState:UIControlStateNormal];
        _rightBtn.tag = 2;
        [_rightBtn addTarget:self action:@selector(selectedDateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
