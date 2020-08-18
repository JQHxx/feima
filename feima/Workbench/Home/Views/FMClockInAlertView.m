//
//  FMClockInAlertView.m
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMClockInAlertView.h"
#import "FMPhotoCollectionView.h"
#import "FMClockInViewModel.h"
#import "NSDate+Extend.h"
#import "QWAlertView.h"

@interface FMClockInAlertView ()

@property (nonatomic, strong ) UILabel  *titleLab;
@property (nonatomic, strong ) UIButton *closeBtn;
@property (nonatomic, strong ) UILabel  *descLab;
@property (nonatomic, strong ) UILabel  *stateLab;
@property (nonatomic, strong ) UILabel  *timeTitleLab;
@property (nonatomic, strong ) UILabel  *timeLab;
@property (nonatomic, strong ) UILabel  *addressTitleLab;
@property (nonatomic, strong ) UILabel  *addressLab;
@property (nonatomic, strong ) UILabel  *photoTitleLab;
@property (nonatomic, strong ) FMPhotoCollectionView  *photoView;
@property (nonatomic, strong ) UIButton *confirmBtn;

@property (nonatomic, copy ) ConfirmBlock confirmBlock;

@property (nonatomic, strong) FMClockInViewModel *adapter;

@end

@implementation FMClockInAlertView

- (instancetype)initWithFrame:(CGRect)frame type:(FMClockInType)type startTime:(NSString *)startTime endTime:(NSString *)endTime address:(NSString *)address confirmAction:(ConfirmBlock)confrim{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        
        self.confirmBlock = confrim;
        
        [self setupUI];
        //显示打开正常异常
        [self showDescWithType:type startTime:startTime endTime:endTime];
        //验证打卡
        [self verifyRepeatedPunchWithType:type];
        self.addressLab.text = address;
    }
    return self;
}

#pragma mark 显示弹出框
+ (void)showClockInAlertWithFrame:(CGRect)frame
                             type:(FMClockInType)type
                          address:(NSString *)addr
                        startTime:(NSString *)startTime
                          endTime:(NSString *)endTime
                    confirmAction:(ConfirmBlock)confrim {
    FMClockInAlertView *view = [[FMClockInAlertView alloc] initWithFrame:frame type:type startTime:startTime endTime:endTime address:addr confirmAction:confrim];
    [view show];
}

#pragma mark -- Events
#pragma mark 关闭
- (void)closeCurrentViewAction:(UIButton *)sender {
    [[QWAlertView sharedMask] dismiss];
}

#pragma mark  确认
- (void)confirmClockInAction:(UIButton *)sender {
    NSArray *images = [self.photoView getAllImages];
    if (images.count > 0) {
        [[QWAlertView sharedMask] dismiss];
        self.confirmBlock(images);
    } else {
        [self makeToast:@"照片不能为空" duration:1.5 position:CSToastPositionCenter];
    }
}

#pragma mark -- Private methods
#pragma mark 打卡验证
- (void)verifyRepeatedPunchWithType:(FMClockInType)type {
    [self.adapter verifyRepeatedPunchWithType:type complete:^(BOOL isSuccess) {
        if (!isSuccess) {
            self.stateLab.text = self.adapter.errorString;
            [self.stateLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
            }];
        }
    }];
}

#pragma mark 解析时间
- (void)showDescWithType:(FMClockInType)type startTime:(NSString *)startTime endTime:(NSString *)endTime {
    if (!kIsEmptyString(startTime)&&!kIsEmptyString(endTime)) {
        NSString *currentDay = [NSDate todayDateWithFormat:@"yyyy-MM-dd"];
        NSString *timeStr = [NSDate currentDateTimeWithFormat:@"yyyy-MM-dd HH:mm"];
        NSInteger currentTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:timeStr format:@"yyyy-MM-dd HH:mm"];
        
        NSString *startTimeStr = [startTime substringToIndex:startTime.length-3];
        NSInteger sTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:[NSString stringWithFormat:@"%@ %@",currentDay,startTimeStr] format:@"yyyy-MM-dd HH:mm"];
        
        NSString *endTimeStr = [endTime substringToIndex:endTime.length-3];
        NSInteger eTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:[NSString stringWithFormat:@"%@ %@",currentDay,endTimeStr] format:@"yyyy-MM-dd HH:mm"];
        if (sTime < currentTime && eTime > currentTime) {
            self.titleLab.text = @"打卡状态正常";
            self.descLab.text = @"";
        } else {
            self.titleLab.text = @"打卡状态异常";
            self.descLab.text = [NSString stringWithFormat:@"当前不在打卡时间(%@-%@)",startTimeStr,endTimeStr];
        }
        if (kIsEmptyString(self.descLab.text)) {
            [self.descLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        } else {
            [self.descLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
            }];
        }
        self.timeLab.text = timeStr;
    } else {
        self.titleLab.text = @"打卡状态正常";
        self.descLab.text = @"";
        [self.descLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}

#pragma mark show
- (void)show {
    [[QWAlertView sharedMask] show:self withType:QWAlertViewStyleAlert];
}

#pragma mark UI
- (void)setupUI {
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.stateLab];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(0);
    }];
    
    [self addSubview:self.descLab];
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stateLab.mas_bottom);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(0);
    }];
    
    [self addSubview:self.timeTitleLab];
    [self.timeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.descLab.mas_left);
        make.size.mas_equalTo(CGSizeMake(54, 18));
    }];
    
    [self addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeTitleLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.descLab.mas_left);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(17);
    }];
    
    [self addSubview:self.addressTitleLab];
    [self.addressTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.descLab.mas_left);
        make.size.mas_equalTo(CGSizeMake(54, 18));
    }];
    
    [self addSubview:self.addressLab];
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressTitleLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.descLab.mas_left);
        make.right.mas_equalTo(-25);
        make.height.mas_greaterThanOrEqualTo(17);
    }];
    
    [self addSubview:self.photoTitleLab];
    [self.photoTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.descLab.mas_left);
        make.size.mas_equalTo(CGSizeMake(54, 18));
    }];
    
    [self addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.photoTitleLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.descLab.mas_left);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(70);
    }];
    
    [self addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 36));
    }];
}

