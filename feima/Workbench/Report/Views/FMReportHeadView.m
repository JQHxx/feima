//
//  FMReportHeadView.m
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMReportHeadView.h"
#import "FMTimeProgressView.h"
#import "FMSalesProgressView.h"
#import "CustomDatePickerView.h"
#import "XYPieChart.h"

@interface FMReportHeadView ()<XYPieChartDataSource>

@property (nonatomic, strong) UIView     *rootView;
@property (nonatomic, strong) UILabel    *timeTitleLab;
@property (nonatomic, strong) UILabel    *timeLab;
@property (nonatomic, strong) XYPieChart *pieChart;

@property (nonatomic,  copy ) NSArray  <FMGoodsSalesDataModel *> *goodsSalesData;
@property (nonatomic, strong) NSMutableArray *slicesArray;
@property (nonatomic, strong) NSMutableArray *colorsArray;
@property (nonatomic,  copy ) NSString    *defaultMonth;

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
    kSelfWeak;
    [CustomDatePickerView showDatePickerWithTitle:@"选择月份" defauldValue:self.defaultMonth minDateStr:kMinMonth maxDateStr:nil resultBlock:^(NSString *selectValue) {
        weakSelf.defaultMonth = selectValue;
        [weakSelf converteTimeWithSelectDate:selectValue];
    }];
}

#pragma mark 填充数据
#pragma mark 个人销售报表
- (void)displayViewWithTimeData:(FMTimeDataModel *)timeData {
    for (UIView *aView in self.rootView.subviews) {
        if ([aView isKindOfClass:[FMTimeProgressView class]]) {
            [aView removeFromSuperview];
        }
    }
    
    FMTimeProgressView *timeProgressView = [[FMTimeProgressView alloc] initWithFrame:CGRectMake((kScreen_Width-154)/2.0, 45, 154, 160)];
    timeProgressView.progress = timeData.progress;
    timeProgressView.valueStr = [NSString stringWithFormat:@"%ld天",timeData.day];
    [self.rootView addSubview:timeProgressView];
    [timeProgressView startRendering];
}

#pragma mark 部门销售报表
- (void)displayViewWithTimeData:(FMTimeDataModel *)timeData salesData:(FMSalesDataModel *)salesData {
    for (UIView *aView in self.rootView.subviews) {
        if ([aView isKindOfClass:[FMSalesProgressView class]]) {
            [aView removeFromSuperview];
        }
        if ([aView isKindOfClass:[FMTimeProgressView class]]) {
            [aView removeFromSuperview];
        }
    }
    
    FMTimeProgressView *timeProgressView = [[FMTimeProgressView alloc] initWithFrame:CGRectMake(36, 45, 154, 160)];
    timeProgressView.progress = timeData.progress;
    timeProgressView.valueStr = [NSString stringWithFormat:@"%ld天",timeData.day];
    [self.rootView addSubview:timeProgressView];
    [timeProgressView startRendering];
    
    FMSalesProgressView *saleProgressView = [[FMSalesProgressView alloc] initWithFrame:CGRectMake(kScreen_Width/2.0+26, 45, 154, 160)];
    saleProgressView.progress = (double)(salesData.thisSalesSum/(salesData.thisSalesSum+salesData.lastSalesSum));
    saleProgressView.progressStr = [NSString stringWithFormat:@"%.2f%%",salesData.progress];
    saleProgressView.valueStr = [NSString stringWithFormat:@"%.2f万包",salesData.thisSalesSum];
    [self.rootView addSubview:saleProgressView];
    [saleProgressView startRendering];
}

#pragma mark 产品销售报表
- (void)goodsSalesViewFillGoodsSalesData:(NSArray<FMGoodsSalesDataModel *> *)goodsSalesData salesData:(FMSalesDataModel *)salesData {
    for (UIView *aView in self.rootView.subviews) {
        if ([aView isKindOfClass:[FMSalesProgressView class]]) {
            [aView removeFromSuperview];
        }
    }
    self.goodsSalesData = goodsSalesData;
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<goodsSalesData.count; i++) {
        FMGoodsSalesDataModel *model = [goodsSalesData safe_objectAtIndex:i];
        NSNumber *num = [NSNumber numberWithDouble:model.progress];
        [datas addObject:num];
        
        UIColor *getColor = [[FeimaManager sharedFeimaManager].myColors safe_objectAtIndex:i];
        [colors addObject:getColor];
    }
    self.slicesArray = datas;
    self.colorsArray = colors;
    [self.pieChart reloadData];
    
    
    FMSalesProgressView *saleProgressView = [[FMSalesProgressView alloc] initWithFrame:CGRectMake(kScreen_Width/2.0+26, 45, 154, 160)];
    saleProgressView.progress = (double)(salesData.thisSalesSum/(salesData.thisSalesSum+salesData.lastSalesSum));
    saleProgressView.progressStr = [NSString stringWithFormat:@"%.2f%%",salesData.progress];
    saleProgressView.valueStr = [NSString stringWithFormat:@"%.2f万包",salesData.thisSalesSum];
    [self.rootView addSubview:saleProgressView];
    [saleProgressView startRendering];
}

#pragma mark -- XYPieChartDataSource
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return self.slicesArray.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    return [[self.slicesArray safe_objectAtIndex:index] doubleValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    return [self.colorsArray safe_objectAtIndex:index];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
    FMGoodsSalesDataModel *model = [self.goodsSalesData safe_objectAtIndex:index];
    NSString *text = [NSString stringWithFormat:@"%@\n%.1f%%",model.goodsName,[[self.slicesArray safe_objectAtIndex:index] doubleValue]];
    return text;
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
        maxDay = [NSDate currentDateTimeWithFormat:@"yyyy.MM.dd"];
    } else {
        maxDay = [days lastObject];
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
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-16, 192));
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
    
    [self.rootView addSubview:self.pieChart];
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

#pragma mark 饼图
- (XYPieChart *)pieChart {
    if (!_pieChart) {
        _pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(20, 45, 140, 140) Center:CGPointMake(70, 60) Radius:45];
        _pieChart.dataSource = self;
        _pieChart.startPieAngle = -M_PI_2;
        _pieChart.labelRadius = 65;
        _pieChart.showPercentage = NO;
        _pieChart.labelColor = [UIColor colorWithHexString:@"#666666"];
        _pieChart.labelFont = [UIFont regularFontWithSize:10];
    }
    return _pieChart;
}

@end
