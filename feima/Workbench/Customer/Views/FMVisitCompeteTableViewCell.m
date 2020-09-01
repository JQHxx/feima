//
//  FMVisitCompeteTableViewCell.m
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMVisitCompeteTableViewCell.h"
#import "FMCustomerVisitModel.h"

@interface FMVisitCompeteTableViewCell ()

@property (nonatomic, strong) UILabel        *nameLabel;
@property (nonatomic, strong) UILabel        *displayNumLabel;
@property (nonatomic, strong) UILabel        *purchaseNumLabel;

@end

@implementation FMVisitCompeteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMCompeteGoodsModel *model = (FMCompeteGoodsModel *)obj;
    self.nameLabel.text = [NSString stringWithFormat:@"竞品名称：%@",model.goodsName];
    self.displayNumLabel.text = [NSString stringWithFormat:@"陈列数量：%ld",model.quantity];
    self.purchaseNumLabel.text = [NSString stringWithFormat:@"进货数量：%ld",model.stock];
}

#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(25);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.displayNumLabel];
    [self.displayNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.purchaseNumLabel];
    [self.purchaseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.displayNumLabel.mas_bottom);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark -- Getters
#pragma mark 商品名
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont regularFontWithSize:14];
        _nameLabel.textColor = [UIColor textBlackColor];
    }
    return _nameLabel;
}

#pragma mark 数量
- (UILabel *)displayNumLabel {
    if (!_displayNumLabel) {
        _displayNumLabel = [[UILabel alloc] init];
        _displayNumLabel.font = [UIFont regularFontWithSize:14];
        _displayNumLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _displayNumLabel;
}

#pragma mark 数量
- (UILabel *)purchaseNumLabel {
    if (!_purchaseNumLabel) {
        _purchaseNumLabel = [[UILabel alloc] init];
        _purchaseNumLabel.font = [UIFont regularFontWithSize:14];
        _purchaseNumLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _purchaseNumLabel;
}

@end
