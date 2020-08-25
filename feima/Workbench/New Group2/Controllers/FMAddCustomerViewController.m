//
//  FMAddCustomerViewController.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAddCustomerViewController.h"
#import "FMPhotoCollectionView.h"
#import "FMPublicViewModel.h"
#import "FMCustomerViewModel.h"
#import "BRStringPickerView.h"
#import "FMLocationManager.h"

@interface FMAddCustomerViewController (){
    NSArray *basicTitlesArr;
    NSArray *detailTitlesArr;
}

@property (nonatomic, strong) UIScrollView   *rootScrollView;
@property (nonatomic, strong) UILabel        *basicLabel;
@property (nonatomic, strong) UITextField    *nameTextField;   //名称
@property (nonatomic, strong) UITextField    *shortNameTextField; //简称
@property (nonatomic, strong) UITextField    *contactTextField; //联系人
@property (nonatomic, strong) UITextField    *phoneTextField;  //手机号
@property (nonatomic, strong) UILabel        *addressLabel;   //位置
@property (nonatomic, strong) UIButton       *refreshBtn;   //更新位置
@property (nonatomic, strong) UILabel        *photoTitleLab;  //
@property (nonatomic, strong) UILabel        *photoDescLab;
@property (nonatomic, strong) FMPhotoCollectionView *photoView;

@property (nonatomic, strong) UILabel        *detailLabel;
@property (nonatomic, strong) UILabel        *industryLab;   //行业类型
@property (nonatomic, strong) UILabel        *levelLab;      //客户等级
@property (nonatomic, strong) UITextField    *areaTextField; //陈列面积
@property (nonatomic, strong) UILabel        *followPressLab; //跟进进度
@property (nonatomic, strong) UILabel        *followLab;    //跟进人
@property (nonatomic, strong) UIButton       *followArrowBtn;
@property (nonatomic, strong) UIButton       *submitBtn;

@property (nonatomic, strong) FMPublicViewModel *publicAdapter;
@property (nonatomic, strong) FMCustomerViewModel *adapter;

@end

@implementation FMAddCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = self.customerModel ? @"修改客户信息" : @"新增客户";
    
    basicTitlesArr = @[@"名称*",@"简称",@"联系人*",@"手机号*",@"位置*"];
    detailTitlesArr = @[@"行业类型*",@"客户等级*",@"陈列面积*",@"跟进进度*",@"跟进人"];
    
    if (!self.customerModel) {
        self.customerModel = [[FMCustomerModel alloc] init];
        self.customerModel.customerId = 0;
        [self getCurrentAddress];
    }
    [self setupUI];
    [self setFollower];
}

