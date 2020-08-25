//
//  FMGoodsTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMGoodsTableViewCell.h"

@interface FMGoodsTableViewCell ()

@property (nonatomic,strong) UIView      *rootView;
@property (nonatomic,strong) UIImageView *goodsImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *typeLabel;
@property (nonatomic,strong) UIButton    *offShelfBtn;
@property (nonatomic,strong) UIButton    *editBtn;

@property (nonatomic,strong) FMGoodsModel *goods;

@end

@implementation FMGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self setupUI];
    }
    return self;
}

#pragma mark -- Events
#pragma mark 下架 编辑
- (void)btnClickAction:(UIButton *)sender {
    if ([self.cellDelegate respondsToSelector:@selector(tableViewCell:didSelectedGoods:withBtnTag:)]) {
        [self.cellDelegate tableViewCell:self didSelectedGoods:self.goods withBtnTag:sender.tag];
    }
}

#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMGoodsModel *model = (FMGoodsModel *)obj;
    self.goods = model;
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:[UIImage ctPlaceholderImage]];
    self.nameLabel.text = model.name;
    self.typeLabel.text = [NSString stringWithFormat:@"品名：%@",model.categoryName];
    [self.offShelfBtn setTitle:model.status == 0 ? @"上架" : @"下架" forState:UIControlStateNormal];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-20, 80));
    }];
    
    [self.rootView addSubview:self.goodsImgView];
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(80, 60));
    }];
    
    
    [self.rootView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsImgView.mas_right).offset(12);
        make.top.mas_equalTo(self.goodsImgView.mas_top);
        make.height.mas_equalTo(22);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    [self.rootView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(17);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    BOOL hasPermission = [[FeimaManager sharedFeimaManager] hasPermissionWithApiStr:api_goods_update];
    if (hasPermission) {
        [self.rootView addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.rootView.mas_right).offset(-6);
            make.bottom.mas_equalTo(self.rootView.mas_bottom).offset(-9);
            make.size.mas_equalTo(CGSizeMake(50, 24));
        }];
        
        [self.rootView addSubview:self.offShelfBtn];
        [self.offShelfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.editBtn.mas_left).offset(-6);
            make.bottom.mas_equalTo(self.editBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(50, 24));
        }];
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
-(UIImageView *)goodsImgView{
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
    }
    return _goodsImgView;
}

#pragma mark 商品名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:16];
        _nameLabel.textColor = [UIColor textBlackColor];
    }
    return _nameLabel;
}

#pragma mark 商品类型
-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont regularFontWithSize:12];
        _typeLabel.textColor = [UIColor colorWithHexString:@"#9F9F9F"];
    }
    return _typeLabel;
}

#pragma mark 下架
- (UIButton *)offShelfBtn {
    if (!_offShelfBtn) {
        _offShelfBtn = [[UIButton alloc] init];
        [_offShelfBtn setTitle:@"下架" forState:UIControlStateNormal];
        [_offShelfBtn setTitleColor:[UIColor systemColor] forState:UIControlStateNormal];
        _offShelfBtn.titleLabel.font = [UIFont regularFontWithSize:14];
        _offShelfBtn.layer.cornerRadius = 12;
        _offShelfBtn.layer.borderColor = [UIColor systemColor].CGColor;
        _offShelfBtn.layer.borderWidth = 1;
        _offShelfBtn.clipsToBounds = YES;
        _offShelfBtn.tag = 1;
        [_offShelfBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _offShelfBtn;
}

#pragma mark 编辑
- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor systemColor] forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont regularFontWithSize:14];
        _editBtn.layer.cornerRadius = 12;
        _editBtn.layer.borderColor = [UIColor systemColor].CGColor;
        _editBtn.layer.borderWidth = 1;
        _editBtn.clipsToBounds = YES;
        _editBtn.tag = 2;
        [_editBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

@end
