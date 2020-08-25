//
//  FMAddGoodsViewController.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAddGoodsViewController.h"
#import "FMSelectCompanyViewController.h"
#import "FMPhotoCollectionView.h"
#import "FMGoodsViewModel.h"
#import "BRStringPickerView.h"

@interface FMAddGoodsViewController ()

@property (nonatomic,strong) UILabel               *titleLabel;
@property (nonatomic,strong) UILabel               *nameLabel;
@property (nonatomic,strong) UITextField           *nameTextField; //名称
@property (nonatomic,strong) UIView                *line1;
@property (nonatomic,strong) UILabel               *cateTitleLabel;
@property (nonatomic,strong) UILabel               *cateLabel;   //品类
@property (nonatomic,strong) UIButton              *arrowBtn1;
@property (nonatomic,strong) UIView                *line2;
@property (nonatomic,strong) UILabel               *comTitleLabel;
@property (nonatomic,strong) UILabel               *companyLabel; //公司
@property (nonatomic,strong) UIButton              *arrowBtn2;
@property (nonatomic,strong) UIView                *line3;
@property (nonatomic,strong) UILabel               *photoTitleLabel; //商品照片
@property (nonatomic,strong) FMPhotoCollectionView *photoView;
@property (nonatomic,strong) UIButton              *publishBtn;

@property (nonatomic,strong) FMUserModel      *user;
@property (nonatomic,strong) FMGoodsViewModel *adapter;

@end

@implementation FMAddGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = self.goods ? @"编辑商品":@"添加商品";
    
    self.user = [FeimaManager sharedFeimaManager].userBean.users;
    if (!self.goods) {
        self.goods = [[FMGoodsModel alloc] init];
        self.goods.goodsId = 0;
    }
    if (self.user.companyId > 0) {
        self.goods.companyName = self.user.companyName;
        self.goods.companyId = self.user.companyId;
    }
    
    [self setupUI];
}

#pragma mark -- Event response
#pragma mark 选择品类
- (void)chooseCategoryAction {
    MyLog(@"chooseCategoryAction");
    NSArray *data = @[@"本品",@"竞品"];
    kSelfWeak;
    [BRStringPickerView showStringPickerWithTitle:@"商品品类" dataSource:data defaultSelValue:self.goods.categoryName isAutoSelect:NO resultBlock:^(id selectValue) {
        weakSelf.cateLabel.text = selectValue;
        weakSelf.cateLabel.textColor = [UIColor textBlackColor];
    }];
}

#pragma mark 选择公司
- (void)chooseCompanyAction {
    FMSelectCompanyViewController *selectCompanyVC = [[FMSelectCompanyViewController alloc] init];
    selectCompanyVC.selCompanyId = self.goods.companyId;
    kSelfWeak;
    selectCompanyVC.selectedBlock = ^(FMCompanyModel *company) {
        weakSelf.goods.companyId = company.companyId;
        weakSelf.goods.companyName = company.name;
        weakSelf.companyLabel.text = company.name;
        weakSelf.companyLabel.textColor = [UIColor textBlackColor];
    };
    [self.navigationController pushViewController:selectCompanyVC animated:YES];
}

