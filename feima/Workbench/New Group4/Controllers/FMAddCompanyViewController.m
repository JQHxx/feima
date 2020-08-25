//
//  FMAddCompanyViewController.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAddCompanyViewController.h"
#import "FMCompanyViewModel.h"

@interface FMAddCompanyViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray  *titlesArr;
}

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) UITextField    *nameTextField;
@property (nonatomic, strong) UITextField    *phoneTextField;
@property (nonatomic, strong) UITextField    *addessTextField;
@property (nonatomic, strong) UIButton       *submitBtn;
@property (nonatomic, strong) FMCompanyViewModel *adapter;

@end

@implementation FMAddCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = self.company ? @"修改公司":@"添加公司";
    
    titlesArr = @[@"公司名称",@"公司电话",@"公司地址"];
    if (!self.company) {
        self.company = [[FMCompanyModel alloc] init];
    }
    [self setupUI];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 30)];
    lab.text = titlesArr[indexPath.row];
    lab.font = [UIFont mediumFontWithSize:16];
    [cell.contentView addSubview:lab];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 15, kScreen_Width-120, 30)];
    textField.font = [UIFont regularFontWithSize:16];
    textField.placeholder = [NSString stringWithFormat:@"请输入%@",titlesArr[indexPath.row]];
    [cell.contentView addSubview:textField];
    
    if (indexPath.row == 0) {
        textField.text = kIsEmptyString(self.company.name) ? @"" : self.company.name;
        self.nameTextField = textField;
    } else if (indexPath.row == 1) {
        textField.text = kIsEmptyString(self.company.phone) ? @"": self.company.phone;
        self.phoneTextField = textField;
    } else {
        textField.text = kIsEmptyString(self.company.address) ? @"" : self.company.address;
        self.addessTextField = textField;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark -- Events
#pragma mark 提交
- (void)submitCompanyAction:(UIButton *)sender {
    NSInteger type = self.company.companyId > 0 ? 1:0;
    kSelfWeak;
    [self.adapter addOrUpdateCompanyWithType:type companyId:self.company.companyId name:self.nameTextField.text phone:self.phoneTextField.text address:self.addessTextField.text complete:^(BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.company.name = weakSelf.nameTextField.text;
            weakSelf.company.phone = weakSelf.phoneTextField.text;
            weakSelf.company.address = weakSelf.addessTextField.text;
            if (weakSelf.company.companyId > 0) {
                if (weakSelf.updateSuccess) {
                    weakSelf.updateSuccess(weakSelf.company);
                }
            } else {
                weakSelf.company.companyId = weakSelf.adapter.companyId;
                if (weakSelf.addSuccess) {
                    weakSelf.addSuccess(weakSelf.company);
                }
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.view makeToast:weakSelf.adapter.errorString duration:2.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height+15);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(180);
    }];
    
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myTableView.mas_bottom).offset(30);
        make.left.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-36, 46));
    }];
}

#pragma mark -- Getters
#pragma mark tableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.scrollEnabled = NO;
    }
    return _myTableView;
}

#pragma mark 提交
- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton submitButtonWithFrame:CGRectZero title:@"提交" target:self selector:@selector(submitCompanyAction:)];
    }
    return _submitBtn;
}

- (FMCompanyViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMCompanyViewModel alloc] init];
    }
    return _adapter;
}

@end
