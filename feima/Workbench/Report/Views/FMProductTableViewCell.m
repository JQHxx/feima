//
//  FMProductTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMProductTableViewCell.h"
#import "FMProductTableView.h"

@interface FMProductTableViewCell ()

@property (nonatomic, strong) UILabel            *nameLabel;        //业务员或部门
@property (nonatomic, strong) UIView             *lineView;
@property (nonatomic, strong) FMProductTableView *productTableView;

@end

@implementation FMProductTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(kReportWidth, 24));
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
            make.size.mas_equalTo(CGSizeMake(kReportWidth*3, 44));
        }];
    }
    return self;
}

#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMEmployeeGoodsModel *employeeModel = (FMEmployeeGoodsModel *)obj;
    self.nameLabel.text = employeeModel.employeeName;
    self.productTableView.goodsArray = employeeModel.goods;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(employeeModel.goods.count*44);
    }];
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(employeeModel.goods.count*44);
    }];
    
    [self.productTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(employeeModel.goods.count*44);
    }];
}

+ (CGFloat)getCellHeightWithModel:(FMEmployeeGoodsModel *)model {
    return model.goods.count*44;
}

#pragma mark -- Getters
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
