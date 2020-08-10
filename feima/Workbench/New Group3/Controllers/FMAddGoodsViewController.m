//
//  FMAddGoodsViewController.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAddGoodsViewController.h"

@interface FMAddGoodsViewController ()

@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UILabel     *cateLabel;
@property (nonatomic,strong) UIButton    *photoBtn;

@end

@implementation FMAddGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = self.goods ? @"编辑商品":@"添加商品";
    
    [self setupUI];
}

#pragma mark -- Event response
#pragma mark 选择品类
- (void)chooseCategoryAction:(UITapGestureRecognizer *)sender {
    MyLog(@"chooseCategoryAction");
}

#pragma mark 上传图片
- (void)uploadPhotoAction:(UIButton *)sender {
    
}

#pragma mark 发布
- (void)confirmPublishAction:(UIButton *)sender {
    
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    
    //标题1
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(18, kNavBar_Height+20, 120, 24)];
    titleLab.text = @"商品信息";
    titleLab.font = [UIFont mediumFontWithSize:18];
    titleLab.textColor = [UIColor textBlackColor];
    [self.view addSubview:titleLab];
    
    NSArray *titlesArr = @[@"商品名称",@"品   类"];
    for (NSInteger i=0; i<titlesArr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(18,titleLab.bottom+53*i+20, 65, 22)];
        lab.font = [UIFont regularFontWithSize:15];
        lab.textColor = [UIColor textBlackColor];
        lab.text = titlesArr[i];
        [self.view addSubview:lab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(18, lab.bottom+16, kScreen_Width-36, 1)];
        line.backgroundColor = [UIColor lineColor];
        [self.view addSubview:line];
    }
    
    //商品名称
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, titleLab.bottom+20, kScreen_Width - 125, 22)];
    textField.font = [UIFont regularFontWithSize:15];
    textField.textColor = [UIColor textBlackColor];
    NSString *str = @"请填写商品名称";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]} range:NSMakeRange(0, str.length)];
    textField.attributedPlaceholder = attributedStr;
    [self.view addSubview:textField];
    self.nameTextField = textField;
    
    //品类
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(self.nameTextField.left,titleLab.bottom+73, kScreen_Width - 125, 22)];
    lab.font = [UIFont regularFontWithSize:15];
    lab.textColor = [UIColor colorWithHexString:@"#999999"];
    lab.text = @"请选择品类";
    [self.view addSubview:lab];
    self.cateLabel = lab;
    self.cateLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCategoryAction:)];
    [self.cateLabel addGestureRecognizer:tap];
    
    //标题2
    UILabel *picTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(18, self.cateLabel.bottom+30, 120, 24)];
    picTitleLab.text = @"商品照片";
    picTitleLab.font = [UIFont mediumFontWithSize:18];
    picTitleLab.textColor = [UIColor textBlackColor];
    [self.view addSubview:picTitleLab];
    
    //添加图片
    UIButton  *btn = [[UIButton alloc] initWithFrame:CGRectMake(18, picTitleLab.bottom+15, 74, 60)];
    [btn setTitle:@"+" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#B8B8B8"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont mediumFontWithSize:24];
    btn.layer.cornerRadius = 4;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#B8B8B8"].CGColor;
    btn.layer.borderWidth = 1;
    btn.clipsToBounds = YES;
    btn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    [btn addTarget:self action:@selector(uploadPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.photoBtn = btn;
    
    if (self.goods) {
        self.nameTextField.text = self.goods.name;
        self.cateLabel.text = self.goods.categoryName;
        self.cateLabel.textColor = [UIColor textBlackColor];
    }
    
    UIButton *confirmBtn = [UIButton submitButtonWithFrame:CGRectMake(18,self.photoBtn.bottom+40, kScreen_Width-36, 46) title:@"发布" target:self selector:@selector(confirmPublishAction:)];
    [self.view addSubview:confirmBtn];
}



@end
