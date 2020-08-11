//
//  FMDailyTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDailyTableViewCell.h"
#import "FMDailyReportModel.h"

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
- (void)fillContentWithData:(id)obj {
    FMDailyReportModel * model = (FMDailyReportModel *)obj;
    self.nameLabel.text = model.employeeName;
    self.statusLabel.text = model.punchTypeName;
    self.timeLabel.text = model.punchSecondTimeStr;
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake((70), 20));
    }];
    
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset((kScreen_Width-166-140)/2.0);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-6);
        make.size.mas_equalTo(CGSizeMake(124, 20));
    }];
}

#pragma mark -- Getters
#pragma mark 姓名
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont regularFontWithSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

#pragma mark 类型
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont regularFontWithSize:14];
        _statusLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

#pragma mark 时间
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont regularFontWithSize:14];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

@end
