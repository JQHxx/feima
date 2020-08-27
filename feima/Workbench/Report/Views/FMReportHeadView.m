//
//  FMReportHeadView.m
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMReportHeadView.h"
#import "FMProgressView.h"
#import "FMStatisticsView.h"
#import "FMCompetitorDataView.h"
#import "CustomDatePickerView.h"
#import "NSDate+Extend.h"

@interface FMReportHeadView ()

@property (nonatomic, strong) UIView     *rootView;
@property (nonatomic, strong) UILabel    *timeTitleLab;
@property (nonatomic, strong) UILabel    *timeLab;

@property (nonatomic, copy ) NSString    *defaultMonth;

@end

@implementation FMReportHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
        
        self.defaultMonth = [NSDate currentYearMonthWithFormat:@"yyyy-MM"];
        
        [self setupUI];
    }
    return self;
}

#pragma mark -- Event response
#pragma mark 选择时间
- (void)chooseTimeAction {
    [CustomDatePickerView showDatePickerWithTitle:@"选择月份" defauldValue:self.defaultMonth minDateStr:kMinMonth maxDateStr:nil resultBlock:^(NSString *selectValue) {
        MyLog(@"selectValue:%@",selectValue);
        [self converteTimeWithSelectDate:selectValue];
    }];
}

#pragma mark 填充数据
#pragma mark 个人销售报表
- (void)displayViewWithTimeData:(FMTimeDataModel *)timeData {
    FMProgressView *timeProgressView = [[FMProgressView alloc] initWithFrame:CGRectMake((kScreen_Width-16-134)/2.0, 45, 134, 140) type:FMProgressTypeTime];
    timeProgressView.progress = timeData.progress;
    timeProgressView.valueStr = [NSString stringWithFormat:@"%ld天",timeData.day];
    timeProgressView.titleStr = @"时间进度";
    [self.rootView addSubview:timeProgressView];
    [timeProgressView startRendering];
}

#pragma mark 个人或部门销售报表
- (void)displayViewWithTimeData:(FMTimeDataModel *)timeData salesData:(FMSalesDataModel *)salesData {
    FMProgressView *timeProgressView = [[FMProgressView alloc] initWithFrame:CGRectMake(36, 45, 134, 140) type:FMProgressTypeTime];
    timeProgressView.progress = timeData.progress;
    timeProgressView.valueStr = [NSString stringWithFormat:@"%ld天",timeData.day];
    timeProgressView.titleStr = @"时间进度";
    [self.rootView addSubview:timeProgressView];
    [timeProgressView startRendering];
    
    FMProgressView *saleProgressView = [[FMProgressView alloc] initWithFrame:CGRectMake(kScreen_Width/2.0+36, 45, 134, 140) type:FMProgressTypeSale];
    saleProgressView.progress = salesData.progress;
    saleProgressView.valueStr = @"20万包";
    saleProgressView.titleStr = @"销售环比进度";
    [self.rootView addSubview:saleProgressView];
    [saleProgressView startRendering];
}

#pragma mark 个人或部门产品销售报表
- (void)displayViewWithGoodsData:(NSArray *)goodsData salesData:(FMSalesDataModel *)salesData {
    
    
    FMProgressView *saleProgressView = [[FMProgressView alloc] initWithFrame:CGRectMake(kScreen_Width/2.0+36, 45, 134, 140) type:FMProgressTypeSale];
    saleProgressView.progress = salesData.progress;
    saleProgressView.valueStr = @"20万包";
    saleProgressView.titleStr = @"上月总销量";
    [self.rootView addSubview:saleProgressView];
    [saleProgressView startRendering];
}

#pragma mark 客户销售报表
- (void)displayViewWithCustomerData:(FMCustomerDataModel *)customerData {
    FMStatisticsView *view = [[FMStatisticsView alloc] initWithFrame:CGRectMake((kScreen_Width-165)/2.0, 35, 140, 140) type:FMStatisticsViewTypeCustomer];
    view.valueStr = [NSString stringWithFormat:@"%ld/%ld",customerData.addCustomer,customerData.customerSum];
    [self.rootView addSubview:view];
}

