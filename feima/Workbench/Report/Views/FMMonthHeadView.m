//
//  FMMonthHeadView.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMonthHeadView.h"
#import "FMDateToolView.h"

@interface FMMonthHeadView()

@property (nonatomic, strong) UIView         *rootView;
@property (nonatomic, strong) FMDateToolView *dateView;
@property (nonatomic, strong) UILabel        *departmentLabel;

@end

@implementation FMMonthHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
        
        [self addSubview:self.rootView];
        [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(kScreen_Width-16, 50));
        }];
        
        [self.rootView addSubview:self.dateView];
        [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(30);
            make.width.mas_greaterThanOrEqualTo(110);
        }];
        
        [self.rootView addSubview:self.departmentLabel];
        [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(30);
            make.width.mas_greaterThanOrEqualTo(120);
        }];
    }
    return self;
}

#pragma mark -- Getters
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
    }
    return _dateView;
}

#pragma mark 部门
- (UILabel *)departmentLabel {
    if (!_departmentLabel) {
        _departmentLabel = [[UILabel alloc] init];
        _departmentLabel.font = [UIFont regularFontWithSize:16];
        _departmentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _departmentLabel.text = @"部门：市场销售部";
    }
    return _departmentLabel;
}

@end
