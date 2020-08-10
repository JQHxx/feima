//
//  FMSaleTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSaleTableViewCell.h"
#import "FMSalesModel.h"

@interface FMSaleTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;        //业务员或部门
@property (nonatomic, strong) UILabel *lastMonthLabel;   //上月销量
@property (nonatomic, strong) UILabel *monthLabel;       //本月销量
@property (nonatomic, strong) UILabel *progressLabel;    //完成进度

@end

@implementation FMSaleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMSalesModel *model = (FMSalesModel *)obj;
    self.nameLabel.text = model.employeeName;
    self.lastMonthLabel.text = [NSString stringWithFormat:@"%.3f", model.lastSales/10000.0];
    self.monthLabel.text = [NSString stringWithFormat:@"%.3f", model.thisSales/10000.0];
    self.progressLabel.text = [NSString stringWithFormat:@"%ld%%",model.progress];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(kMyWidth, 24));
    }];
    
    [self.contentView addSubview:self.lastMonthLabel];
    [self.lastMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(kMyWidth, 24));
    }];
    
    [self.contentView addSubview:self.monthLabel];
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lastMonthLabel.mas_right);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(kMyWidth, 24));
    }];
    
    [self.contentView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.monthLabel.mas_right);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(kMyWidth, 24));
    }];
}

#pragma mark -- Getters
#pragma mark 业务员或部门
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

#pragma mark 上月销量
- (UILabel *)lastMonthLabel {
    if (!_lastMonthLabel) {
        _lastMonthLabel = [[UILabel alloc] init];
        _lastMonthLabel.font = [UIFont regularFontWithSize:14];
        _lastMonthLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _lastMonthLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lastMonthLabel;
}

#pragma mark 本月销量
- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.font = [UIFont regularFontWithSize:14];
        _monthLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _monthLabel;
}

#pragma mark 完成进度
-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.font = [UIFont regularFontWithSize:14];
        _progressLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLabel;
}


@end
