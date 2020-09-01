//
//  FMCustomerHeadView.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerHeadView.h"

@interface FMCustomerHeadView ()

@property (nonatomic,strong) UIView   *bgView;
@property (nonatomic,strong) UIView   *rootView;
@property (nonatomic,strong) UILabel  *nameLabel;
@property (nonatomic,strong) UILabel  *addressLabel;
@property (nonatomic,strong) UILabel  *contactLabel;
@property (nonatomic,strong) UIButton *phoneBtn;

@property (nonatomic,strong) FMCustomerModel *model;

@end

@implementation FMCustomerHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- Public methods
#pragma mark 填充数据
- (void)displayViewWithData:(FMCustomerModel *)model {
    self.model = model;
    self.nameLabel.text = model.businessName;
    self.addressLabel.text = model.address;
    self.contactLabel.text = model.contactName;
    CGFloat labW = [model.contactName boundingRectWithSize:CGSizeMake(120, 26) withTextFont:self.contactLabel.font].width;
    [self.contactLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(labW+20);
    }];
}

#pragma mark -- Event
- (void)callAction:(UIButton *)sender {
    [[FeimaManager sharedFeimaManager] callPhoneWithNumber:self.model.telephone];
}

#pragma mark -- Private methods
#pragma mark setup UI
- (void)setupUI {
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(self.height/2.0);
    }];
    
    [self addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-20, 115));
    }];
    
    [self.rootView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(self.rootView.mas_right).offset(-10);
        make.height.mas_equalTo(22);
    }];
    
    [self.rootView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.right.mas_equalTo(self.rootView.mas_right).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.rootView addSubview:self.contactLabel];
    [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.addressLabel.mas_bottom);
        make.height.mas_equalTo(26);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [self.rootView addSubview:self.phoneBtn];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressLabel.mas_bottom);
        make.right.mas_equalTo(self.rootView.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(44, 26));
    }];
}

#pragma mark -- Getters
#pragma mark 背景
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor systemColor];
    }
    return _bgView;
}

#pragma mark root
- (UIView *)rootView {
    if (!_rootView) {
        _rootView = [[UIView alloc] init];
        _rootView.backgroundColor = [UIColor whiteColor];
        [_rootView drawShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 3) opacity:0.2 radius:4];
        _rootView.layer.cornerRadius = 4;
    }
    return _rootView;
}

#pragma mark 名称
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:16];
        _nameLabel.textColor = [UIColor textBlackColor];
    }
    return _nameLabel;
}

#pragma mark 地址
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont regularFontWithSize:12];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#9F9F9F"];
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

#pragma mark 联系人
- (UILabel *)contactLabel {
    if (!_contactLabel) {
        _contactLabel = [[UILabel alloc] init];
        _contactLabel.font = [UIFont regularFontWithSize:16];
        _contactLabel.textColor = [UIColor whiteColor];
        _contactLabel.backgroundColor = [UIColor systemColor];
        _contactLabel.layer.cornerRadius = 13;
        _contactLabel.clipsToBounds = YES;
        _contactLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contactLabel;
}

#pragma mark 电话
- (UIButton *)phoneBtn {
    if (!_phoneBtn) {
        _phoneBtn = [[UIButton alloc] init];
        _phoneBtn.backgroundColor = [UIColor systemColor];
        [_phoneBtn setImage:[UIImage drawImageWithName:@"contact_phone" size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        _phoneBtn.layer.cornerRadius = 13;
        _phoneBtn.clipsToBounds = YES;
        [_phoneBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}



@end