#pragma mark -- Event response
#pragma mark 保存
- (void)submitCustomerAction:(UIButton *)sender {
    NSInteger type = self.customerModel ? 1 : 0;
    NSArray *images = [self.photoView getAllImages];
    kSelfWeak;
    [self.adapter addOrUpdateCustomerWithType:type customerId:self.customerModel.customerId businessName:self.nameTextField.text nickName:self.shortNameTextField.text contactName:self.contactTextField.text telephone:self.phoneTextField.text address:self.addressLabel.text latitude:self.customerModel.latitude longitude:self.customerModel.longitude doorPhoto:images industryType:self.customerModel.industryType grade:self.customerModel.grade displayArea:self.areaTextField.text progress:self.customerModel.progress employeeId:self.customerModel.employeeId complete:^(BOOL isSuccess) {
        if (isSuccess) {
            if (weakSelf.customerModel.customerId > 0) {
                weakSelf.customerModel.businessName = weakSelf.nameTextField.text;
                weakSelf.customerModel.nickName = weakSelf.shortNameTextField.text;
                weakSelf.customerModel.contactName = weakSelf.contactTextField.text;
                weakSelf.customerModel.telephone = weakSelf.phoneTextField.text;
                weakSelf.customerModel.doorPhoto = [images componentsJoinedByString:@","];
                weakSelf.areaTextField.text = weakSelf.areaTextField.text;
                if (weakSelf.updateSuccess) {
                    weakSelf.updateSuccess(weakSelf.customerModel);
                }
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.view makeToast:weakSelf.adapter.errorString duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark 选择
- (void)selectedInfoAction:(UITapGestureRecognizer *)gesture {
    NSInteger tag = gesture.view.tag;
    MyLog(@"tag:%ld",tag);
    if (tag == 104) { //选择跟进人
        
    } else {
        NSString *groupStr = @"";
        if (tag == 100) {
            groupStr = kIndustryTypeKey;
        } else if (tag == 101) {
            groupStr = kCustomerLevelKey;
        } else if (tag == 103) {
            groupStr = kFollowUpProgressKey;
        }
        [self.publicAdapter loadGroupDataWithGroupStr:groupStr complete:^(BOOL isSuccess) {
            [self selectedCustomerInfoWithIndex:tag];
        }];
    }
}

#pragma mark 更新位置
- (void)refreshCustomerAddressAction:(UIButton *)sender {
    [self getCurrentAddress];
}

#pragma mark -- Private methods
#pragma mark 获取当前位置
- (void)getCurrentAddress {
    kSelfWeak;
    [[FMLocationManager sharedInstance] getAddressDetail:^(FMAddressModel *addressModel) {
        weakSelf.addressLabel.text = addressModel.detailAddress;
        weakSelf.customerModel.longitude = addressModel.longitude;
        weakSelf.customerModel.latitude = addressModel.latitude;
        weakSelf.customerModel.address = addressModel.detailAddress;
    }];
}

#pragma mark 选择信息
- (void)selectedCustomerInfoWithIndex:(NSInteger)index {
    [self.nameTextField resignFirstResponder];
    [self.shortNameTextField resignFirstResponder];
    [self.contactTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.areaTextField resignFirstResponder];
    NSString *title = nil;
    NSArray *data;
    NSString *defautValue = nil;
    if (index == 100) {
        title = @"行业类型";
        defautValue = self.customerModel ? self.customerModel.industryName : @"";
        data = self.publicAdapter.industryTypesArray;
    } else if (index == 101) {
        title = @"客户等级";
        data = self.publicAdapter.levelArray;
        defautValue = self.customerModel ? self.customerModel.gradeName : @"";
    } else if (index == 103) {
        title = @"跟进进度";
        data = self.publicAdapter.progressArray;
        defautValue = self.customerModel ? self.customerModel.progressName : @"";
    }
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (FMGroupModel *model in data) {
        [tempArr addObject:model.dictValue];
    }
    
    [BRStringPickerView showStringPickerWithTitle:title dataSource:tempArr defaultSelValue:defautValue isAutoSelect:NO resultBlock:^(id selectValue) {
        MyLog(@"selectValue:%@",selectValue);
        if (index == 100) {
            for (FMGroupModel *model in self.publicAdapter.industryTypesArray) {
                if ([model.dictValue isEqualToString:selectValue]) {
                    if (self.customerModel) {
                        self.customerModel.industryName = selectValue;
                        self.customerModel.industryType = model.dictKey;
                    }
                    self.industryLab.text = selectValue;
                    self.industryLab.textColor = [UIColor colorWithHexString:@"#666666"];
                    break;
                }
            }
        } else if (index == 101) {
            for (FMGroupModel *model in self.publicAdapter.levelArray) {
                if ([model.dictValue isEqualToString:selectValue]) {
                    if (self.customerModel) {
                        self.customerModel.gradeName = selectValue;
                        self.customerModel.grade = model.dictKey;
                    }
                    self.levelLab.text = selectValue;
                    self.levelLab.textColor = [UIColor colorWithHexString:@"#666666"];
                    break;
                }
            }
        } else if (index == 103) {
            for (FMGroupModel *model in self.publicAdapter.progressArray) {
                if ([model.dictValue isEqualToString:selectValue]) {
                    if (self.customerModel) {
                        self.customerModel.progressName = selectValue;
                        self.customerModel.progress = model.dictKey;
                    }
                    self.followPressLab.text = selectValue;
                    self.followPressLab.textColor = [UIColor colorWithHexString:@"#666666"];
                    break;
                }
            }
        }
    }];
}

#pragma mark 选择跟进人
- (void)loadEmployeeData {
    
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView addSubview:self.basicLabel];
    for (NSInteger i=0; i<basicTitlesArr.count; i++) {
        UILabel *lab = [self setupTitlelabelWithFrame:CGRectMake(20,self.basicLabel.bottom+15+60*i,80, 30) TitleStr:basicTitlesArr[i]];
        [self.rootScrollView addSubview:lab];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, lab.bottom+(i==4?30:15), kScreen_Width-20, 1)];
        line.backgroundColor = [UIColor lineColor];
        [self.rootScrollView addSubview:line];
    }
    [self.rootScrollView addSubview:self.nameTextField];
    [self.rootScrollView addSubview:self.shortNameTextField];
    [self.rootScrollView addSubview:self.contactTextField];
    [self.rootScrollView addSubview:self.phoneTextField];
    [self.rootScrollView addSubview:self.addressLabel];
    [self.rootScrollView addSubview:self.refreshBtn];
    [self.rootScrollView addSubview:self.photoTitleLab];
    [self.rootScrollView addSubview:self.photoDescLab];
    [self.rootScrollView addSubview:self.photoView];
    [self.rootScrollView addSubview:self.detailLabel];
    for (NSInteger i=0; i<detailTitlesArr.count; i++) {
        UILabel *lab = [self setupTitlelabelWithFrame:CGRectMake(20,self.detailLabel.bottom+15+60*i,80, 30) TitleStr:detailTitlesArr[i]];
        [self.rootScrollView addSubview:lab];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, lab.bottom+15, kScreen_Width-20, 1)];
        line.backgroundColor = [UIColor lineColor];
        [self.rootScrollView addSubview:line];
    }
    [self.rootScrollView addSubview:self.industryLab];
    [self.rootScrollView addSubview:self.levelLab];
    [self.rootScrollView addSubview:self.areaTextField];
    [self.rootScrollView addSubview:self.followPressLab];
    [self.rootScrollView addSubview:self.followLab];
    [self.rootScrollView addSubview:self.followArrowBtn];
    [self.rootScrollView addSubview:self.submitBtn];
    [self.rootScrollView setContentSize:CGSizeMake(kScreen_Width, self.submitBtn.bottom+20)];
}

