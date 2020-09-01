//
//  FMVisitGoodsTableViewCell.m
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMVisitGoodsTableViewCell.h"
#import "FMOrderSellModel.h"
#import "FMCustomerVisitModel.h"

@interface FMVisitGoodsTableViewCell ()

@property (nonatomic, strong) UIImageView    *goodsImgView;
@property (nonatomic, strong) UILabel        *nameLabel;
@property (nonatomic, strong) UILabel        *stockLabel;


@end

@implementation FMVisitGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    if ([obj isKindOfClass:[FMCustomerStockModel class]]) {
        FMCustomerStockModel *model = (FMCustomerStockModel *)obj;
        NSArray *images = [model.images componentsSeparatedByString:@","];
        [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage ctPlaceholderImage]];
        self.nameLabel.text = model.goodsName;
        self.stockLabel.text = [NSString stringWithFormat:@"现存数量：%ld包",model.number];
    } else if ([obj isKindOfClass:[FMOrderSellModel class]]) {
        FMOrderSellModel *model = (FMOrderSellModel *)obj;
        FMGoodsModel *goods = model.goods;
        NSArray *images = [goods.images componentsSeparatedByString:@","];
        [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage ctPlaceholderImage]];
        self.nameLabel.text = goods.name;
        self.stockLabel.text = [NSString stringWithFormat:@"销量：%ld包",model.orderSellDetail.num];
    }
}

#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.goodsImgView];
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(25);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(44, 60));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsImgView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_lessThanOrEqualTo(200);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.stockLabel];
    [self.stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(40);
        make.height.mas_equalTo(18);
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
        _nameLabel.font = [UIFont mediumFontWithSize:16];
        _nameLabel.textColor = [UIColor textBlackColor];
    }
    return _nameLabel;
}

#pragma mark 数量
- (UILabel *)stockLabel {
    if (!_stockLabel) {
        _stockLabel = [[UILabel alloc] init];
        _stockLabel.font = [UIFont regularFontWithSize:14];
        _stockLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _stockLabel;
}

@end
