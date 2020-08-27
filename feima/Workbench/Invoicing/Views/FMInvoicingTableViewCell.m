//
//  FMInvoicingTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInvoicingTableViewCell.h"
#import "FMOrderModel.h"
#import "NSString+Extend.h"

@interface FMInvoicingTableViewCell ()

@property (nonatomic,strong) UIView      *rootView;
@property (nonatomic,strong) UIImageView *myImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *typeLabel;
@property (nonatomic,strong) UILabel     *handleLabel;

@end

@implementation FMInvoicingTableViewCell

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
        make.top.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-20, 80));
    }];
    
    [self.rootView addSubview:self.myImgView];
    [self.myImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(80, 60));
    }];
    
    
    [self.rootView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.myImgView.mas_right).offset(12);
        make.top.mas_equalTo(self.myImgView.mas_top);
        make.height.mas_equalTo(22);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    [self.rootView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
        make.top.mas_equalTo(self.myImgView.mas_top);
        make.size.mas_equalTo(CGSizeMake(40, 24));
    }];
    
    [self.rootView addSubview:self.handleLabel];
    [self.handleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.myImgView.mas_right).offset(12);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(7);
        make.right.mas_equalTo(self.rootView.mas_right).offset(-10);
        make.height.mas_equalTo(22);
    }];
}

#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMOrderModel *model = (FMOrderModel *)obj;
    [self.myImgView sd_setImageWithURL:[NSURL URLWithString:model.employee.logo] placeholderImage:[UIImage ctPlaceholderImage]];
    self.nameLabel.text = model.employee.name;
    self.typeLabel.text = [self getTypeWithStatus:model.orderGoods.status orderType:model.orderGoods.orderType];
    self.typeLabel.backgroundColor = [self getTypeLabelColorWithStatus:model.orderGoods.status];
    CGFloat labW = [self.typeLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) withTextFont:self.typeLabel.font].width;
    [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(labW+20);
    }];
    self.handleLabel.text = kIsEmptyString(model.toEmployeeName) ? @"" : [NSString stringWithFormat:@"操作人：%@",model.toEmployeeName];
}

#pragma mark
- (NSString *)getTypeWithStatus:(NSInteger)status orderType:(NSString *)orderType{
    NSString *typeStr;
    switch (status) {
        case 1:
            typeStr = @"申请中";
            break;
        case 2:
            typeStr = @"同意配货";
            break;
        case 3:
            typeStr = @"拒绝配货";
            break;
        case 4:
            typeStr = @"已发货";
            break;
        case 5:
            typeStr = @"配货完成";
            break;
        case 21:
            typeStr = [orderType isEqualToString:@"RETURN"] ? @"申请退货" : @"申请换货";
            break;
        case 22:
            typeStr = [orderType isEqualToString:@"RETURN"] ? @"退货同意" : @"换货同意";
            break;
        case 23:
            typeStr = [orderType isEqualToString:@"RETURN"] ? @"退货拒绝" : @"换货拒绝";
            break;
        case 24:
            typeStr = @"已发货";
            break;
        case 25:
            typeStr = [orderType isEqualToString:@"RETURN"] ? @"退货完成" : @"换货完成";
            break;
        default:
            break;
    }
    return typeStr;
}

- (UIColor *)getTypeLabelColorWithStatus:(NSInteger)status {
    UIColor *color;
    switch (status) {
        case 1:
            color = [UIColor systemColor];
            break;
        case 2:
            color = [UIColor colorWithHexString:@"#7AC1AA"];
            break;
        case 3:
            color = [UIColor colorWithHexString:@"#FB767F"];
            break;
        case 4:
            color = [UIColor colorWithHexString:@"#8690C1"];
            break;
        case 5:
            color = [UIColor colorWithHexString:@"#7AC1AA"];
            break;
        case 21:
            color = [UIColor systemColor];
            break;
        case 22:
            color = [UIColor colorWithHexString:@"#7AC1AA"];
            break;
        case 23:
            color = [UIColor colorWithHexString:@"#FB767F"];
            break;
        case 24:
            color = [UIColor colorWithHexString:@"#8690C1"];
            break;
        case 25:
            color = [UIColor colorWithHexString:@"#7AC1AA"];
            break;
        default:
            break;
    }
    return color;
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
-(UIImageView *)myImgView{
    if (!_myImgView) {
        _myImgView = [[UIImageView alloc] init];
        _myImgView.layer.cornerRadius = 5;
        _myImgView.clipsToBounds = YES;
    }
    return _myImgView;
}

#pragma mark 用户名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:16];
        _nameLabel.textColor = [UIColor textBlackColor];
    }
    return _nameLabel;
}

#pragma mark 订单类型
-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont mediumFontWithSize:16];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.backgroundColor = [UIColor systemColor];
        _typeLabel.layer.cornerRadius = 10;
        _typeLabel.clipsToBounds = YES;
    }
    return _typeLabel;
}

#pragma mark 操作人
-(UILabel *)handleLabel{
    if (!_handleLabel) {
        _handleLabel = [[UILabel alloc] init];
        _handleLabel.font = [UIFont regularFontWithSize:12];
        _handleLabel.textColor = [UIColor colorWithHexString:@"#9F9F9F"];
    }
    return _handleLabel;
}


@end
