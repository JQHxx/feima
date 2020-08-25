//
//  FMAddInstucationViewController.m
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAddInstucationViewController.h"
#import "FMPhotoCollectionView.h"
#import "BRDatePickerView.h"

@interface FMAddInstucationViewController ()

@property (nonatomic,strong) UILabel               *nameLabel;
@property (nonatomic,strong) UITextField           *nameTextField; //名称
@property (nonatomic,strong) UIView                *line1;
@property (nonatomic,strong) UILabel               *timeTitleLabel;
@property (nonatomic,strong) UILabel               *timeLabel;   //截止时间
@property (nonatomic,strong) UIButton              *arrowBtn1;
@property (nonatomic,strong) UIView                *line2;
@property (nonatomic,strong) UILabel               *photoTitleLabel; //商品照片
@property (nonatomic,strong) FMPhotoCollectionView *photoView;
@property (nonatomic,strong) UIButton              *publishBtn;

@end

@implementation FMAddInstucationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"下达指令";
    
    [self setupUI];
}

#pragma mark -- Event response
#pragma mark 选择截止期限
- (void)chooseExpDateAction{
    [BRDatePickerView showDatePickerWithTitle:@"截止期限" dateType:UIDatePickerModeDate defaultSelValue:nil minDateStr:nil maxDateStr:nil isAutoSelect:NO resultBlock:^(NSString *selectValue) {
        MyLog(@"selectValue:%@",selectValue);
        self.timeLabel.text = selectValue;
    }];
}

#pragma mark 提交指令
- (void)submitInstrucationAction:(UIButton *)sender {
    
}


#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(kNavBar_Height+30);
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
    
    [self.view addSubview:self.timeTitleLabel];
    [self.timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(32);
        make.size.mas_equalTo(CGSizeMake(65, 24));
    }];
   
    [self.view addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeTitleLabel.mas_right).offset(27);
        make.top.mas_equalTo(self.timeTitleLabel.mas_top);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(24);
    }];
    
    [self.view addSubview:self.arrowBtn1];
    [self.arrowBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.right.mas_equalTo(-18);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.view addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(16);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.photoTitleLabel];
    [self.photoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(240, 24));
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
#pragma mark 名称
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont regularFontWithSize:16];
        _nameLabel.textColor = [UIColor textBlackColor];
        _nameLabel.text = @"指令";
    }
    return _nameLabel;
}

#pragma mark 商品名称
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.font = [UIFont regularFontWithSize:16];
        _nameTextField.textColor = [UIColor textBlackColor];
        NSString *str = @"请填写指令内容";
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]} range:NSMakeRange(0, str.length)];
        _nameTextField.attributedPlaceholder = attributedStr;
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

#pragma mark 时间标题
- (UILabel *)timeTitleLabel {
    if (!_timeTitleLabel) {
        _timeTitleLabel = [[UILabel alloc] init];
        _timeTitleLabel.font = [UIFont regularFontWithSize:16];
        _timeTitleLabel.textColor = [UIColor textBlackColor];
        _timeTitleLabel.text = @"截止期限";
    }
    return _timeTitleLabel;
}

#pragma mark 截止时间
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont regularFontWithSize:16];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _timeLabel.text = @"请选择截止期限";
        [_timeLabel addTapPressed:@selector(chooseExpDateAction) target:self];
    }
    return _timeLabel;
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

#pragma mark 商品照片
- (UILabel *)photoTitleLabel {
    if (!_photoTitleLabel) {
        _photoTitleLabel = [[UILabel alloc] init];
        _photoTitleLabel.font = [UIFont mediumFontWithSize:18];
        _photoTitleLabel.textColor = [UIColor textBlackColor];
        NSString *str = @"执行人*执行人可选择多个";
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont regularFontWithSize:14]} range:NSMakeRange(3, str.length-3)];
        _photoTitleLabel.attributedText = attributeStr;
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
    }
    return _photoView;
}

- (UIButton *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = [UIButton submitButtonWithFrame:CGRectZero title:@"提交" target:self selector:@selector(submitInstrucationAction:)];
    }
    return _publishBtn;
}



@end
