//
//  FMPunchRecordHeadView.m
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMPunchRecordHeadView.h"
#import "BRDatePickerView.h"

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

#pragma mark -- event response
#pragma mark 选择状态
- (void)selectedStatusAction:(UIGestureRecognizer *)sender {
    NSInteger tag = sender.view.tag;
    NSString *status = [NSString stringWithFormat:@"%ld",tag];
    if ([self.delegate respondsToSelector:@selector(headViewDidSelectedStatus:)]) {
        [self.delegate headViewDidSelectedStatus:status];
    }
}

#pragma mark 选择全部
- (void)selectedAllAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(headViewDidSelectedStatus:)]) {
        [self.delegate headViewDidSelectedStatus:@""];
    }
}

#pragma mark 填充数据
- (void)dispalyViewWithStatusData:(NSArray<FMPunchStatusModel *> *)data {
    for (FMPunchStatusModel *model in data) {
        if (model.status == 0) {
            if (model.number >0) {
                self.notPunchLab.textColor = [UIColor colorWithHexString:@"#666666"];
                self.notPunchLab.text = [NSString stringWithFormat:@"%ld\n未打卡",model.number];
                self.notPunchLab.userInteractionEnabled = YES;
            } else {
                self.notPunchLab.textColor = RGB(214, 215, 216);
                self.notPunchLab.text = @"未打卡";
                self.notPunchLab.userInteractionEnabled = NO;
            }
        } else if (model.status == 1) {
            if (model.number >0) {
                self.punchLab.textColor = [UIColor colorWithHexString:@"#666666"];
                self.punchLab.text = [NSString stringWithFormat:@"%ld\n正常打卡",model.number];
                self.punchLab.userInteractionEnabled = YES;
            } else {
                self.punchLab.textColor = RGB(214, 215, 216);
                self.punchLab.text = @"正常打卡";
                self.punchLab.userInteractionEnabled = NO;
            }
        } else if (model.status == 2) {
            if (model.number >0) {
                self.timeAbnormalLab.textColor = [UIColor colorWithHexString:@"#666666"];
                self.timeAbnormalLab.text = [NSString stringWithFormat:@"%ld\n时间异常",model.number];
                self.timeAbnormalLab.userInteractionEnabled = YES;
            } else {
                self.timeAbnormalLab.textColor = RGB(214, 215, 216);
                self.timeAbnormalLab.text = @"时间异常";
                self.timeAbnormalLab.userInteractionEnabled = NO;
            }
        } else if(model.status ==3) {
            if (model.number >0) {
                self.lateLab.textColor = [UIColor colorWithHexString:@"#666666"];
                self.lateLab.text = [NSString stringWithFormat:@"%ld\n迟到",model.number];
                self.lateLab.userInteractionEnabled = YES;
            } else {
                self.lateLab.textColor = RGB(214, 215, 216);
                self.lateLab.text = @"迟到";
                self.lateLab.userInteractionEnabled = NO;
            }
        } else {
            if (model.number >0) {
                self.leaveLab.textColor = [UIColor colorWithHexString:@"#666666"];
                self.leaveLab.text = [NSString stringWithFormat:@"%ld\n早退",model.number];
                self.leaveLab.userInteractionEnabled = YES;
            } else {
                self.leaveLab.textColor = RGB(214, 215, 216);
                self.leaveLab.text = @"早退";
                self.leaveLab.userInteractionEnabled = NO;
            }
        }
    }
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    CGFloat cap = (kScreen_Width - 80*3)/6.0;
    
    [self addSubview:self.allBtn];
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cap);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self addSubview:self.notPunchLab];
    [self.notPunchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.allBtn.mas_right).offset(cap*2);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self addSubview:self.punchLab];
    [self.punchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.notPunchLab.mas_right).offset(cap*2);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self addSubview:self.timeAbnormalLab];
    [self.timeAbnormalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cap);
        make.top.mas_equalTo(self.allBtn.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self addSubview:self.lateLab];
    [self.lateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.notPunchLab.mas_left);
        make.top.mas_equalTo(self.timeAbnormalLab.mas_top);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self addSubview:self.leaveLab];
    [self.leaveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.punchLab.mas_left);
        make.top.mas_equalTo(self.timeAbnormalLab.mas_top);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

#pragma mark set lab
- (UILabel *)setupLabelWithText:(NSString *)text tag:(NSInteger)tag{
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont regularFontWithSize:16];
    lab.text = text;
    lab.textColor = RGB(214, 215, 216);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.tag = tag;
    [lab addTapPressed:@selector(selectedStatusAction:) target:self];
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
        [_allBtn addTarget:self action:@selector(selectedAllAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allBtn;
}

#pragma mark 未打卡
- (UILabel *)notPunchLab {
    if (!_notPunchLab) {
        _notPunchLab = [self setupLabelWithText:@"未打卡" tag:0];
    }
    return _notPunchLab;
}

#pragma mark 正常打卡
- (UILabel *)punchLab {
    if (!_punchLab) {
        _punchLab = [self setupLabelWithText:@"正常打卡" tag:1];
    }
    return _punchLab;
}

#pragma mark 时间一长
- (UILabel *)timeAbnormalLab {
    if (!_timeAbnormalLab) {
        _timeAbnormalLab = [self setupLabelWithText:@"时间异常" tag:2];
    }
    return _timeAbnormalLab;
}

#pragma mark 迟到
- (UILabel *)lateLab {
    if (!_lateLab) {
        _lateLab = [self setupLabelWithText:@"迟到" tag:3];
    }
    return _lateLab;
}

#pragma mark 早退
- (UILabel *)leaveLab {
    if (!_leaveLab) {
        _leaveLab = [self setupLabelWithText:@"早退" tag:4];
    }
    return _leaveLab;
}

@end
