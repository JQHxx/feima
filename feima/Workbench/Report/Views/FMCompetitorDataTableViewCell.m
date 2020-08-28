//
//  FMCompetitorDataTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCompetitorDataTableViewCell.h"
#import "FMCompetitorDataModel.h"

@interface FMCompetitorDataTableViewCell ()

@property (nonatomic,strong) UILabel *cutomerNameLabel;
@property (nonatomic,strong) UILabel *followLabel;
@property (nonatomic,strong) UILabel *comptitorLabel;
@property (nonatomic,strong) UILabel *lastMonthLabel;
@property (nonatomic,strong) UILabel *monthLabel;


@end

@implementation FMCompetitorDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cutomerNameLabel];
        [self.contentView addSubview:self.followLabel];
        [self.contentView addSubview:self.comptitorLabel];
        [self.contentView addSubview:self.lastMonthLabel];
        [self.contentView addSubview:self.monthLabel];
    }
    return self;
}

#pragma mark -- Public methods
#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMCompetitorDataModel *model = (FMCompetitorDataModel *)obj;
    self.cutomerNameLabel.text = model.customerName;
    self.followLabel.text = model.followUpPeopleName;
    self.comptitorLabel.text = model.competeGoodsName;
    self.lastMonthLabel.text = [NSString stringWithFormat:@"%.1f%%",model.lastMarketShare];
    self.monthLabel.text = [NSString stringWithFormat:@"%.1f%%",model.thisMarketShare];
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

#pragma mark 完成进度
- (UILabel *)comptitorLabel {
    if (!_comptitorLabel) {
        _comptitorLabel = [self setupLabelWithOriginX:kCustomerSalesWidth*2];
    }
    return _comptitorLabel;
}

#pragma mark 上月销量
- (UILabel *)lastMonthLabel {
    if (!_lastMonthLabel) {
        _lastMonthLabel = [self setupLabelWithOriginX:kCustomerSalesWidth*3];
    }
    return _lastMonthLabel;
}

#pragma mark 本月销量
- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [self setupLabelWithOriginX:kCustomerSalesWidth*4];
    }
    return _monthLabel;
}

@end
