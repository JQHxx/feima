//
//  FMDistributionTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDistributionTableViewCell.h"
#import "FMQuantityView.h"
#import "FMOrderDetaiModel.h"
#import "FMGoodsModel.h"

@interface FMDistributionTableViewCell ()

@property (nonatomic,strong) UIView      *rootView;
@property (nonatomic,strong) UIImageView *goodsImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *typeLabel;
@property (nonatomic,strong) UILabel     *numLabel;
@property (nonatomic,strong) UIView      *lineView;
@property (nonatomic,strong) UIButton    *addBtn;
@property (nonatomic,strong) FMQuantityView *quantityView;

@property (nonatomic,strong) FMGoodsModel *goods;

@end

@implementation FMDistributionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self setupUI];
    }
    return self;
}

#pragma mark -- Event response
#pragma mark
- (void)addAction:(UIButton *)sender {
    self.addBtn.hidden = YES;
    self.quantityView.hidden = NO;
    self.goods.quantity = 1;
    kSelfWeak;
    self.quantityView.myBlock = ^(NSInteger quantity) {
        weakSelf.goods.quantity = quantity;
        if ([weakSelf.cellDelegate respondsToSelector:@selector(distributionTableViewDidSelectedGoods:)]) {
            [weakSelf.cellDelegate distributionTableViewDidSelectedGoods:weakSelf.goods];
        }
    };
}

#pragma mark 填充数据
- (void)fillContentWithData:(FMGoodsModel *)model type:(NSInteger)type {
    self.goods = model;
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:[UIImage ctPlaceholderImage]];
    self.nameLabel.text = model.name;
    
    if (type == 0) {
        self.typeLabel.text = [NSString stringWithFormat:@"品名：%@",model.categoryName];
        self.numLabel.hidden = self.lineView.hidden = NO;
        self.addBtn.hidden = YES;
        self.numLabel.text = [NSString stringWithFormat:@"%ld", model.quantity];
    } else {
        self.numLabel.hidden = self.lineView.hidden = YES;
        self.addBtn.hidden = NO;
        if (type == 1) {
            self.typeLabel.text = [NSString stringWithFormat:@"品名：%@",model.categoryName];
        } else {
            self.typeLabel.text = [NSString stringWithFormat:@"库存：%ld",model.stock];
        }
    }
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.top.mas_equalTo(16);
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
    
    [self.rootView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rootView.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.rootView.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    [self.rootView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rootView.mas_right).offset(-10);
        make.top.mas_equalTo(self.numLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.numLabel.mas_left).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [self.rootView addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rootView.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.rootView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.addBtn.hidden = YES;
    
    [self.rootView addSubview:self.quantityView];
    [self.quantityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rootView.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.rootView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    self.quantityView.hidden = YES;
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

#pragma mark 数量
-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont regularFontWithSize:14];
        _numLabel.textColor = [UIColor textBlackColor];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lineColor];
    }
    return _lineView;
}

#pragma mark 添加
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont mediumFontWithSize:20];
        [_addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

#pragma mark 数量选择
- (FMQuantityView *)quantityView {
    if (!_quantityView) {
        _quantityView = [[FMQuantityView alloc] initWithFrame:CGRectZero];
    }
    return _quantityView;
}


@end