#pragma mark 竞品销售报表
- (void)displayViewWithCompetitorData {
    FMCompetitorDataView *dataView = [[FMCompetitorDataView alloc] initWithFrame:CGRectMake(30, 40, kScreen_Width-150, 140)];
    [self.rootView addSubview:dataView];
    
    [dataView setDatas:@[@(75),@(15),@(10)] colors:@[[UIColor colorWithHexString:@"#3AA1FF"],[UIColor colorWithHexString:@"#FE304B"],[UIColor colorWithHexString:@"#FFCF4E"]]];
    [dataView stroke];
}

#pragma mark -- Private methods
#pragma mark 时间转换
- (void)converteTimeWithSelectDate:(NSString *)selectValue {
    //任意选取月中某一天
    NSString *dayStr = [NSString stringWithFormat:@"%@-03",selectValue];
    //yyyy-MM-dd 转换成 yyyy.MM.dd
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *currentDate = [formatter dateFromString:dayStr];
    NSString *selDate = [formatter stringFromDate:currentDate];
    
    //获取月份第一个和最后一天
    NSArray *days = [[FeimaManager sharedFeimaManager] getMonthFirstAndLastDayWithDate:selDate format:@"yyyy.MM.dd"];
    NSString *minDay = [days firstObject];
    
    NSString *currentMonth = [NSDate currentYearMonthWithFormat:@"yyyy-MM"];
    NSString *maxDay = nil;
    if ([currentMonth isEqualToString:selectValue]) {
        maxDay = [days lastObject];
    } else {
        maxDay = [NSDate currentDateTimeWithFormat:@"yyyy.MM.dd"];
    }
    _timeLab.text = [NSString stringWithFormat:@"%@至%@",minDay,maxDay];
    
    NSInteger sTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:minDay format:@"yyyy.MM.dd"];
    NSInteger eTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:maxDay format:@"yyyy.MM.dd"];
    if ([self.delegate respondsToSelector:@selector(reportHeadViewDidSelectedMonthWithStartTime:endTime:)]) {
        [self.delegate reportHeadViewDidSelectedMonthWithStartTime:sTime endTime:eTime];
    }
}

#pragma mark UI
- (void)setupUI {
    [self addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.top.mas_equalTo(7);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-16, 182));
    }];
    
    [self.rootView addSubview:self.timeTitleLab];
    [self.timeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(14);
        make.size.mas_equalTo(CGSizeMake(60, 16));
    }];
    
    [self.rootView addSubview:self.timeLab];
    CGFloat labW = [self.timeLab.text boundingRectWithSize:CGSizeMake(240, 22) withTextFont:self.timeLab.font].width;
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeTitleLab.mas_right);
        make.top.mas_equalTo(11);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(labW+20);
    }];
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

#pragma mark 时间标题
-(UILabel *)timeTitleLab{
    if (!_timeTitleLab) {
        _timeTitleLab = [[UILabel alloc] init];
        _timeTitleLab.font = [UIFont regularFontWithSize:12];
        _timeTitleLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeTitleLab.text = @"统计时间：";
    }
    return _timeTitleLab;
}

#pragma mark 时间
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.backgroundColor = [UIColor colorWithHexString:@"#F1F4F8"];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = [UIFont regularFontWithSize:12];
        _timeLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeLab.layer.cornerRadius = 11;
        _timeLab.clipsToBounds = YES;
        NSString *currentDate = [NSDate currentDateTimeWithFormat:@"yyyy.MM.dd"];
        NSArray *days = [[FeimaManager sharedFeimaManager] getMonthFirstAndLastDayWithDate:currentDate format:@"yyyy.MM.dd"];
        _timeLab.text = [NSString stringWithFormat:@"%@至%@",[days firstObject],currentDate];
        [_timeLab addTapPressed:@selector(chooseTimeAction) target:self];
    }
    return _timeLab;
}

@end
