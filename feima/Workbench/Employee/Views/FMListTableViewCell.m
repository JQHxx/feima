//
//  FMListTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMListTableViewCell.h"
#import "FMEmployeeModel.h"

@interface FMListTableViewCell ()

@property (nonatomic,strong) UIImageView *myImgView;
@property (nonatomic,strong) UILabel     *nameLabel;   //姓名
@property (nonatomic,strong) UIButton    *addressBtn;  //地址
@property (nonatomic,strong) UIButton    *timeBtn;     //时间
@property (nonatomic,strong) UILabel     *totalLabel;  //总客户
@property (nonatomic,strong) UILabel     *visitLabel;  //已拜访
@property (nonatomic,strong) UIButton    *phoneBtn;     //打电话

@end

@implementation FMListTableViewCell

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
    FMEmployeeModel *model = (FMEmployeeModel *)obj;
    self.nameLabel.text = model.name;
    [self.addressBtn setTitle:model.address forState:UIControlStateNormal];
    NSString *timeStr = [[FeimaManager sharedFeimaManager] timeWithTimeInterval:model.updateTime format:@"yyyy.MM.dd HH:mm"];
    [self.timeBtn setTitle:timeStr forState:UIControlStateNormal];
    self.totalLabel.text = [NSString stringWithFormat:@"总客户(3)"];
    self.visitLabel.text = [NSString stringWithFormat:@"已拜访(2)"];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.myImgView];
    [self.myImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.myImgView.mas_right).offset(10);
        make.top.mas_equalTo(10);
        make.width.mas_greaterThanOrEqualTo(60);
        make.height.mas_equalTo(25);
    }];
    
    [self.contentView addSubview:self.addressBtn];
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.width.mas_greaterThanOrEqualTo(20);
        make.height.mas_equalTo(25);
    }];
    
    [self.contentView addSubview:self.timeBtn];
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.addressBtn.mas_bottom);
        make.width.mas_greaterThanOrEqualTo(20);
        make.height.mas_equalTo(25);
    }];
    
    [self.contentView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.timeBtn.mas_bottom).offset(5);
        make.width.mas_greaterThanOrEqualTo(50);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.visitLabel];
    [self.visitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.totalLabel.mas_right).offset(10);
        make.top.mas_equalTo(self.timeBtn.mas_bottom).offset(5);
        make.width.mas_greaterThanOrEqualTo(50);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.phoneBtn];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark -- Getters
#pragma mark 头像
- (UIImageView *)myImgView {
    if (!_myImgView) {
        _myImgView = [[UIImageView alloc] init];
        _myImgView.backgroundColor = [UIColor lineColor];
    }
    return _myImgView;
}

#pragma mark 用户名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:16];
        _nameLabel.textColor = [UIColor textBlackColor];
    }
    return _nameLabel;
}

#pragma mark 地址
- (UIButton *)addressBtn {
    if (!_addressBtn) {
        _addressBtn = [[UIButton alloc] init];
        [_addressBtn setImage:ImageNamed(@"employee_address") forState:UIControlStateNormal];
        [_addressBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _addressBtn.titleLabel.font = [UIFont regularFontWithSize:14];
    }
    return _addressBtn;
}

#pragma mark 地址
- (UIButton *)timeBtn {
    if (!_timeBtn) {
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setImage:ImageNamed(@"employee_time") forState:UIControlStateNormal];
        [_timeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = [UIFont regularFontWithSize:14];
    }
    return _timeBtn;
}

#pragma mark 总客户
-(UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont regularFontWithSize:14];
        _totalLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _totalLabel;
}

#pragma mark 已拜访
-(UILabel *)visitLabel{
    if (!_visitLabel) {
        _visitLabel = [[UILabel alloc] init];
        _visitLabel.font = [UIFont regularFontWithSize:14];
        _visitLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _visitLabel;
}

#pragma mark 电话
- (UIButton *)phoneBtn {
    if (!_phoneBtn) {
        _phoneBtn = [[UIButton alloc] init];
        [_phoneBtn setImage:ImageNamed(@"employee_phone") forState:UIControlStateNormal];
    }
    return _phoneBtn;
}

@end
