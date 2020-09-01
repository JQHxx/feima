//
//  FMMainGoodsTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMainGoodsTableViewCell.h"
#import "FMGoodsQuantityView.h"

@interface FMMainGoodsTableViewCell ()

@property (nonatomic, strong) UIImageView    *goodsImgView;
@property (nonatomic, strong) UILabel        *nameLabel;
@property (nonatomic, strong) UILabel        *stockLabel;
@property (nonatomic, strong) FMGoodsQuantityView *quatityView;
@property (nonatomic, strong) UIView         *lineView;

@property (nonatomic, strong) FMGoodsModel   *goods;

@end

@implementation FMMainGoodsTableViewCell

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
    FMGoodsModel *model = (FMGoodsModel *)obj;
    self.goods = model;
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:[UIImage ctPlaceholderImage]];
    self.nameLabel.text = model.name;
    if (model.isInStock) {
        self.stockLabel.text = [NSString stringWithFormat:@"库存：%ld", model.stock];
        self.stockLabel.hidden = NO;
    } else {
        self.stockLabel.hidden = YES;
    }
    self.quatityView.quatity = model.quantity;
}

#pragma mark -- Private methods
- (void)setupUI {
    [self.contentView addSubview:self.goodsImgView];
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(18);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(44, 60));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.goodsImgView.mas_top);
        make.width.mas_lessThanOrEqualTo(200);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.stockLabel];
    [self.stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.bottom.mas_equalTo(self.goodsImgView.mas_bottom);
        make.width.mas_greaterThanOrEqualTo(60);
        make.height.mas_equalTo(18);
    }];
    
    [self.contentView addSubview:self.quatityView];
    [self.quatityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 1));
    }];
}

#pragma mark -- Getters
#pragma mark 商品图片
- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
    }
    return _goodsImgView;
}

#pragma mark 商品名
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont regularFontWithSize:16];
        _nameLabel.textColor = [UIColor textBlackColor];
    }
    return _nameLabel;
}

#pragma mark 库存
- (UILabel *)stockLabel {
    if (!_stockLabel) {
        _stockLabel = [[UILabel alloc] init];
        _stockLabel.font = [UIFont regularFontWithSize:14];
        _stockLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _stockLabel;
}

#pragma mark 数量
- (FMGoodsQuantityView *)quatityView {
    if (!_quatityView) {
        _quatityView = [[FMGoodsQuantityView alloc] init];
        kSelfWeak;
        _quatityView.myBlock = ^(NSInteger quantity) {
            weakSelf.goods.quantity = quantity;
            if ([weakSelf.cellDelegate respondsToSelector:@selector(mainGoodsTableViewCellDidUpdateQuantityWithGoods:)]) {
                [weakSelf.cellDelegate mainGoodsTableViewCellDidUpdateQuantityWithGoods:weakSelf.goods];
            }
        };
    }
    return _quatityView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lineColor];
    }
    return _lineView;
}

@end
