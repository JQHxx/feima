//
//  FMPunchRecordTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMPunchRecordTableViewCell.h"
#import "FMPunchRecordModel.h"

@interface FMPunchRecordTableViewCell ()

@property (nonatomic,strong) UILabel  *timeLab;  //时间
@property (nonatomic,strong) UIView   *line1;
@property (nonatomic,strong) UILabel  *onWorkLab;  //上班
@property (nonatomic,strong) UIView   *line2;
@property (nonatomic,strong) UILabel  *offWorkLab; //下班


@end

@implementation FMPunchRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- Public methods
#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMPunchRecordModel *model = (FMPunchRecordModel *)obj;
    self.timeLab.text = [model.time substringFromIndex:model.time.length-2];
    NSString *onTime = [[FeimaManager sharedFeimaManager] timeWithTimeInterval:model.recordType.createTime format:@"HH:mm"];
    self.onWorkLab.text = [NSString stringWithFormat:@"%@\n%@",onTime,kIsEmptyString(model.recordType.statusName)?@"":model.recordType.statusName];
    
    NSString *offTime = [[FeimaManager sharedFeimaManager] timeWithTimeInterval:model.recordAfterType.createTime format:@"HH:mm"];
    self.offWorkLab.text = [NSString stringWithFormat:@"%@\n%@",offTime,kIsEmptyString(model.recordAfterType.statusName)?@"": model.recordAfterType.statusName];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kScreen_Width/3.0);
        make.height.mas_equalTo(50);
    }];
    
    [self.contentView addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLab.mas_right).offset(-1);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(self.contentView.mas_height);
    }];
    
    [self.contentView addSubview:self.onWorkLab];
    [self.onWorkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line1.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kScreen_Width/3.0);
        make.height.mas_equalTo(50);
    }];
    
    [self.contentView addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.onWorkLab.mas_right).offset(-1);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(self.contentView.mas_height);
    }];
    
    [self.contentView addSubview:self.offWorkLab];
    [self.offWorkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line2.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kScreen_Width/3.0);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark set lab
- (UILabel *)setupLabel{
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont regularFontWithSize:14];
    lab.textColor = [UIColor textBlackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    return lab;
}

#pragma mark -- Getters
#pragma mark 日期
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [self setupLabel];
    }
    return _timeLab;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor lineColor];
    }
    return _line1;
}

#pragma mark 上班
- (UILabel *)onWorkLab {
    if (!_onWorkLab) {
        _onWorkLab = [self setupLabel];
    }
    return _onWorkLab;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor lineColor];
    }
    return _line2;
}

#pragma mark 下班
- (UILabel *)offWorkLab {
    if (!_offWorkLab) {
        _offWorkLab = [self setupLabel];
    }
    return _offWorkLab;
}

@end
