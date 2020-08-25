//
//  FMCustomerTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerTableViewCell.h"
#import "FMCustomerModel.h"

@interface FMCustomerTableViewCell ()

@property (nonatomic,strong) UIView      *rootView;
@property (nonatomic,strong) UIImageView *myImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *contactsLabel;
@property (nonatomic,strong) UILabel     *followLabel;
@property (nonatomic,strong) UILabel     *stateLabel;
@property (nonatomic,strong) UILabel     *addressLabel;


@end

@implementation FMCustomerTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        
        [self setupUI];
    }
    return self;
}

#pragma mark -- Private methods
- (void)setupUI {
    [self.contentView addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_greaterThanOrEqualTo(110);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.rootView addSubview:self.myImgView];
    [self.myImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.rootView.centerY);
        make.size.mas_equalTo(CGSizeMake(114, 90));
    }];
    
    
    [self.rootView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.myImgView.mas_right).offset(16);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.rootView.mas_right).offset(-10);
        make.height.mas_equalTo(22);
    }];
   
    [self.rootView addSubview:self.contactsLabel];
    [self.contactsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.rootView.mas_right).offset(-80);
        make.height.mas_equalTo(18);
    }];
    
    [self.rootView addSubview:self.followLabel];
    [self.followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.contactsLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(self.contactsLabel.mas_width);
        make.height.mas_equalTo(self.contactsLabel.mas_height);
    }];
    
    [self.rootView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.followLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.rootView.mas_right).offset(-10);
        make.height.mas_greaterThanOrEqualTo(18);
        make.bottom.mas_equalTo(self.rootView.mas_bottom).offset(-10);
    }];
    
    [self.rootView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.rootView.mas_centerY);
        make.right.mas_equalTo(self.rootView.mas_right).offset(-10);
        make.height.mas_equalTo(22);
    }];
}

#pragma mark 填充数据
- (void)fillContentWithData:(FMCustomerModel *)model showDistance:(BOOL)showDistance {
    [self.myImgView sd_setImageWithURL:[NSURL URLWithString:model.doorPhoto] placeholderImage:[UIImage ctPlaceholderImage]];
    self.nameLabel.text = model.businessName;
    self.contactsLabel.text = [NSString stringWithFormat:@"%@：%@",model.contactName,model.telephone];
    self.followLabel.text = [NSString stringWithFormat:@"跟进人：%@",model.employeeName];
    self.addressLabel.text = model.address;
    if (showDistance) {
        self.stateLabel.text = [NSString stringWithFormat:@"%.1fkm",model.distance];
        self.stateLabel.textColor = [UIColor colorWithHexString:@"#66666"];
    } else {
        if (model.visitCode == 2) {
            self.stateLabel.text = @"已拜访";
            self.stateLabel.textColor = RGB(115, 194, 125);
        } else {
            self.stateLabel.text = @"未拜访";
            self.stateLabel.textColor = [UIColor colorWithHexString:@"#9F9F9F"];
        }
    }
}

#pragma mark -- Getters
- (UIView *)rootView {
    if (!_rootView) {
        _rootView = [[UIView alloc] init];
        _rootView.backgroundColor = [UIColor whiteColor];
        _rootView.layer.cornerRadius = 4;
        _rootView.clipsToBounds = YES;
    }
    return _rootView;
}

#pragma mark 头像
- (UIImageView *)myImgView {
    if (!_myImgView) {
        _myImgView = [[UIImageView alloc] init];
    }
    return _myImgView;
}

#pragma mark 用户名
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:16];
        _nameLabel.textColor = [UIColor textBlackColor];
    }
    return _nameLabel;
}

#pragma mark 联系人
- (UILabel *)contactsLabel {
    if (!_contactsLabel) {
        _contactsLabel = [[UILabel alloc] init];
        _contactsLabel.font = [UIFont regularFontWithSize:12];
        _contactsLabel.textColor = [UIColor colorWithHexString:@"#9F9F9F"];
    }
    return _contactsLabel;
}

#pragma mark 跟进人
- (UILabel *)followLabel {
    if (!_followLabel) {
        _followLabel = [[UILabel alloc] init];
        _followLabel.font = [UIFont regularFontWithSize:12];
        _followLabel.textColor = [UIColor colorWithHexString:@"#9F9F9F"];
    }
    return _followLabel;
}

#pragma mark 地址
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont regularFontWithSize:12];
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _addressLabel.textColor = [UIColor colorWithHexString:@"#9F9F9F"];
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

#pragma mark 状态
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont regularFontWithSize:12];
        _stateLabel.textColor = [UIColor colorWithHexString:@"#9F9F9F"];
    }
    return _stateLabel;
}

@end
