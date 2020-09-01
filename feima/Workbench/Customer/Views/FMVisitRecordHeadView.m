//
//  FMVisitRecordHeadView.m
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMVisitRecordHeadView.h"
#import "FMCustomerHeadView.h"
#import "XYPieChart.h"

@interface FMVisitRecordHeadView ()<XYPieChartDataSource>

@property (nonatomic, strong) FMCustomerHeadView *customerHeadView;
@property (nonatomic, strong) XYPieChart          *salesChart;
@property (nonatomic, strong) UILabel             *salesLabel;
@property (nonatomic, strong) UIScrollView        *rootScrollView;
@property (nonatomic, strong) XYPieChart          *visitChart;
@property (nonatomic, strong) UILabel             *visitLabel;

@property (nonatomic, strong) FMCustomerModel    *customer;
@property (nonatomic, strong) FMVisitRateModel   *visitRate;

@property (nonatomic, strong) NSMutableArray     *slicesArray;
@property (nonatomic, strong) NSMutableArray     *colorsArray;

@end

@implementation FMVisitRecordHeadView

- (instancetype)initWithFrame:(CGRect)frame customer:(FMCustomerModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        self.customer = model;
        [self addSubview:self.customerHeadView];
        [self addSubview:self.salesChart];
        [self addSubview:self.salesLabel];
        [self addSubview:self.rootScrollView];
        [self addSubview:self.visitChart];
        [self addSubview:self.visitLabel];
    }
    return self;
}

#pragma mark -- XYPieChartDataSource
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    if (pieChart == self.salesChart) {
        return self.slicesArray.count;
    } else {
        return 1;
    }
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    if (pieChart == self.salesChart) {
        return [[self.slicesArray safe_objectAtIndex:index] integerValue];
    } else {
        return self.visitRate.visitRates.count/self.visitRate.day;
    }
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    if (pieChart == self.salesChart) {
        return [self.colorsArray safe_objectAtIndex:index];
    } else {
        return [UIColor colorWithHexString:@"#F7C95E"];
    }
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
    if (pieChart == self.salesChart) {
        return [NSString stringWithFormat:@"%.1f%%",[[self.slicesArray safe_objectAtIndex:index] doubleValue]];
    } else {
        NSString *text = [NSString stringWithFormat:@"%.1f%%",(double)self.visitRate.visitRates.count/(double)self.visitRate.day];
        return text;
    }
    
}

#pragma mark -- Public methods
#pragma mark 填充数据
- (void)fillContentDataWithOrderSellInfo:(NSArray<FMOrderSellModel *> *)sellInfo rate:(FMVisitRateModel *)rateModel {
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    NSInteger totalCount = 0;
    for (NSInteger i=0; i<sellInfo.count; i++) {
        FMOrderSellModel *model = [sellInfo safe_objectAtIndex:i];
        NSNumber *num = [NSNumber numberWithInteger:model.orderSellDetail.num];
        [datas addObject:num];
        
        totalCount += model.orderSellDetail.num;
        
        UIColor *getColor = [[FeimaManager sharedFeimaManager].myColors safe_objectAtIndex:i];
        [colors addObject:getColor];
    }
    self.slicesArray = datas;
    self.colorsArray = colors;
    [self.salesChart reloadData];
    self.salesLabel.text = [NSString stringWithFormat:@"本月销量(总销量:%ld包)",totalCount];
    
    for (UIView *aView in self.rootScrollView.subviews) {
        [aView removeFromSuperview];
    }
    
    for (NSInteger i=0; i<sellInfo.count; i++) {
        FMOrderSellModel *model = [sellInfo safe_objectAtIndex:i];
        
        UIView *blockView = [[UIView alloc] initWithFrame:CGRectMake(0,20*i, 14, 14)];
        blockView.backgroundColor = [[FeimaManager sharedFeimaManager].myColors safe_objectAtIndex:i];
        [self.rootScrollView addSubview:blockView];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(blockView.right+10, blockView.top, 130, 14)];
        lab.text = [NSString stringWithFormat:@"%@ %ld包",model.goods.name,model.orderSellDetail.num];
        lab.textColor = [UIColor colorWithHexString:@"#666666"];
        lab.font = [UIFont regularFontWithSize:12];
        [self.rootScrollView addSubview:lab];
    }
    self.rootScrollView.contentSize = CGSizeMake(160, sellInfo.count*20);
    
    self.visitRate = rateModel;
    [self.visitChart reloadData];
    self.visitLabel.text = [NSString stringWithFormat:@"本月拜访率(总次数:%ld次)",rateModel.totalNumber];
}

#pragma mark -- Getters
#pragma mark 客户信息
- (FMCustomerHeadView *)customerHeadView {
    if (!_customerHeadView) {
        _customerHeadView = [[FMCustomerHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 140)];
        [_customerHeadView displayViewWithData:self.customer];
    }
    return _customerHeadView;
}

#pragma mark 销售
- (XYPieChart *)salesChart {
    if (!_salesChart) {
        _salesChart = [[XYPieChart alloc] initWithFrame:CGRectMake(20,self.customerHeadView.bottom+10, 120, 120) Center:CGPointMake(60, 60) Radius:60];
        _salesChart.dataSource = self;
        _salesChart.startPieAngle = -M_PI_2;
        _salesChart.showPercentage = YES;
        _salesChart.labelRadius = 40;
        _salesChart.labelColor = [UIColor whiteColor];
        _salesChart.labelFont = [UIFont regularFontWithSize:10];
    }
    return _salesChart;
}

- (UIScrollView *)rootScrollView {
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.salesChart.right+10, self.salesChart.top, 160, 40)];
        _rootScrollView.showsVerticalScrollIndicator = NO;
    }
    return _rootScrollView;
}

#pragma mark 销量标题
- (UILabel *)salesLabel {
    if (!_salesLabel) {
        _salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.salesChart.bottom+10, 180, 20)];
        _salesLabel.font = [UIFont mediumFontWithSize:14];
        _salesLabel.textColor = [UIColor textBlackColor];
    }
    return _salesLabel;
}

#pragma mark 拜访率
- (XYPieChart *)visitChart {
    if (!_visitChart) {
        _visitChart = [[XYPieChart alloc] initWithFrame:CGRectMake(kScreen_Width-150,self.customerHeadView.bottom+10, 120, 120) Center:CGPointMake(60, 60) Radius:60];
        _visitChart.dataSource = self;
        _visitChart.startPieAngle = -M_PI_2;
        _visitChart.showPercentage = YES;
        _visitChart.labelRadius = 40;
        _visitChart.labelColor = [UIColor whiteColor];
        _visitChart.labelFont = [UIFont regularFontWithSize:10];
    }
    return _visitChart;
}

#pragma mark 销量标题
- (UILabel *)visitLabel {
    if (!_visitLabel) {
        _visitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.visitChart.left-40, self.visitChart.bottom+10, 180, 20)];
        _visitLabel.font = [UIFont mediumFontWithSize:14];
        _visitLabel.textColor = [UIColor textBlackColor];
        _visitLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _visitLabel;
}

@end
