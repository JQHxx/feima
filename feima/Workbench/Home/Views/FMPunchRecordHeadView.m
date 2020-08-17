//
//  FMPunchRecordHeadView.m
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMPunchRecordHeadView.h"

@interface FMPunchRecordHeadView ()

@property (nonatomic,strong) UIButton *allBtn;
@property (nonatomic,strong) UILabel  *notPunchLab;  //未打卡
@property (nonatomic,strong) UILabel  *punchLab;   //正常打卡
@property (nonatomic,strong) UILabel  *timeAbnormalLab;  //时间异常
@property (nonatomic,strong) UILabel  *lateLab;  //迟到
@property (nonatomic,strong) UILabel  *leaveLab; //早退

@end

@implementation FMPunchRecordHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        
        [self setupUI];
    }
    return self;
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    CGFloat cap = (kScreen_Width - 60*3)/6.0;
    
    [self addSubview:self.allBtn];
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cap);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(60, 80));
    }];
    
    [self addSubview:self.notPunchLab];
    [self.notPunchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.allBtn.mas_right).offset(cap*2);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(60, 80));
    }];
    
    [self addSubview:self.punchLab];
    [self.punchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.notPunchLab.mas_right).offset(cap*2);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(60, 80));
    }];
    
    [self addSubview:self.timeAbnormalLab];
    [self.timeAbnormalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cap);
        make.top.mas_equalTo(self.allBtn.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 80));
    }];
    
    [self addSubview:self.lateLab];
    [self.lateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.notPunchLab.mas_left);
        make.top.mas_equalTo(self.timeAbnormalLab.mas_top);
        make.size.mas_equalTo(CGSizeMake(60, 80));
    }];
    
    [self addSubview:self.leaveLab];
    [self.leaveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.punchLab.mas_left);
        make.top.mas_equalTo(self.timeAbnormalLab.mas_top);
        make.size.mas_equalTo(CGSizeMake(60, 80));
    }];
}

#pragma mark set lab
- (UILabel *)setupLabelWithText:(NSString *)text {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont regularFontWithSize:16];
    lab.text = text;
    lab.textColor = RGB(214, 215, 216);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    return lab;
}

#pragma mark -- Getters
#pragma mark 全部
- (UIButton *)allBtn {
    if (!_allBtn) {
        _allBtn = [[UIButton alloc] init];
        _allBtn.backgroundColor = [UIColor systemColor];
        [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _allBtn.titleLabel.font = [UIFont regularFontWithSize:16];
    }
    return _allBtn;
}

#pragma mark 未打卡
- (UILabel *)notPunchLab {
    if (!_notPunchLab) {
        _notPunchLab = [self setupLabelWithText:@"未打卡"];
    }
    return _notPunchLab;
}

#pragma mark 正常打卡
- (UILabel *)punchLab {
    if (!_punchLab) {
        _punchLab = [self setupLabelWithText:@"正常打卡"];
    }
    return _punchLab;
}

#pragma mark 时间一长
- (UILabel *)timeAbnormalLab {
    if (!_timeAbnormalLab) {
        _timeAbnormalLab = [self setupLabelWithText:@"时间异常"];
    }
    return _timeAbnormalLab;
}

#pragma mark 迟到
- (UILabel *)lateLab {
    if (!_lateLab) {
        _lateLab = [self setupLabelWithText:@"迟到"];
    }
    return _lateLab;
}

#pragma mark 早退
- (UILabel *)leaveLab {
    if (!_leaveLab) {
        _leaveLab = [self setupLabelWithText:@"早退"];
    }
    return _leaveLab;
}

@end
