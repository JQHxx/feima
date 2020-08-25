//
//  FMGoodsDetailsViewController.m
//  feima
//
//  Created by fei on 2020/8/21.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMGoodsDetailsViewController.h"
#import <YBImageBrowser/YBImageBrowser.h>

@interface FMGoodsDetailsViewController ()

@property (nonatomic,strong) UILabel               *titleLabel;
@property (nonatomic,strong) UILabel               *nameTitleLabel;
@property (nonatomic,strong) UILabel               *nameLabel; //名称
@property (nonatomic,strong) UIView                *line1;
@property (nonatomic,strong) UILabel               *cateTitleLabel;
@property (nonatomic,strong) UILabel               *cateLabel;   //品类
@property (nonatomic,strong) UIView                *line2;
@property (nonatomic,strong) UILabel               *comTitleLabel;
@property (nonatomic,strong) UILabel               *companyLabel; //公司
@property (nonatomic,strong) UIView                *line3;
@property (nonatomic,strong) UILabel               *photoTitleLabel; //商品照片
@property (nonatomic,strong) UIImageView           *photoView;

@end

@implementation FMGoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"商品信息";
    
    [self setupUI];
}

#pragma mark -- Event response
#pragma mark 查看大图
- (void)showLargePhotoAction {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
    YBIBImageData *data1 = [YBIBImageData new];
    data1.imageURL = [NSURL URLWithString:self.goods.images];
    [arr addObject:data1];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = arr;
    browser.currentPage = 0;
    [browser show];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(kNavBar_Height+20);
        make.size.mas_equalTo(CGSizeMake(120, 24));
    }];
    
    [self.view addSubview:self.nameTitleLabel];
    [self.nameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(65, 24));
    }];
    
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameTitleLabel.mas_right).offset(27);
        make.top.mas_equalTo(self.nameTitleLabel.mas_top);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(24);
    }];
    
    [self.view addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameTitleLabel.mas_left);
        make.top.mas_equalTo(self.nameTitleLabel.mas_bottom).offset(16);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.cateTitleLabel];
    [self.cateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(32);
        make.size.mas_equalTo(CGSizeMake(65, 24));
    }];
   
    [self.view addSubview:self.cateLabel];
    [self.cateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cateTitleLabel.mas_right).offset(27);
        make.top.mas_equalTo(self.cateTitleLabel.mas_top);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(24);
    }];
    
    [self.view addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameTitleLabel.mas_left);
        make.top.mas_equalTo(self.cateLabel.mas_bottom).offset(16);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.comTitleLabel];
    [self.comTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.cateTitleLabel.mas_bottom).offset(32);
        make.size.mas_equalTo(CGSizeMake(65,24));
    }];
    
     
    [self.view addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cateTitleLabel.mas_right).offset(27);
        make.top.mas_equalTo(self.comTitleLabel.mas_top);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(24);
    }];
    
    [self.view addSubview:self.line3];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameTitleLabel.mas_left);
        make.top.mas_equalTo(self.companyLabel.mas_bottom).offset(16);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.photoTitleLabel];
    [self.photoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.comTitleLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(120, 24));
    }];
    
    [self.view addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.photoTitleLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

#pragma mark -- Getters
#pragma mark 商品信息
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"商品信息";
        _titleLabel.font = [UIFont mediumFontWithSize:18];
        _titleLabel.textColor = [UIColor textBlackColor];
    }
    return _titleLabel;
}

#pragma mark 名称
- (UILabel *)nameTitleLabel {
    if (!_nameTitleLabel) {
        _nameTitleLabel = [[UILabel alloc] init];
        _nameTitleLabel.font = [UIFont regularFontWithSize:16];
        _nameTitleLabel.textColor = [UIColor textBlackColor];
        _nameTitleLabel.text = @"商品名称";
    }
    return _nameTitleLabel;
}

#pragma mark 商品名称
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont regularFontWithSize:16];
        _nameLabel.textColor = [UIColor textBlackColor];
        _nameLabel.text = self.goods.name;
    }
    return _nameLabel;
}

#pragma mark 线条1
- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor lineColor];
    }
    return _line1;
}

#pragma mark 品类标题
- (UILabel *)cateTitleLabel {
    if (!_cateTitleLabel) {
        _cateTitleLabel = [[UILabel alloc] init];
        _cateTitleLabel.font = [UIFont regularFontWithSize:16];
        _cateTitleLabel.textColor = [UIColor textBlackColor];
        _cateTitleLabel.text = @"品   类";
    }
    return _cateTitleLabel;
}

#pragma mark 品类
- (UILabel *)cateLabel {
    if (!_cateLabel) {
        _cateLabel = [[UILabel alloc] init];
        _cateLabel.font = [UIFont regularFontWithSize:16];
        _cateLabel.text = self.goods.categoryName;
        _cateLabel.textColor = [UIColor textBlackColor];
    }
    return _cateLabel;
}

#pragma mark 线条2
- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor lineColor];
    }
    return _line2;
}

#pragma mark 公司标题
- (UILabel *)comTitleLabel {
    if (!_comTitleLabel) {
        _comTitleLabel = [[UILabel alloc] init];
        _comTitleLabel.font = [UIFont regularFontWithSize:16];
        _comTitleLabel.textColor = [UIColor textBlackColor];
        _comTitleLabel.text = @"公   司";
    }
    return _comTitleLabel;
}

#pragma mark 公司
- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.font = [UIFont regularFontWithSize:16];
        _companyLabel.textColor = [UIColor textBlackColor];
        _companyLabel.text = self.goods.companyName;
    }
    return _companyLabel;
}

#pragma mark 线条3
- (UIView *)line3 {
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = [UIColor lineColor];
    }
    return _line3;
}

#pragma mark 商品照片
- (UILabel *)photoTitleLabel {
    if (!_photoTitleLabel) {
        _photoTitleLabel = [[UILabel alloc] init];
        _photoTitleLabel.text = @"商品照片";
        _photoTitleLabel.font = [UIFont mediumFontWithSize:18];
        _photoTitleLabel.textColor = [UIColor textBlackColor];
    }
    return _photoTitleLabel;
}

#pragma mark 商品照片
- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        [_photoView sd_setImageWithURL:[NSURL URLWithString:self.goods.images] placeholderImage:[UIImage ctPlaceholderImage]];
        [_photoView addTapPressed:@selector(showLargePhotoAction) target:self];
    }
    return _photoView;
}

@end
