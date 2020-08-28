//
//  FMLocationView.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMLocationView.h"
#import "UIView+Extend.h"

@interface FMLocationView ()

@property (nonatomic, strong) UIButton           *backBtn;
@property (nonatomic, strong) UILabel            *dateLab;
@property (nonatomic, strong) UIButton           *recordsBtn;
@property (nonatomic, strong) UIView             *lineView1;
@property (nonatomic, strong) UIButton           *locBtn;
@property (nonatomic, strong) UIView             *lineView2;
@property (nonatomic, strong) UIButton           *refreshBtn;

@property (nonatomic,strong) dispatch_source_t   timer;   //计时器

@end

@implementation FMLocationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self drawShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 0) opacity:0.2 radius:5];
        self.layer.cornerRadius = 5;
        
        [self addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(10);
            make.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self addSubview:self.dateLab];
        [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.backBtn.mas_centerY);
            make.left.mas_equalTo(self.backBtn.mas_right).offset(10);
            make.right.mas_equalTo(self.mas_right).offset(-70);
            make.height.mas_equalTo(24);
            
        }];
        
        [self addSubview:self.recordsBtn];
        [self.recordsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.backBtn.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        
        [self addSubview:self.lineView1];
        [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.dateLab.mas_bottom).offset(15);
            make.height.mas_equalTo(1);
        }];
        
        [self addSubview:self.locBtn];
        [self.locBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView1.mas_bottom).offset(5);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-50);
            make.height.mas_equalTo(22);
        }];
        
        [self addSubview:self.lineView2];
        [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.locBtn.mas_right);
            make.top.mas_equalTo(self.lineView1.mas_bottom);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(1);
        }];
        
        [self addSubview:self.refreshBtn];
        [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.lineView2.mas_right).offset(5);
            make.centerY.mas_equalTo(self.locBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
        
        //开始计时
        [self startTimeCount];
    }
    return self;
}

#pragma mark -- Public methods
#pragma mark 计时
- (void)startTimeCount {
    if (_timer == nil) {
        __block NSInteger time = 0; // 倒计时时间
        kSelfWeak;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.dateLab.text = [NSDate getCurrentTimeWeek];
            });
            time++;
        });
        dispatch_resume(_timer);
    }
}

#pragma mark -- Events response
#pragma mark 返回
- (void)backAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(locationViewBackAction:)]) {
        [self.delegate locationViewBackAction:self];
    }
}

#pragma mark 记录
- (void)pushToRecordsAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(locationViewPushToRecords:)]) {
        [self.delegate locationViewPushToRecords:self];
    }
}

#pragma mark 刷新
- (void)refreshAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(locationViewDidRefreshLocation:)]) {
        [self.delegate locationViewDidRefreshLocation:self];
    }
}

#pragma mark -- Setters
- (void)setAddr:(NSString *)addr {
    _addr = addr;
    if (!kIsEmptyString(addr)) {
        [_locBtn setImage:ImageNamed(@"location_icon") forState:UIControlStateNormal];
        [self.locBtn setTitle:addr forState:UIControlStateNormal];
    }
}

#pragma mark -- Getters
#pragma mark 返回
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ImageNamed(@"back_theme") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark 日期
- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] init];
        _dateLab.textColor = [UIColor systemColor];
        _dateLab.font = [UIFont mediumFontWithSize:16];
        _dateLab.textAlignment = NSTextAlignmentCenter;
        _dateLab.text = [NSDate getCurrentTimeWeek];
    }
    return _dateLab;
}

#pragma mark 记录
- (UIButton *)recordsBtn {
    if (!_recordsBtn) {
        _recordsBtn = [[UIButton alloc] init];
        [_recordsBtn setTitle:@"记录" forState:UIControlStateNormal];
        [_recordsBtn setTitleColor:[UIColor systemColor] forState:UIControlStateNormal];
        _recordsBtn.titleLabel.font = [UIFont mediumFontWithSize:13];
        [_recordsBtn addTarget:self action:@selector(pushToRecordsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordsBtn;
}

#pragma mark 横线
- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = [UIColor colorWithHexString:@"#DCDEE5"];
    }
    return _lineView1;
}

#pragma mark 位置
- (UIButton *)locBtn {
    if (!_locBtn) {
        _locBtn = [[UIButton alloc] init];
        [_locBtn setTitleColor:[UIColor systemColor] forState:UIControlStateNormal];
        _locBtn.titleLabel.font = [UIFont regularFontWithSize:14];
        _locBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _locBtn.enabled = NO;
    }
    return _locBtn;
}

#pragma mark 竖线
- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = [UIColor colorWithHexString:@"#DCDEE5"];
    }
    return _lineView2;
}

#pragma mark 刷新
- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [[UIButton alloc] init];
        [_refreshBtn setImage:ImageNamed(@"refresh") forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}

- (void)dealloc {
    if(self.timer){
        dispatch_source_cancel(_timer);
        _timer = nil;
    }}

@end
