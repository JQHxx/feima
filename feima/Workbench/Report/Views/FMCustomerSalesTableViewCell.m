//
//  FMCustomerSalesTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerSalesTableViewCell.h"

#define kMyWidth (kScreen_Width-16)/5.0

@interface FMCustomerSalesTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;        //客户名称
@property (nonatomic, strong) UILabel *followLabel;      //跟进人
@property (nonatomic, strong) UILabel *lastMonthLabel;   //上月销量
@property (nonatomic, strong) UILabel *monthLabel;       //本月销量
@property (nonatomic, strong) UILabel *progressLabel;    //完成进度

@end

@implementation FMCustomerSalesTableViewCell

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(kMyWidth, 24));
    }];
    
    [self.contentView addSubview:self.followLabel];
    [self.followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(kMyWidth, 24));
    }];
    
    [self.contentView addSubview:self.lastMonthLabel];
    [self.lastMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.followLabel.mas_right);
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
#pragma mark 客户名称
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

#pragma mark 跟进人
- (UILabel *)followLabel {
    if (!_followLabel) {
        _followLabel = [[UILabel alloc] init];
        _followLabel.font = [UIFont mediumFontWithSize:14];
        _followLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _followLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followLabel;
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
