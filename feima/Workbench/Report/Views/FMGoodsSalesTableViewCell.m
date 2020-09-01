//
//  FMGoodsSalesTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMGoodsSalesTableViewCell.h"
#import "FMProductTableView.h"

@interface FMGoodsSalesTableViewCell ()

@property (nonatomic, strong) UILabel            *nameLabel;        //业务员或部门
@property (nonatomic, strong) UIView             *lineView;
@property (nonatomic, strong) FMProductTableView *productTableView;

@end

@implementation FMGoodsSalesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(60, 24));
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(-1);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(1, 44));
        }];
        
        [self.contentView addSubview:self.productTableView];
        [self.productTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kScreen_Width-78, 44));
        }];
    }
    return self;
}

#pragma mark 填充数据
- (void)fillContentWithData:(FMGoodsSalesModel *)model type:(NSInteger)type {
    self.nameLabel.text = type == 0 ? model.employeeName : model.organizationName;
    self.productTableView.goodsArray = model.goods;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(model.goods.count*44);
    }];
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(model.goods.count*44);
    }];
    
    [self.productTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(model.goods.count*44);
    }];
}

+ (CGFloat)getCellHeightWithModel:(FMGoodsSalesModel *)model {
    return model.goods.count*44;
}

#pragma mark -- Getters
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lineColor];
    }
    return _lineView;
}

- (FMProductTableView *)productTableView {
    if (!_productTableView) {
        _productTableView = [[FMProductTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _productTableView;
}


@end
