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
    self.nameLabel.text = model.employee.name;
    self.typeLabel.text = @"申请配货";
    CGFloat labW = [self.typeLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) withTextFont:self.typeLabel.font].width;
    [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(labW+20);
    }];
    self.handleLabel.text = [NSString stringWithFormat:@"操作人：%@",model.toEmployeeName];
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
        _myImgView.backgroundColor = [UIColor lightGrayColor];
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