#pragma mark 跟进人判断
- (void)setFollower {
    NSString *account = [FeimaManager sharedFeimaManager].userBean.account;
    if ([account isEqualToString:@"administrator"]) {
        self.followLab.userInteractionEnabled = NO;
        self.followArrowBtn.hidden = YES;
        if (self.customerModel.customerId > 0) {
            self.followLab.hidden = NO;
            self.followLab.text = self.customerModel.employeeName;
            self.followLab.textColor = [UIColor colorWithHexString:@"#666666"];
        } else {
            self.customerModel.employeeId = 0;
            self.followLab.hidden = YES;
        }
    } else {
        self.followLab.hidden = NO;
        FMUserModel *user = [FeimaManager sharedFeimaManager].userBean.users;
        if (user.postId == 5 || user.employeeId == 0) { //业务员
            if (self.customerModel.customerId > 0) {
                self.followLab.text =  self.customerModel.employeeName;
            } else {
                self.followLab.text =  user.name;
                self.customerModel.employeeId = user.employeeId;
                self.customerModel.employeeName = user.name;
            }
            self.followLab.textColor = [UIColor colorWithHexString:@"#666666"];
            self.followLab.userInteractionEnabled = NO;
            self.followArrowBtn.hidden = YES;
        } else {
            if (self.customerModel.customerId > 0) {
                self.followLab.text =  self.customerModel.employeeName;
                self.followLab.textColor = [UIColor colorWithHexString:@"#666666"];
            } else {
                self.followLab.textColor = [UIColor colorWithHexString:@"#999999"];
                self.followLab.text = @"请选择跟进人";
            }
            self.followArrowBtn.hidden = NO;
            self.followLab.userInteractionEnabled = YES;
        }
    }
}

#pragma mark setup title label
- (UILabel *)setupTitlelabelWithFrame:(CGRect)frame TitleStr:(NSString *)titleStr {
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.font = [UIFont mediumFontWithSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    //必填*处理
    if ([titleStr containsString:@"*"]) {
        NSRange aRange = [titleStr rangeOfString:@"*"];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F34F1F"] range:aRange];
        lab.attributedText = attributedStr;
    } else {
        lab.text = titleStr;
    }
    return lab;
}

#pragma mark setup Label
- (UILabel *)setupLabelWithOriginY:(CGFloat)originY titleStr:(NSString *)titleStr tag:(NSInteger)tag{
    UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(105, originY,kScreen_Width-115, 30)];
    valueLab.font = [UIFont regularFontWithSize:16];
    valueLab.textColor = [UIColor colorWithHexString:@"#999999"];
    NSString *placeholder = titleStr;
    if ([titleStr containsString:@"*"]) {
        placeholder = [titleStr substringToIndex:titleStr.length-1];
    }
    valueLab.text = [NSString stringWithFormat:@"请选择%@",placeholder];
    valueLab.tag = tag;
    [valueLab addTapPressed:@selector(selectedInfoAction:) target:self];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width- 145, 5, 20, 20)];
    [btn setImage:[UIImage drawImageWithName:@"arrow_right" size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [valueLab addSubview:btn];
    return valueLab;
}

#pragma mark setup textfield
- (UITextField *)setupTextFieldWithOrignY:(CGFloat)originY placeholder:(NSString *)titleStr{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(105, originY, kScreen_Width-115, 30)];
    textField.font = [UIFont regularFontWithSize:16];
    textField.textColor = [UIColor colorWithHexString:@"#666666"];
    NSString *placeholder = nil;
    if ([titleStr containsString:@"*"]) {
       placeholder = [NSString stringWithFormat:@"请填写%@",[titleStr substringToIndex:titleStr.length-1]];
    } else {
       placeholder = [NSString stringWithFormat:@"请填写%@",titleStr];
    }
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, placeholder.length)];
    textField.attributedPlaceholder = attributeStr;
    return textField;
}

