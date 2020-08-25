//
//  FMEmployeeInfoViewController.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMEmployeeInfoViewController.h"
#import "FMEditEmployeeViewController.h"

@interface FMEmployeeInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titlesArr;
}

@property (nonatomic, strong) UIButton       *editBtn;
@property (nonatomic, strong) UITableView    *myTableView;

@end

@implementation FMEmployeeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"员工信息";
    titlesArr = @[@"姓名",@"照片",@"性别",@"公司",@"部门",@"职位",@"手机号"];
    
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
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //标题
    NSString *titleStr = titlesArr[indexPath.row];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 30)];
    lab.font = [UIFont mediumFontWithSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    lab.text = titleStr;
    [cell.contentView addSubview:lab];
    
    if (indexPath.row==1) { //照片
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 10, 80, 80)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.employeeModel.logo] placeholderImage:[UIImage ctPlaceholderImage]];
        [cell.contentView addSubview:imgView];
    } else {
        UILabel *valueLab = [self fillDataForRow:indexPath.row];
        [cell.contentView addSubview:valueLab];
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

#pragma mark -- event response
#pragma mark 编辑
- (void)editEmployeeAction:(UIButton *)sender {
    FMEditEmployeeViewController *editVC = [[FMEditEmployeeViewController alloc] init];
    editVC.employee = self.employeeModel;
    kSelfWeak;
    editVC.updateSuccess = ^(FMEmployeeModel *employee) {
        weakSelf.employeeModel = employee;
        [weakSelf.myTableView reloadData];
        if (weakSelf.updateBlock) {
            weakSelf.updateBlock(employee);
        }
    };
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(kStatusBar_Height+6);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
}

#pragma mark 填充数据
- (UILabel *)fillDataForRow:(NSInteger)row {
    UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 10,kScreen_Width-115, 40)];
    valueLab.font = [UIFont regularFontWithSize:16];
    valueLab.textColor = [UIColor colorWithHexString:@"#666666"];
    switch (row) {
        case 0:
            valueLab.text = self.employeeModel.name;
            break;
        case 2: {
            if (self.employeeModel.sex > 0) {
                valueLab.text = self.employeeModel.sex == 1 ? @"男" : @"女";
            } else {
                valueLab.text = @"未知";
            }
        }
            break;
        case 3:
            valueLab.text = self.employeeModel.companyName;
            break;
        case 4:
            valueLab.text = self.employeeModel.organizationName;
            break;
        case 5:
            valueLab.text = self.employeeModel.postName;
            break;
        case 6:
            valueLab.text = self.employeeModel.telephone;
            break;
        default:
            break;
    }
    
    return valueLab;
}

#pragma mark -- Getters
#pragma mark 编辑
- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setImage:ImageNamed(@"edit") forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editEmployeeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;;
}

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


@end
