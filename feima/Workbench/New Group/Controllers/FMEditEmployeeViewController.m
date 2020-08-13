//
//  FMEditEmployeeViewController.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMEditEmployeeViewController.h"

@interface FMEditEmployeeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titlesArr;
    NSArray *placeholdersArr;
}

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) UIView         *bottomView;
@property (nonatomic, strong) UITextField    *nameTextField;  //姓名
@property (nonatomic, strong) UILabel        *sexLabel;       //性别
@property (nonatomic, strong) UITextField    *companyTextField;  //公司
@property (nonatomic, strong) UILabel        *departmentLab;  //部门
@property (nonatomic, strong) UILabel        *positionLab;    //职位
@property (nonatomic, strong) UITextField    *phoneTextField;  //手机号

@end

@implementation FMEditEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = self.employee ? @"修改信息" : @"添加员工";
    
    titlesArr = @[@"姓名",@"照片",@"性别",@"公司",@"部门",@"职位",@"手机号"];
    placeholdersArr = @[@"请输入姓名",@"请选择照片",@"请选择性别",@"请输入公司",@"请选择所属部门",@"请选择员工职位",@"请输入手机号"];
    [self setupUI];
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
    } else {
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //标题
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 60, 30)];
    lab.font = [UIFont mediumFontWithSize:14];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    lab.text = titlesArr[indexPath.row];
    [cell.contentView addSubview:lab];
    
    NSString *placeholder = placeholdersArr[indexPath.row];
    if (indexPath.row == 1) {//照片
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    } else if ( indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 6) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UITextField *textField = [self setupTextFieldWithPlaceholder:placeholder];
        [cell.contentView addSubview:textField];
        if (indexPath.row == 0) {
            self.nameTextField = textField;
        } else if (indexPath.row == 3) {
            self.companyTextField = textField;
        } else {
            self.phoneTextField = textField;
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *lab = [self setupLabelWithTitleStr:placeholder tag:indexPath.row];
        [cell.contentView addSubview:lab];
        if (indexPath.row == 2) {
            self.sexLabel = lab;
        } else if (indexPath.row == 4) {
            self.departmentLab = lab;
        } else {
            self.positionLab = lab;
        }
    }
    if (self.employee) {
        self.nameTextField.text = self.employee.name;
        self.companyTextField.text = self.employee.companyName;
        self.phoneTextField.text = self.employee.telephone;
        
        self.sexLabel.text = @"男";
        self.sexLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        self.departmentLab.text = self.employee.organizationName;
        self.departmentLab.textColor = [UIColor colorWithHexString:@"#666666"];
        self.positionLab.text = self.employee.postName;
        self.positionLab.textColor = [UIColor colorWithHexString:@"#666666"];
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

#pragma mark -- Events response
#pragma mark 保存
- (void)saveEmployeeAction:(UIButton *)sender {
    
}

#pragma mark 选择
- (void)selectedEmployeeInfoAction:(UIGestureRecognizer *)sender {
    NSInteger tag = sender.view.tag;
    MyLog(@"tag:%ld",tag);
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
}

#pragma mark setup Label
- (UILabel *)setupLabelWithTitleStr:(NSString *)titleStr tag:(NSInteger)tag{
    UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(85, 15,kScreen_Width-95, 30)];
    valueLab.font = [UIFont regularFontWithSize:14];
    valueLab.textColor = [UIColor colorWithHexString:@"#999999"];
    valueLab.text = titleStr;
    valueLab.tag = tag;
    [valueLab addTapPressed:@selector(selectedEmployeeInfoAction:) target:self];
    return valueLab;
}

#pragma mark setup textfield
- (UITextField *)setupTextFieldWithPlaceholder:(NSString *)titleStr {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(85, 15, kScreen_Width-95, 30)];
    textField.font = [UIFont regularFontWithSize:14];
    textField.textColor = [UIColor colorWithHexString:@"#666666"];
    NSString *placeholder = [NSString stringWithFormat:@"请输入%@",titleStr];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, placeholder.length)];
    textField.attributedPlaceholder = attributeStr;
    return textField;
}

#pragma mark -- Getters
#pragma mark 提交
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 120)];
        UIButton *submitBtn = [UIButton submitButtonWithFrame:CGRectMake(18, 50, kScreen_Width-36, 46) title:@"保存" target:self selector:@selector(saveEmployeeAction:)];
        [_bottomView addSubview:submitBtn];
    }
    return _bottomView;
}

#pragma mark tableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.tableFooterView = self.bottomView;
    }
    return _myTableView;
}


@end
