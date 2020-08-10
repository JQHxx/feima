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

@interface FMReportHeadView ()

@property (nonatomic, strong) UIView     *rootView;
@property (nonatomic, strong) UILabel    *timeTitleLab;
@property (nonatomic, strong) UILabel    *timeLab;

@end

@implementation FMReportHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
        [self setupUI];
    }
    return self;
}

#pragma mark 填充数据
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

- (void)displayViewWithCustomerData {
    FMStatisticsView *view = [[FMStatisticsView alloc] initWithFrame:CGRectMake(0, 0, 140, 140) type:FMStatisticsViewTypeCustomer];
    view.center = self.center;
    [self.rootView addSubview:view];
}

#pragma mark -- Private methods
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
        _timeLab.text = @"2020.07.01 至 2020.07.31";
        _timeLab.layer.cornerRadius = 11;
        _timeLab.clipsToBounds = YES;
    }
    return _timeLab;
}

@end
