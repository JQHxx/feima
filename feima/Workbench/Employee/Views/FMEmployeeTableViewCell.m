//
//  FMEmployeeTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMEmployeeTableViewCell.h"
#import "FMEmployeeModel.h"

@interface FMEmployeeTableViewCell ()

@property (nonatomic,strong) UIImageView *myImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *typeLabel;
@property (nonatomic,strong) UIButton    *moreBtn;

@end

@implementation FMEmployeeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- Event response
#pragma mark 更多
- (void)moreAction: (UIButton *)sender {
    
}

#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMEmployeeModel *model = (FMEmployeeModel *)obj;
    self.nameLabel.text = model.name;
    self.typeLabel.text = [model.organizationName substringToIndex:1];
}

#pragma mark -- Private methods
- (void)setupUI {
    [self.contentView addSubview:self.myImgView];
    [self.myImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.myImgView.mas_right).offset(12);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(22);
        make.width.mas_greaterThanOrEqualTo(20);
    }];
    
    [self.contentView addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.moreBtn.mas_left).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark 头像
-(UIImageView *)myImgView{
    if (!_myImgView) {
        _myImgView = [[UIImageView alloc] init];
        _myImgView.backgroundColor = [UIColor lightGrayColor];
    }
    return _myImgView;
}

#pragma mark 用户名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:14];
        _nameLabel.textColor = [UIColor textBlackColor];
    }
    return _nameLabel;
}

#pragma mark 职务
-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont regularFontWithSize:12];
        _typeLabel.textColor = [UIColor textBlackColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.backgroundColor = [UIColor systemColor];
        _typeLabel.layer.cornerRadius = 15;
        _typeLabel.clipsToBounds = YES;
    }
    return _typeLabel;
}

#pragma mark 更多
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:ImageNamed(@"back_theme") forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
