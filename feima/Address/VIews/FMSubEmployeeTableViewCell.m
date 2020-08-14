//
//  FMSubEmployeeTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSubEmployeeTableViewCell.h"
#import "FMEmployeeModel.h"
#import "FMCustomerModel.h"

@interface FMSubEmployeeTableViewCell ()

@property (nonatomic,strong) UIImageView *myImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UIButton    *callBtn;
@property (nonatomic,strong) UIView      *lineView;

@property (nonatomic,strong) FMEmployeeModel *employee;
@property (nonatomic,strong) FMCustomerModel *customer;

@end

@implementation FMSubEmployeeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- Event response
#pragma mark 打电话
- (void)callAction: (UIButton *)sender {
    if (self.employee) {
        [[FeimaManager sharedFeimaManager] callPhoneWithNumber:self.employee.telephone];
    } else {
        [[FeimaManager sharedFeimaManager] callPhoneWithNumber:self.customer.telephone];
    }
}

#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    if ([obj isKindOfClass:[FMEmployeeModel class]]) {
        self.employee = (FMEmployeeModel *)obj;
        [self.myImgView sd_setImageWithURL:[NSURL URLWithString:self.employee.logo] placeholderImage:[UIImage ctPlaceholderImage]];
        self.nameLabel.text = self.employee.name;
    } else {
        self.customer = (FMCustomerModel *)obj;
        [self.myImgView sd_setImageWithURL:[NSURL URLWithString:self.customer.doorPhoto] placeholderImage:[UIImage ctPlaceholderImage]];
        self.nameLabel.text = self.customer.businessName;
    }
    
}

#pragma mark -- Private methods
- (void)setupUI {
    [self.contentView addSubview:self.myImgView];
    [self.myImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.myImgView.mas_right).offset(12);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(22);
        make.width.mas_greaterThanOrEqualTo(20);
    }];
    
    [self.contentView addSubview:self.callBtn];
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark 头像
-(UIImageView *)myImgView{
    if (!_myImgView) {
        _myImgView = [[UIImageView alloc] init];
        _myImgView.layer.cornerRadius = 17;
        _myImgView.clipsToBounds = YES;
    }
    return _myImgView;
}

#pragma mark 用户名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont regularFontWithSize:16];
        _nameLabel.textColor = [UIColor textBlackColor];
    }
    return _nameLabel;
}

#pragma mark 打电话
- (UIButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callBtn setImage:ImageNamed(@"call") forState:UIControlStateNormal];
        [_callBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn;
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
