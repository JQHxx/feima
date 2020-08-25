//
//  FMCustomerPopView.m
//  feima
//
//  Created by fei on 2020/8/19.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerPopView.h"
#import "QWAlertView.h"

@interface FMCustomerPopView ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView *addrImgView;
@property (nonatomic, strong) UILabel     *addressLabel;
@property (nonatomic, strong) UIImageView *phoneImgView;
@property (nonatomic, strong) UILabel     *phoneLabel;
@property (nonatomic, strong) UIImageView *nameImgView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIButton    *moreButton;
@property (nonatomic, strong) UIView      *line;
@property (nonatomic, strong) UIButton    *callButton;

@property (nonatomic, strong) FMCustomerModel *customer;

@end

@implementation FMCustomerPopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        [self drawShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 0) opacity:0.2 radius:4];
        [self setupUI];
    }
    return self;
}


#pragma mark -- Event response
#pragma mark 拨打电话
- (void)callCustomerPhoneAction:(UIButton *)sender {
    [[FeimaManager sharedFeimaManager] callPhoneWithNumber:self.customer.telephone];
}

#pragma mark 跳转事件
- (void)clickArrowAction:(UIButton *)sender {
    self.clickAction(self.customer);
}

#pragma mark -- Public methods
#pragma mark 填充数据
- (void)displayViewWithModel:(FMCustomerModel *)model {
    self.customer = model;
    self.titleLabel.text = model.businessName;
    self.addressLabel.text = model.address;
    self.phoneLabel.text = model.telephone;
    self.nameLabel.text = model.contactName;
}

#pragma mark -- Private methods
- (void)setupUI {
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(22);
        make.right.mas_equalTo(self.mas_right).offset(-20);
    }];
    
    [self addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(-20);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self addSubview:self.addrImgView];
    [self.addrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addrImgView.mas_right).offset(5);
        make.top.mas_equalTo(self.addrImgView.mas_top);
        make.right.mas_equalTo(self.moreButton.mas_left).offset(-20);
        make.height.mas_greaterThanOrEqualTo(17);
    }];
    
    [self addSubview:self.phoneImgView];
    [self.phoneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneImgView.mas_right).offset(5);
        make.top.mas_equalTo(self.phoneImgView.mas_top);
        make.right.mas_equalTo(self.moreButton.mas_left).offset(-20);
        make.height.mas_greaterThanOrEqualTo(17);
    }];
    
    [self addSubview:self.nameImgView];
    [self.nameImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addrImgView.mas_right).offset(5);
        make.top.mas_equalTo(self.nameImgView.mas_top);
        make.right.mas_equalTo(self.moreButton.mas_left).offset(-20);
        make.height.mas_greaterThanOrEqualTo(17);
    }];

    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.nameImgView.mas_bottom).offset(5);
        make.height.mas_equalTo(1);
    }];
    
    [self addSubview:self.callButton];
    [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.line.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
    
}

#pragma mark -- Getters
#pragma mark 姓名
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont mediumFontWithSize:16];
        _titleLabel.textColor = [UIColor textBlackColor];
    }
    return _titleLabel;
}

#pragma mark 地址icon
- (UIImageView *)addrImgView {
    if (!_addrImgView) {
        _addrImgView = [[UIImageView alloc] init];
        _addrImgView.image = ImageNamed(@"customer_address_black");
    }
    return _addrImgView;
}

#pragma mark 地址
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont regularFontWithSize:14];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

#pragma mark 电话icon
- (UIImageView *)phoneImgView {
    if (!_phoneImgView) {
        _phoneImgView = [[UIImageView alloc] init];
        _phoneImgView.image = ImageNamed(@"customer_phone");
    }
    return _phoneImgView;
}

#pragma mark 电话
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont regularFontWithSize:14];
        _phoneLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _phoneLabel;
}

#pragma mark 姓名icon
- (UIImageView *)nameImgView {
    if (!_nameImgView) {
        _nameImgView = [[UIImageView alloc] init];
        _nameImgView.image = ImageNamed(@"customer_portrait");
    }
    return _nameImgView;
}

#pragma mark 姓名
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont regularFontWithSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _nameLabel;
}

#pragma mark
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:ImageNamed(@"customer_arrow") forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(clickArrowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

#pragma mark 线条
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lineColor];
    }
    return _line;
}

#pragma mark 拨打电话
- (UIButton *)callButton {
    if (!_callButton) {
        _callButton = [[UIButton alloc] init];
        [_callButton setTitle:@"拨打客户电话" forState:UIControlStateNormal];
        [_callButton setImage:ImageNamed(@"customer_call") forState:UIControlStateNormal];
        [_callButton setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        _callButton.titleLabel.font = [UIFont mediumFontWithSize:14];
        [_callButton addTarget:self action:@selector(callCustomerPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callButton;
}

@end
