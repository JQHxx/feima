//
//  FMPunchRecordBottomView.m
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMPunchRecordBottomView.h"
#import "UIButton+Extend.h"

#define kBtnCap (kScreen_Width-280)/2.0

@interface FMPunchRecordBottomView ()

@property (nonatomic, strong) UIView   *line;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) UIButton *upBtn;
@property (nonatomic, strong) UIButton *downBtn;

@end

@implementation FMPunchRecordBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.timeBtn];
        [self addSubview:self.upBtn];
        [self addSubview:self.downBtn];
        [self addSubview:self.line];
    }
    return self;
}

#pragma mark -- Event response
#pragma mark 选择月份
- (void)chooseMonthAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bottomViewDidSelectedMonth)]) {
        [self.delegate bottomViewDidSelectedMonth];
    }
}

#pragma mark 上月或下月
- (void)arrowClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bottomViewDidClickActionWithIndex:)]) {
        [self.delegate bottomViewDidClickActionWithIndex:sender.tag];
    }
}

#pragma mark -- Getters
#pragma mark 选择月份
- (UIButton *)timeBtn {
    if (!_timeBtn) {
        _timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 5, 60, 50)];
        [_timeBtn setImage:ImageNamed(@"record_time") forState:UIControlStateNormal];
        [_timeBtn setTitle:@"选择月份" forState:UIControlStateNormal];
        [_timeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = [UIFont regularFontWithSize:12];
        _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _timeBtn.imageEdgeInsets = UIEdgeInsetsMake(-_timeBtn.titleLabel.intrinsicContentSize.height-4, -_timeBtn.intrinsicContentSize.height, 0, -_timeBtn.intrinsicContentSize.width);
        _timeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_timeBtn.imageView.width, -_timeBtn.imageView.height-4, 0);
        [_timeBtn addTarget:self action:@selector(chooseMonthAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeBtn;
}

#pragma mark 前一月
- (UIButton *)upBtn {
    if (!_upBtn) {
        _upBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.timeBtn.right+kBtnCap, 5, 60, 50)];
        [_upBtn setImage:ImageNamed(@"page_up") forState:UIControlStateNormal];
        [_upBtn setTitle:@"前一月" forState:UIControlStateNormal];
        [_upBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _upBtn.titleLabel.font = [UIFont regularFontWithSize:12];
        _upBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _upBtn.imageEdgeInsets = UIEdgeInsetsMake(-_upBtn.titleLabel.intrinsicContentSize.height-4, -_upBtn.intrinsicContentSize.height, 0, -_upBtn.intrinsicContentSize.width);
        _upBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_upBtn.imageView.width, -_upBtn.imageView.height-4, 0);
        _upBtn.tag = 0;
        [_upBtn addTarget:self action:@selector(arrowClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upBtn;
}

#pragma mark 选择月份
- (UIButton *)downBtn {
    if (!_downBtn) {
        _downBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.upBtn.right+kBtnCap, 5, 60, 50)];
        [_downBtn setImage:ImageNamed(@"page_down") forState:UIControlStateNormal];
        [_downBtn setTitle:@"后一月" forState:UIControlStateNormal];
        [_downBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _downBtn.titleLabel.font = [UIFont regularFontWithSize:12];
        _downBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _downBtn.imageEdgeInsets = UIEdgeInsetsMake(-_downBtn.titleLabel.intrinsicContentSize.height-4, -_downBtn.intrinsicContentSize.height, 0, -_downBtn.intrinsicContentSize.width);
        _downBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_downBtn.imageView.width, -_downBtn.imageView.height-4, 0);
        _downBtn.tag = 1;
        [_downBtn addTarget:self action:@selector(arrowClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
        _line.backgroundColor = [UIColor lineColor];
    }
    return _line;
}

@end