#pragma mark -- Getters
#pragma mark 关闭
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:ImageNamed(@"close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeCurrentViewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

#pragma mark 标题
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor textBlackColor];
        _titleLab.font = [UIFont mediumFontWithSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

#pragma mark 错误描述
- (UILabel *)stateLab {
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] init];
        _stateLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _stateLab.font = [UIFont regularFontWithSize:14];
    }
    return _stateLab;
}

#pragma mark 错误描述
- (UILabel *)descLab {
    if (!_descLab) {
        _descLab = [[UILabel alloc] init];
        _descLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _descLab.font = [UIFont regularFontWithSize:14];
    }
    return _descLab;
}

#pragma mark 时间标题
- (UILabel *)timeTitleLab {
    if (!_timeTitleLab) {
        _timeTitleLab = [[UILabel alloc] init];
        _timeTitleLab.textColor = [UIColor colorWithHexString:@"#F34F1F"];
        _timeTitleLab.font = [UIFont regularFontWithSize:10];
        _timeTitleLab.layer.cornerRadius = 9;
        _timeTitleLab.layer.borderColor = [UIColor colorWithHexString:@"#F34F1F"].CGColor;
        _timeTitleLab.layer.borderWidth = 1.0;
        _timeTitleLab.textAlignment = NSTextAlignmentCenter;
        _timeTitleLab.text = @"日期时间";
    }
    return _timeTitleLab;
}

#pragma mark 时间
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeLab.font = [UIFont regularFontWithSize:14];
    }
    return _timeLab;
}

#pragma mark 地点标题
- (UILabel *)addressTitleLab {
    if (!_addressTitleLab) {
        _addressTitleLab = [[UILabel alloc] init];
        _addressTitleLab.textColor = [UIColor colorWithHexString:@"#F34F1F"];
        _addressTitleLab.font = [UIFont regularFontWithSize:10];
        _addressTitleLab.layer.cornerRadius = 9;
        _addressTitleLab.layer.borderColor = [UIColor colorWithHexString:@"#F34F1F"].CGColor;
        _addressTitleLab.layer.borderWidth = 1.0;
        _addressTitleLab.textAlignment = NSTextAlignmentCenter;
        _addressTitleLab.text = @"打卡地点";
    }
    return _addressTitleLab;
}

#pragma mark 地点
- (UILabel *)addressLab {
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] init];
        _addressLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _addressLab.font = [UIFont regularFontWithSize:14];
        _addressLab.numberOfLines = 0;
    }
    return _addressLab;
}

#pragma mark 上传图片标题
- (UILabel *)photoTitleLab {
    if (!_photoTitleLab) {
        _photoTitleLab = [[UILabel alloc] init];
        _photoTitleLab.textColor = [UIColor colorWithHexString:@"#F34F1F"];
        _photoTitleLab.font = [UIFont regularFontWithSize:10];
        _photoTitleLab.layer.cornerRadius = 9;
        _photoTitleLab.layer.borderColor = [UIColor colorWithHexString:@"#F34F1F"].CGColor;
        _photoTitleLab.layer.borderWidth = 1.0;
        _photoTitleLab.textAlignment = NSTextAlignmentCenter;
        _photoTitleLab.text = @"上传照片";
    }
    return _photoTitleLab;
}

#pragma mark 上传照片
- (FMPhotoCollectionView *)photoView {
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _photoView = [[FMPhotoCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _photoView.maxImagesCount = 4;
    }
    return _photoView;
}

#pragma mark 确认
- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton submitButtonWithFrame:CGRectZero title:@"确认打卡" target:self selector:@selector(confirmClockInAction:)];
    }
    return _confirmBtn;
}

- (FMClockInViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMClockInViewModel alloc] init];
    }
    return _adapter;
}

@end
