//
//  FMDailyTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDailyTableViewCell.h"


@interface FMDailyTableViewCell ()

@property (nonatomic, strong) UILabel     *nameLabel; //姓名
@property (nonatomic, strong) UILabel     *statusLabel;
@property (nonatomic, strong) UILabel     *timeLabel; //时间

@end

@implementation FMDailyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark 填充数据
- (void)fillContentWithData:(FMDailyReportModel *)model index:(NSInteger)index {
    self.nameLabel.text = model.employeeName;
    if (index == 4) {
        self.statusLabel.text = @"未打卡";
    } else {
        self.statusLabel.text = model.punchTypeName;
    }
    
    self.timeLabel.text = model.punchSecondTimeStr;
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {

    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.nameLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
}

#pragma mark -- Getters
#pragma mark 姓名
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont regularFontWithSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

#pragma mark 类型
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont regularFontWithSize:14];
        _statusLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _statusLabel;
}

#pragma mark 时间
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont regularFontWithSize:14];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _timeLabel;
}

@end
