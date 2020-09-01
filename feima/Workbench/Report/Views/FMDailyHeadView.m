//
//  FMDailyHeadView.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDailyHeadView.h"
#import "FMDateToolView.h"
#import "FMStatisticsView.h"

@interface FMDailyHeadView ()<FMDateToolViewDelegate>

@property (nonatomic, strong) UIView            *rootView;
@property (nonatomic, strong) FMDateToolView    *dateView;
@property (nonatomic, strong) FMStatisticsView  *statisticsView;
@property (nonatomic, strong) UILabel           *notClockedInLabel; //未打卡
@property (nonatomic, strong) UILabel           *clockedInLabel; //已打卡
@property (nonatomic, strong) UILabel           *abnormalLabel; //异常

@end

@implementation FMDailyHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
        [self setupUI];
    }
    return self;
}

#pragma mark  FMDateToolViewDelegate
#pragma mark 设置时间
- (void)dateToolViewDidSelectedDate:(NSString *)date {
    NSInteger time = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:date format:@"yyyy.MM.dd"];
    if (self.selDateBlock) {
        self.selDateBlock(time);
    }
}

#pragma mark 选择部门
- (void)dateToolViewDidSelectedOrganizationWithOriganizationId:(NSInteger)organizationId {
    if (self.selOrganiztionBlock) {
        self.selOrganiztionBlock(organizationId);
    }
}

#pragma mark 填充数据
- (void)fillDataWithFigure:(FMDailyFigureModel *)figureModel statusModel:(FMDailyStatusModel *)statusModel {
    self.statisticsView.valueStr = [NSString stringWithFormat:@"%ld/%ld",figureModel.punchNumber,figureModel.shouldBeToNumber];
    
    self.notClockedInLabel.text = [NSString stringWithFormat:@"%ld",statusModel.notPunchNumber];
    self.clockedInLabel.text = [NSString stringWithFormat:@"%ld",statusModel.punchNumber];
    self.abnormalLabel.text = [NSString stringWithFormat:@"%ld",statusModel.abnormalNumber];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-16, 280));
    }];
    
    [self.rootView addSubview:self.dateView];
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(40);
    }];
    
    [self.rootView addSubview:self.statisticsView];
    [self.statisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.dateView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    NSArray *arr = @[@"未打卡",@"已打卡",@"异常"];
    for (NSInteger i=0; i<arr.count; i++) {
        UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(i*(kScreen_Width-16)/3.0, 220, (kScreen_Width-16)/3.0, 30)];
        valueLab.textAlignment = NSTextAlignmentCenter;
        valueLab.textColor = [UIColor systemColor];
        valueLab.font = [UIFont mediumFontWithSize:20];
        [self.rootView addSubview:valueLab];
        
        if (i==0) {
            self.notClockedInLabel = valueLab;
        } else if (i==1) {
            self.clockedInLabel = valueLab;
        } else {
            self.abnormalLabel = valueLab;
        }
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(valueLab.left, valueLab.bottom, valueLab.width, 20)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor colorWithHexString:@"#333333"];
        lab.font = [UIFont regularFontWithSize:14];
        lab.text = arr[i];
        [self.rootView addSubview:lab];
    }
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
        _dateView = [[FMDateToolView alloc] initWithFrame:CGRectZero type:FMDateToolViewTypeDay];
        _dateView.delegate = self;
    }
    return _dateView;
}

#pragma mark 统计
- (FMStatisticsView *)statisticsView {
    if (!_statisticsView) {
        _statisticsView = [[FMStatisticsView alloc] initWithFrame:CGRectZero type:FMStatisticsViewTypeDaily];
    }
    return _statisticsView;
}


@end
