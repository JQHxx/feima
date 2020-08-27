//
//  FMSalesReportTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/26.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSalesReportTableViewCell.h"

@interface FMSalesReportTableViewCell ()

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *lastMonthLabel;
@property (nonatomic,strong) UILabel *monthLabel;
@property (nonatomic,strong) UILabel *progressLabel;

@end

@implementation FMSalesReportTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.lastMonthLabel];
        [self.contentView addSubview:self.monthLabel];
        [self.contentView addSubview:self.progressLabel];
    }
    return self;
}

#pragma mark 填充数据
- (void)fillContentWithData:(FMSalesModel *)model type:(NSInteger)type {
    self.nameLabel.text = type == 0 ? model.employeeName : model.organizationName;
    self.lastMonthLabel.text = [NSString stringWithFormat:@"%.3f", model.lastSales];
    self.monthLabel.text = [NSString stringWithFormat:@"%.3f", model.thisSales];
    self.progressLabel.text = [NSString stringWithFormat:@"%ld%%",model.progress];
}

#pragma mark -- Private methods
#pragma mark setup label
- (UILabel *)setupLabelWithOriginX:(CGFloat)originX {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, kReportWidth, 24)];
    lab.font = [UIFont mediumFontWithSize:14];
    lab.textColor = [UIColor colorWithHexString:@"#666666"];
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

#pragma mark -- Getters
#pragma mark 姓名
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [self setupLabelWithOriginX:0];
    }
    return _nameLabel;
}

#pragma mark 上月销量
- (UILabel *)lastMonthLabel {
    if (!_lastMonthLabel) {
        _lastMonthLabel = [self setupLabelWithOriginX:kReportWidth];
    }
    return _lastMonthLabel;
}

#pragma mark 本月销量
- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [self setupLabelWithOriginX:kReportWidth*2];
    }
    return _monthLabel;
}

#pragma mark 完成进度
- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [self setupLabelWithOriginX:kReportWidth*3];
    }
    return _progressLabel;
}

@end