#pragma mark 发布
- (void)confirmPublishAction:(UIButton *)sender {
    NSInteger type = self.goods.goodsId > 0 ? 1 : 0;
    NSArray *images = [self.photoView getAllImages];
    kSelfWeak;
    [self.adapter addOrUpdateGoodsWithType:type goodsId:self.goods.goodsId name:self.nameTextField.text categoryName:self.cateLabel.text companyId:self.goods.companyId images:[images componentsJoinedByString:@","] complete:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.goods.name = weakSelf.nameTextField.text;
            weakSelf.goods.categoryName = weakSelf.cateLabel.text;
            weakSelf.goods.images = [images componentsJoinedByString:@","];
            if (weakSelf.goods.goodsId > 0) {
                if (weakSelf.updateSuccess) {
                    weakSelf.updateSuccess(weakSelf.goods);
                }
            } else {
                weakSelf.goods.goodsId = weakSelf.adapter.goodsId;
                if (weakSelf.addSuccess) {
                    weakSelf.addSuccess(weakSelf.goods);
                }
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.view makeToast:weakSelf.adapter.errorString duration:2.5 position:CSToastPositionCenter];
        }
    }];
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
    
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(65, 24));
    }];
    
    [self.view addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(27);
        make.top.mas_equalTo(self.nameLabel.mas_top);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(24);
    }];
    
    [self.view addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(16);
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
    
    [self.view addSubview:self.arrowBtn1];
    [self.arrowBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.cateLabel.mas_centerY);
        make.right.mas_equalTo(-18);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.view addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.cateLabel.mas_bottom).offset(16);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.comTitleLabel];
    [self.comTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.cateTitleLabel.mas_bottom).offset(self.user.companyId > 0 ? 0 : 32);
        make.size.mas_equalTo(CGSizeMake(65,self.user.companyId > 0 ? 0 : 24));
    }];
    
     
    if (self.user.companyId == 0) {
        [self.view addSubview:self.companyLabel];
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cateTitleLabel.mas_right).offset(27);
            make.top.mas_equalTo(self.comTitleLabel.mas_top);
            make.right.mas_equalTo(-40);
            make.height.mas_equalTo(24);
        }];
        
        [self.view addSubview:self.arrowBtn2];
        [self.arrowBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.companyLabel.mas_centerY);
            make.right.mas_equalTo(-18);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.view addSubview:self.line3];
        [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.top.mas_equalTo(self.companyLabel.mas_bottom).offset(16);
            make.right.mas_equalTo(-18);
            make.height.mas_equalTo(1);
        }];
    }
    
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
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(70);
    }];
    
    [self.view addSubview:self.publishBtn];
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.photoView.mas_bottom).offset(30);
        make.left.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-36, 46));
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
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont regularFontWithSize:16];
        _nameLabel.textColor = [UIColor textBlackColor];
        _nameLabel.text = @"商品名称";
    }
    return _nameLabel;
}

#pragma mark 商品名称
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.font = [UIFont regularFontWithSize:16];
        _nameTextField.textColor = [UIColor textBlackColor];
        NSString *str = @"请填写商品名称";
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]} range:NSMakeRange(0, str.length)];
        _nameTextField.attributedPlaceholder = attributedStr;
        _nameTextField.text = self.goods.goodsId > 0 ? self.goods.name :  @"";
    }
    return _nameTextField;
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
        _cateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _cateLabel.text = @"请选择品类";
        [_cateLabel addTapPressed:@selector(chooseCategoryAction) target:self];
        if (self.goods.goodsId > 0) {
            _cateLabel.text = self.goods.categoryName;
            _cateLabel.textColor = [UIColor textBlackColor];
        }
    }
    return _cateLabel;
}

- (UIButton *)arrowBtn1 {
    if (!_arrowBtn1) {
        _arrowBtn1 = [[UIButton alloc] init];
        [_arrowBtn1 setImage:ImageNamed(@"arrow_right") forState:UIControlStateNormal];
    }
    return _arrowBtn1;
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
        _companyLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _companyLabel.text = @"请选择公司";
        [_companyLabel addTapPressed:@selector(chooseCompanyAction) target:self];
    }
    return _companyLabel;
}

- (UIButton *)arrowBtn2 {
    if (!_arrowBtn2) {
        _arrowBtn2 = [[UIButton alloc] init];
        [_arrowBtn2 setImage:ImageNamed(@"arrow_right") forState:UIControlStateNormal];
    }
    return _arrowBtn2;
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

#pragma mark 添加照片
- (FMPhotoCollectionView *)photoView {
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _photoView = [[FMPhotoCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _photoView.canSelectedAlbum = YES;
        _photoView.maxImagesCount = 1;
        if (self.goods.goodsId > 0) {
            [_photoView addPickedImages:@[self.goods.images]];
        }
    }
    return _photoView;
}

- (UIButton *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = [UIButton submitButtonWithFrame:CGRectZero title:@"发布" target:self selector:@selector(confirmPublishAction:)];
    }
    return _publishBtn;
}

- (FMGoodsViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMGoodsViewModel alloc] init];
    }
    return _adapter;
}

@end
