//
//  FMMessageTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMessageTableViewCell.h"

@interface FMMessageTableViewCell ()

@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel     *titleLabel;
@property (nonatomic,strong) UILabel     *typeLabel;
@property (nonatomic,strong) UILabel     *timeLabel;
@property (nonatomic,strong) UIView      *lineView;


@end

@implementation FMMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconImgView];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.left.mas_equalTo(self.iconImgView.mas_right).offset(8);
            make.height.mas_equalTo(21);
            make.width.mas_greaterThanOrEqualTo(65);
        }];
        
        [self.contentView addSubview:self.typeLabel];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.height.mas_equalTo(21);
            make.width.mas_greaterThanOrEqualTo(65);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(14);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-14);
            make.height.mas_equalTo(16);
            make.width.mas_greaterThanOrEqualTo(20);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left).offset(-2);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMMessageModel *model = (FMMessageModel *)obj;
    self.titleLabel.text = [NSString stringWithFormat:@"%@:%@",model.organizationName,model.employee.name];
    self.typeLabel.text = model.message;
    self.timeLabel.text = [[FeimaManager sharedFeimaManager] timeWithTimeInterval:model.updateTime format:@"HH:mm"];
}

#pragma mark -- Getters
#pragma mark 头像
-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.backgroundColor = [UIColor lightGrayColor];
    }
    return _iconImgView;
}

#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont mediumFontWithSize:15];
        _titleLabel.textColor = [UIColor textBlackColor];
        _titleLabel.text = @"市场部：以于涛";
    }
    return _titleLabel;
}

#pragma mark 描述
-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont regularFontWithSize:14];
        _typeLabel.textColor = [UIColor colorWithHexString:@"#AAACAF"];
        _titleLabel.text = @"下班打开";
    }
    return _typeLabel;
}

#pragma mark 时间
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont regularFontWithSize:11];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#BFC1C2"];
        _timeLabel.text = @"12:30";
    }
    return _timeLabel;
}

#pragma mark 线条
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lineColor];
    }
    return _lineView;
}

@end
