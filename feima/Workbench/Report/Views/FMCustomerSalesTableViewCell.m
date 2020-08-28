//
//  FMCustomerSalesTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerSalesTableViewCell.h"
#import "FMCustomerSalesModel.h"

@interface FMCustomerSalesTableViewCell ()

@property (nonatomic,strong) UILabel *cutomerNameLabel;
@property (nonatomic,strong) UILabel *followLabel;
@property (nonatomic,strong) UILabel *lastMonthLabel;
@property (nonatomic,strong) UILabel *monthLabel;
@property (nonatomic,strong) UILabel *percentageLabel;


@end

@implementation FMCustomerSalesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cutomerNameLabel];
        [self.contentView addSubview:self.followLabel];
        [self.contentView addSubview:self.lastMonthLabel];
        [self.contentView addSubview:self.monthLabel];
        [self.contentView addSubview:self.percentageLabel];
    }
    return self;
}

#pragma mark -- Public methods
#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMCustomerSalesModel *salesModel = (FMCustomerSalesModel *)obj;
    self.cutomerNameLabel.text = salesModel.customerName;
    self.followLabel.text = salesModel.followUpPeopleName;
    self.lastMonthLabel.text = [NSString stringWithFormat:@"%.3f",salesModel.lastSales];
    self.monthLabel.text = [NSString stringWithFormat:@"%.3f",salesModel.thisSales];
    self.percentageLabel.text = [NSString stringWithFormat:@"%.2f%%",salesModel.progress];
}

#pragma mark -- Private methods
#pragma mark setup label
- (UILabel *)setupLabelWithOriginX:(CGFloat)originX {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, kCustomerSalesWidth, 24)];
    lab.font = [UIFont mediumFontWithSize:14];
    lab.textColor = [UIColor colorWithHexString:@"#666666"];
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

#pragma mark -- Getters
#pragma mark 姓名
- (UILabel *)cutomerNameLabel {
    if (!_cutomerNameLabel) {
        _cutomerNameLabel = [self setupLabelWithOriginX:0];
    }
    return _cutomerNameLabel;
}

#pragma mark 跟进人
- (UILabel *)followLabel {
    if (!_followLabel) {
        _followLabel = [self setupLabelWithOriginX:kCustomerSalesWidth];
    }
    return _followLabel;
}

#pragma mark 上月销量
- (UILabel *)lastMonthLabel {
    if (!_lastMonthLabel) {
        _lastMonthLabel = [self setupLabelWithOriginX:kCustomerSalesWidth*2];
    }
    return _lastMonthLabel;
}

#pragma mark 本月销量
- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [self setupLabelWithOriginX:kCustomerSalesWidth*3];
    }
    return _monthLabel;
}

#pragma mark 完成进度
- (UILabel *)percentageLabel {
    if (!_percentageLabel) {
        _percentageLabel = [self setupLabelWithOriginX:kCustomerSalesWidth*4];
    }
    return _percentageLabel;
}

@end