#pragma mark -- Getters
#pragma mark 根滚动
- (UIScrollView *)rootScrollView {
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBar_Height, kScreen_Width, kScreen_Height-kNavBar_Height)];
        _rootScrollView.showsVerticalScrollIndicator = NO;
    }
    return _rootScrollView;
}

#pragma mark 基本信息
- (UILabel *)basicLabel {
    if (!_basicLabel) {
        _basicLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 120, 30)];
        _basicLabel.text = @"基本信息";
        _basicLabel.font = [UIFont mediumFontWithSize:18];
        _basicLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _basicLabel;
}

#pragma mark 名称
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [self setupTextFieldWithOrignY:self.basicLabel.bottom+15 placeholder:basicTitlesArr[0]];
        _nameTextField.text = self.customerModel.customerId > 0 ? self.customerModel.businessName : @"";
    }
    return _nameTextField;
}

#pragma mark 简称
- (UITextField *)shortNameTextField {
    if (!_shortNameTextField) {
        _shortNameTextField = [self setupTextFieldWithOrignY:self.nameTextField.bottom+30 placeholder:basicTitlesArr[1]];
        _shortNameTextField.text = self.customerModel.customerId > 0 ? self.customerModel.nickName : @"";
    }
    return _shortNameTextField;
}

#pragma mark 联系人
- (UITextField *)contactTextField {
    if (!_contactTextField) {
        _contactTextField = [self setupTextFieldWithOrignY:self.shortNameTextField.bottom+30 placeholder:basicTitlesArr[2]];
        _contactTextField.text = self.customerModel.customerId > 0 ? self.customerModel.contactName : @"";
    }
    return _contactTextField;
}

#pragma mark 手机号
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [self setupTextFieldWithOrignY:self.contactTextField.bottom+30 placeholder:basicTitlesArr[3]];
        _phoneTextField.text = self.customerModel.customerId > 0 ? self.customerModel.telephone : @"";
    }
    return _phoneTextField;
}

#pragma mark 位置
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(105,self.phoneTextField.bottom+ 30,kScreen_Width-160, 50)];
        _addressLabel.font = [UIFont regularFontWithSize:14];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _addressLabel.numberOfLines = 0;
        _addressLabel.text = self.customerModel.customerId > 0 ? self.customerModel.address : @"";
    }
    return _addressLabel;
}

#pragma mark 位置刷新
- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.addressLabel.right+5,self.phoneTextField.bottom+40,30, 30)];
        [_refreshBtn setImage:ImageNamed(@"address_theme") forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(refreshCustomerAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}

#pragma mark 门头照标题
- (UILabel *)photoTitleLab {
    if (!_photoTitleLab) {
        _photoTitleLab = [self setupTitlelabelWithFrame:CGRectMake(20,self.addressLabel.bottom+15,90, 30) TitleStr:@"门头照(0/5)"];
        if (self.customerModel.customerId > 0 && !kIsEmptyString(self.customerModel.doorPhoto)) {
            NSArray *images = [self.customerModel.doorPhoto componentsSeparatedByString:@","];
            _photoTitleLab.text = [NSString stringWithFormat:@"门头照(%ld/5)",images.count];
        }
    }
    return _photoTitleLab;
}

#pragma mark 门头照描述
- (UILabel *)photoDescLab {
    if (!_photoDescLab) {
        _photoDescLab = [[UILabel alloc] initWithFrame:CGRectMake(115,self.addressLabel.bottom+15, 180, 30)];
        _photoDescLab.font = [UIFont regularFontWithSize:12];
        _photoDescLab.textColor = [UIColor colorWithHexString:@"#F34F1F"];
        _photoDescLab.text = @"*必须为现场拍照";
    }
    return _photoDescLab;
}

#pragma mark 门头照
- (FMPhotoCollectionView *)photoView {
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _photoView = [[FMPhotoCollectionView alloc] initWithFrame:CGRectMake(20, self.photoDescLab.bottom+15, kScreen_Width-40, 68) collectionViewLayout:layout];
        _photoView.maxImagesCount = 5;
        if (self.customerModel.customerId > 0 && !kIsEmptyString(self.customerModel.doorPhoto)) {
            NSArray *images = [self.customerModel.doorPhoto componentsSeparatedByString:@","];
            [_photoView addPickedImages:images];
        }
        kSelfWeak;
        _photoView.handleComplete = ^{
            NSArray *images = [weakSelf.photoView getAllImages];
            weakSelf.customerModel.doorPhoto = [images componentsJoinedByString:@","];
            weakSelf.photoTitleLab.text = [NSString stringWithFormat:@"门头照(%ld/5)",images.count];
        };
    }
    return _photoView;
}

