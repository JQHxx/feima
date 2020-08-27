//
//  FMEditEmployeeViewController.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMEditEmployeeViewController.h"
#import "FMSelectCompanyViewController.h"
#import "FMPhotoCollectionView.h"
#import "BRStringPickerView.h"
#import "FMEmployeeViewModel.h"

@interface FMEditEmployeeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSArray *titlesArr;
    NSArray *placeholdersArr;
}

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) UIButton       *submitBtn;
@property (nonatomic, strong) UITextField    *nameTextField;  //姓名
@property (nonatomic, strong) FMPhotoCollectionView *photoView;
@property (nonatomic, strong) UILabel        *sexLabel;       //性别
@property (nonatomic, strong) UILabel        *companyLab;      //公司
@property (nonatomic, strong) UILabel        *departmentLab;  //部门
@property (nonatomic, strong) UILabel        *positionLab;    //职位
@property (nonatomic, strong) UITextField    *phoneTextField;  //手机号

@property (nonatomic,strong) FMEmployeeViewModel *adapter;
@property (nonatomic, copy ) NSArray *organizationsArr;
@property (nonatomic, copy ) NSArray *positionsArr;

@end

@implementation FMEditEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = self.employee ? @"修改信息" : @"添加员工";
    
    titlesArr = @[@"姓名",@"照片",@"性别",@"公司",@"部门",@"职位",@"手机号"];
    placeholdersArr = @[@"请输入姓名",@"请选择照片",@"请选择性别",@"请输入公司",@"请选择所属部门",@"请选择员工职位",@"请输入手机号"];
    if (!self.employee) {
        self.employee = [[FMEmployeeModel alloc] init];
        self.employee.employeeId = 0;
    }
    
    [self setupUI];
    [self preLoadSelectGroupData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titlesArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
    aView.backgroundColor = [UIColor whiteColor];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 120, 30)];
    lab.text = @"基本信息";
    lab.font = [UIFont mediumFontWithSize:18];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    [aView addSubview:lab];
    
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //标题
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 60, 30)];
    lab.font = [UIFont mediumFontWithSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    lab.text = titlesArr[indexPath.row];
    [cell.contentView addSubview:lab];
    
    NSString *placeholder = placeholdersArr[indexPath.row];
    if (indexPath.row == 1) {//照片
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:self.photoView];
    } else if ( indexPath.row == 0 || indexPath.row == 6) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UITextField *textField = [self setupTextFieldWithPlaceholder:placeholder];
        [cell.contentView addSubview:textField];
        if (indexPath.row == 0) {
            self.nameTextField = textField;
            self.nameTextField.text = kIsEmptyString(self.employee.name) ? @"" : self.employee.name;
        } else {
            self.phoneTextField = textField;
            self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.phoneTextField.text = kIsEmptyString(self.employee.telephone) ? @"" : self.employee.telephone;
        }
    } else {
        UILabel *lab = [self setupLabelWithTitleStr:placeholder tag:indexPath.row];
        [cell.contentView addSubview:lab];
        if (indexPath.row == 2) {
            self.sexLabel = lab;
            if (self.employee.sex > 0) {
                self.sexLabel.text = self.employee.sex == 1 ? @"男" : @"女";
                self.sexLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 3) {
            self.companyLab = lab;
            
            //超级管理员可以选择公司
            if ([FeimaManager sharedFeimaManager].isAdministrator) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        
            if (self.employee.companyId > 0) {
                self.companyLab.text = kIsEmptyString(self.employee.companyName) ? @"" : self.employee.companyName;
                self.companyLab.textColor = [UIColor colorWithHexString:@"#666666"];
            } else {
                if (![FeimaManager sharedFeimaManager].isAdministrator) {
                    self.employee.companyName = [FeimaManager sharedFeimaManager].userBean.users.companyName;
                    self.employee.companyId = [FeimaManager sharedFeimaManager].userBean.users.companyId;
                    self.companyLab.text = self.employee.companyName;
                    self.companyLab.textColor = [UIColor colorWithHexString:@"#666666"];
                }
            }
            
        } else {
            if (self.employee.employeeId > 0) {
                NSInteger postId = [FeimaManager sharedFeimaManager].userBean.users.postId;
                if (postId == 4 || postId == 5) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            if (indexPath.row == 4) {
                self.departmentLab = lab;
                if (self.employee.organizationId > 0 && !kIsEmptyString(self.employee.organizationName)) {
                    self.departmentLab.text = self.employee.organizationName;
                    self.departmentLab.textColor = [UIColor colorWithHexString:@"#666666"];
                }
            } else {
                self.positionLab = lab;
                if (self.employee.postId > 0) {
                    self.positionLab.text = self.employee.postName;
                    self.positionLab.textColor = [UIColor colorWithHexString:@"#666666"];
                }
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 100;
    } else {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (1 == range.length) {//按下回格键
        return YES;
    }
    if (self.phoneTextField == textField) {
        if ([textField.text length] < 11) { //手机号
            return YES;
        }
    }
    if (self.nameTextField == textField) {
        if ([textField.text length] < 10) { //姓名
            return YES;
        }
    }
    return NO;
}

#pragma mark 结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.nameTextField) {
        self.employee.name = textField.text;
    } else {
        self.employee.telephone = textField.text;
    }
    [self.myTableView reloadData];
}

#pragma mark -- Events response
#pragma mark 保存
- (void)saveEmployeeAction:(UIButton *)sender {
    if (kIsEmptyString(self.employee.name)) {
        [self.view makeToast:@"姓名不能为空" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    NSArray *images = [self.photoView getAllImages];
    if (images.count == 0) {
        [self.view makeToast:@"照片不能为空" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (self.employee.sex == 0) {
        [self.view makeToast:@"性别不能为空" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (kIsEmptyString(self.employee.companyName)) {
        [self.view makeToast:@"公司不能为空" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (kIsEmptyString(self.employee.organizationName)) {
        [self.view makeToast:@"部门不能为空" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (kIsEmptyString(self.employee.postName)) {
        [self.view makeToast:@"职位不能为空" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if (kIsEmptyString(self.employee.telephone)) {
        [self.view makeToast:@"手机号不能为空" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    NSInteger type = self.employee.employeeId > 0 ? 1 : 0;
    self.employee.logo = [images firstObject];
    kSelfWeak;
    [self.adapter addOrUpdateEmployeeWithType:type employeeId:self.employee.employeeId logo:self.employee.logo name:self.employee.name sex:self.employee.sex organizationId:self.employee.organizationId postId:self.employee.postId telephone:self.employee.telephone companyId:self.employee.companyId complete:^(BOOL isSuccess) {
        if (isSuccess) {
            if (weakSelf.employee.employeeId > 0) {
                if (weakSelf.updateSuccess) {
                    weakSelf.updateSuccess(weakSelf.employee);
                }
            } else {
                weakSelf.employee.employeeId = weakSelf.adapter.employeeId;
                if (weakSelf.addSuccess) {
                    weakSelf.addSuccess(weakSelf.employee);
                }
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.view makeToast:weakSelf.adapter.errorString duration:2.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark 选择
- (void)selectedEmployeeInfoAction:(UIGestureRecognizer *)sender {
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    NSInteger tag = sender.view.tag;
    MyLog(@"tag:%ld",tag);
    if (tag == 2) { //性别
        NSString *defaultSex = nil;
        if (self.employee.sex > 0) {
            defaultSex = self.employee.sex == 1 ? @"男" : @"女";
        }
        kSelfWeak;
        [BRStringPickerView showStringPickerWithTitle:@"性别" dataSource:@[@"男",@"女"] defaultSelValue:defaultSex isAutoSelect:NO resultBlock:^(id selectValue) {
            weakSelf.sexLabel.text = selectValue;
            weakSelf.sexLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            weakSelf.employee.sex = [selectValue isEqualToString:@"男"] ? 1 : 2;
        }];
    } else if (tag == 3) {
        if ([FeimaManager sharedFeimaManager].isAdministrator) {
            FMSelectCompanyViewController *selectCompanyVC = [[FMSelectCompanyViewController alloc] init];
            selectCompanyVC.selCompanyId = self.employee.companyId;
            kSelfWeak;
            selectCompanyVC.selectedBlock = ^(FMCompanyModel *company) {
                weakSelf.employee.companyId = company.companyId;
                weakSelf.employee.companyName = company.name;
                weakSelf.companyLab.text = company.name;
                weakSelf.companyLab.textColor = [UIColor colorWithHexString:@"#666666"];
            };
            [self.navigationController pushViewController:selectCompanyVC animated:YES];
        }
    } else {
        BOOL canHandle = NO;
        if (self.employee.employeeId > 0) {
            NSInteger postId = [FeimaManager sharedFeimaManager].userBean.users.postId;
            if (postId == 4 || postId == 5) {
                canHandle = NO;
            } else {
                canHandle = YES;
            }
        } else {
            canHandle = YES;
        }
        if (canHandle) {
            if (tag == 4) { //选择部门
                [self selectDepartmentAction];
            } else { //选择职位
                [self selectPositionAction];
            }
        }
    }
}

#pragma mark -- Private methods
#pragma mark 预加载下拉框数据
- (void)preLoadSelectGroupData {
    //加载组织机构下拉框
    [self.adapter loadOrganizationDataComplete:^(BOOL isSuccess) {

    }];
    //加载职位下拉框
    [self.adapter loadPositionDataComplete:^(BOOL isSuccess) {
        
    }];
}

#pragma mark 选择部门
- (void)selectDepartmentAction {
    NSArray *data = self.adapter.organizationArray;
    if (data.count > 0) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (FMOrganizationModel *model in data) {
            [tempArr addObject:model.name];
        }
        NSString *defaultValue = kIsEmptyString(self.employee.organizationName) ? tempArr[0] : self.employee.organizationName;
        [BRStringPickerView showStringPickerWithTitle:@"选择部门" dataSource:tempArr defaultSelValue:defaultValue isAutoSelect:NO resultBlock:^(id selectValue) {
            self.departmentLab.text = selectValue;
            for (FMOrganizationModel *aModel in data) {
                if ([aModel.name isEqualToString:selectValue]) {
                    self.employee.organizationName = aModel.name;
                    self.employee.organizationId = aModel.organizationId;
                    break;
                }
            }
            [self.myTableView reloadData];
        }];
    }
}

#pragma mark 选择职位
- (void)selectPositionAction {
    NSArray *data = self.adapter.posisionArray;
    if (data.count > 0) {
        NSInteger myPostId = [FeimaManager sharedFeimaManager].userBean.users.postId;
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (FMPositionModel *model in data) {
            if (model.postId > myPostId) {
                [tempArr addObject:model.name];
            }
        }
        NSString *defaultValue = kIsEmptyString(self.employee.postName) ? tempArr[0] : self.employee.postName;
        [BRStringPickerView showStringPickerWithTitle:@"选择职位" dataSource:tempArr defaultSelValue:defaultValue isAutoSelect:NO resultBlock:^(id selectValue) {
            self.positionLab.text = selectValue;
            for (FMPositionModel *aModel in data) {
                if ([aModel.name isEqualToString:selectValue]) {
                    self.employee.postName = aModel.name;
                    self.employee.postId = aModel.postId;
                    break;
                }
            }
            [self.myTableView reloadData];
        }];
    }
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(520);
    }];
    
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(self.myTableView.mas_bottom).offset(30);
        make.height.mas_equalTo(46);
    }];
}

#pragma mark setup Label
- (UILabel *)setupLabelWithTitleStr:(NSString *)titleStr tag:(NSInteger)tag{
    UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(85, 15,kScreen_Width-95, 30)];
    valueLab.font = [UIFont regularFontWithSize:16];
    valueLab.textColor = [UIColor colorWithHexString:@"#999999"];
    valueLab.text = titleStr;
    valueLab.tag = tag;
    [valueLab addTapPressed:@selector(selectedEmployeeInfoAction:) target:self];
    return valueLab;
}

#pragma mark setup textfield
- (UITextField *)setupTextFieldWithPlaceholder:(NSString *)titleStr {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(85, 15, kScreen_Width-95, 30)];
    textField.font = [UIFont regularFontWithSize:16];
    textField.textColor = [UIColor colorWithHexString:@"#666666"];
    textField.delegate = self;
    NSString *placeholder = titleStr;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, placeholder.length)];
    textField.attributedPlaceholder = attributeStr;
    return textField;
}

#pragma mark -- Getters
#pragma mark tableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.tableFooterView = [[UIView alloc] init];
    }
    return _myTableView;
}

#pragma mark 提交
- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton submitButtonWithFrame:CGRectZero title:@"保存" target:self selector:@selector(saveEmployeeAction:)];
    }
    return _submitBtn;
}

#pragma mark 添加照片
- (FMPhotoCollectionView *)photoView {
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _photoView = [[FMPhotoCollectionView alloc] initWithFrame:CGRectMake(85, 15, 70, 70) collectionViewLayout:layout];
        _photoView.maxImagesCount = 1;
        if (self.employee.employeeId > 0) {
            [_photoView addPickedImages:@[self.employee.logo]];
        }
    }
    return _photoView;
}

- (FMEmployeeViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMEmployeeViewModel alloc] init];
    }
    return _adapter;
}

@end
