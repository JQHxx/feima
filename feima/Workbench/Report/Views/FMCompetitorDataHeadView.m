//
//  FMCompetitorDataHeadView.m
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCompetitorDataHeadView.h"
#import "FMDateToolView.h"
#import "XYPieChart.h"


@interface FMCompetitorDataHeadView ()<FMDateToolViewDelegate,XYPieChartDataSource>

@property (nonatomic, strong) UIView         *rootView;
@property (nonatomic, strong) FMDateToolView *dateView;
@property (nonatomic, strong) XYPieChart     *pieChart;
@property (nonatomic, strong) UIScrollView   *rootScrollView;
@property (nonatomic, strong) NSMutableArray *slicesArray;
@property (nonatomic, strong) NSMutableArray *colorsArray;

@end

@implementation FMCompetitorDataHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
        [self setupUI];
    }
    return self;
}

#pragma mark -- XYPieChartDataSource
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return self.slicesArray.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    return [[self.slicesArray safe_objectAtIndex:index] integerValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    return [self.colorsArray safe_objectAtIndex:index];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
    NSString *text = [NSString stringWithFormat:@"%ld%%",[[self.slicesArray safe_objectAtIndex:index] integerValue]];
    return text;
}


#pragma mark -- Public methods
#pragma mark 填充数据
- (void)displayViewWithData:(NSArray<FMCompetitorAnalysisModel *> *)data {
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<data.count; i++) {
        FMCompetitorAnalysisModel *model = [data safe_objectAtIndex:i];
        NSNumber *num = [NSNumber numberWithInteger:model.marketShare];
        [datas addObject:num];
        
        UIColor *getColor = [[FeimaManager sharedFeimaManager].myColors safe_objectAtIndex:i];
        [colors addObject:getColor];
    }
    self.slicesArray = datas;
    self.colorsArray = colors;
    [self.pieChart reloadData];
    
    for (UIView *aView in self.rootScrollView.subviews) {
        [aView removeFromSuperview];
    }
    
    for (NSInteger i=0; i<data.count; i++) {
        FMCompetitorAnalysisModel *model = [data safe_objectAtIndex:i];
        
        UIView *blockView = [[UIView alloc] initWithFrame:CGRectMake(0,20*i, 14, 14)];
        blockView.backgroundColor = [[FeimaManager sharedFeimaManager].myColors safe_objectAtIndex:i];
        [self.rootScrollView addSubview:blockView];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(blockView.right+10, blockView.top, 130, 14)];
        lab.text = model.competeGoodsName;
        lab.textColor = [UIColor colorWithHexString:@"#666666"];
        lab.font = [UIFont regularFontWithSize:12];
        [self.rootScrollView addSubview:lab];
    }
    self.rootScrollView.contentSize = CGSizeMake(160, data.count*20);
}

#pragma mark -- FMDateToolViewDelegate
#pragma mark 设置时间
- (void)dateToolViewDidSelectedDate:(NSString *)date {
    NSInteger time = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:date format:@"yyyy.MM"];
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

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.top.mas_equalTo(7);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-16, 202));
    }];
    
    [self.rootView addSubview:self.dateView];
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(40);
    }];
    
    [self.rootView addSubview:self.pieChart];
    
    [self.rootView addSubview:self.rootScrollView];
    [self.rootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rootView.mas_right).offset(-15);
        make.top.mas_equalTo(self.dateView.mas_bottom).offset(10);
        make.width.mas_equalTo(160);
        make.bottom.mas_equalTo(self.rootView.mas_bottom).offset(-10);
    }];
}

#pragma mark -- Getters
#pragma mark root
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
        _dateView.delegate = self;
    }
    return _dateView;
}

#pragma mark 饼图
- (XYPieChart *)pieChart {
    if (!_pieChart) {
        _pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(20, 55, 134, 134) Center:CGPointMake(67, 67) Radius:50];
        _pieChart.dataSource = self;
        _pieChart.startPieAngle = -M_PI_2;
        _pieChart.labelRadius = 65;
        _pieChart.labelColor = [UIColor colorWithHexString:@"#666666"];
        _pieChart.labelFont = [UIFont regularFontWithSize:12];
    }
    return _pieChart;
}

- (UIScrollView *)rootScrollView {
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] init];
        _rootScrollView.showsVerticalScrollIndicator = NO;
    }
    return _rootScrollView;
}

@end