#pragma mark 基本信息
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,self.photoView.bottom+40, 120, 30)];
        _detailLabel.text = @"详细信息";
        _detailLabel.font = [UIFont mediumFontWithSize:18];
        _detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _detailLabel;
}

#pragma mark 行业类型
- (UILabel *)industryLab {
    if (!_industryLab) {
        _industryLab = [self setupLabelWithOriginY:self.detailLabel.bottom+15 titleStr:detailTitlesArr[0] tag:100];
        if (self.customerModel.customerId > 0) {
            _industryLab.textColor = [UIColor colorWithHexString:@"#666666"];
            _industryLab.text = self.customerModel.industryName;
        }
    }
    return _industryLab;
}

#pragma mark 客户等级
- (UILabel *)levelLab {
    if (!_levelLab) {
        _levelLab = [self setupLabelWithOriginY:self.industryLab.bottom+30 titleStr:detailTitlesArr[1] tag:101];
        if (self.customerModel.customerId > 0) {
            _levelLab.textColor = [UIColor colorWithHexString:@"#666666"];
            _levelLab.text = self.customerModel.gradeName;
        }
    }
    return _levelLab;
}

#pragma mark 陈列面积
- (UITextField *)areaTextField {
    if (!_areaTextField) {
        _areaTextField = [self setupTextFieldWithOrignY:self.levelLab.bottom+30 placeholder:detailTitlesArr[2]];
        _areaTextField.text = self.customerModel.customerId > 0 ? self.customerModel.displayArea : @"";
    }
    return _areaTextField;
}

#pragma mark 跟进进度
- (UILabel *)followPressLab {
    if (!_followPressLab) {
        _followPressLab = [self setupLabelWithOriginY:self.areaTextField.bottom+30 titleStr:detailTitlesArr[3] tag:103];
        if (self.customerModel.customerId > 0) {
            _followPressLab.textColor = [UIColor colorWithHexString:@"#666666"];
            _followPressLab.text = self.customerModel.progressName;
        }
    }
    return _followPressLab;
}

#pragma mark 跟进人
- (UILabel *)followLab {
    if (!_followLab) {
        _followLab = [[UILabel alloc] initWithFrame:CGRectMake(105, self.followPressLab.bottom+30,kScreen_Width-115, 30)];
        _followLab.font = [UIFont regularFontWithSize:16];
        _followLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _followLab.text = @"请选择跟进人";
        _followLab.tag = 104;
        [_followLab addTapPressed:@selector(selectedInfoAction:) target:self];
    }
    return _followLab;
}

#pragma mark 跟进人选择
- (UIButton *)followArrowBtn {
    if (!_followArrowBtn) {
        _followArrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width- 35,self.followPressLab.bottom+35, 20, 20)];
        [_followArrowBtn setImage:[UIImage drawImageWithName:@"arrow_right" size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    }
    return _followArrowBtn;
}

#pragma mark 提交
- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton submitButtonWithFrame:CGRectMake(18,self.followLab.bottom+60, kScreen_Width-36, 46) title:@"保存" target:self selector:@selector(submitCustomerAction:)];
    }
    return _submitBtn;
}

- (FMPublicViewModel *)publicAdapter {
    if (!_publicAdapter) {
        _publicAdapter = [[FMPublicViewModel alloc] init];
    }
    return _publicAdapter;
}

- (FMCustomerViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMCustomerViewModel alloc] init];
    }
    return _adapter;
}

@end
