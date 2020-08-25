//
//  FMTransferViewController.m
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMTransferViewController.h"
#import "FMSelectEmployeeViewController.h"
#import "FMCustomerViewModel.h"

@interface FMTransferViewController ()

@property (nonatomic,strong) UIButton        *transferBtn;
@property (nonatomic,strong) UILabel         *cateTitleLabel;
@property (nonatomic,strong) UILabel         *cateLabel;   
@property (nonatomic,strong) UIButton        *arrowBtn;
@property (nonatomic,strong) UIView          *line;

@property (nonatomic,strong) FMEmployeeModel *selEmployee;
@property (nonatomic,strong) FMCustomerViewModel *adapter;

@end

@implementation FMTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"客户转移";
    
    [self setupUI];
}

#pragma mark -- Event response
#pragma mark 选择员工
- (void)chooseEmployeeAction {
    FMSelectEmployeeViewController *selectEmployeeVC = [[FMSelectEmployeeViewController alloc] init];
    selectEmployeeVC.selEmployeeId = self.selEmployee.employeeId;
    kSelfWeak;
    selectEmployeeVC.selectedComplete = ^(FMEmployeeModel *employee) {
        weakSelf.selEmployee = employee;
        weakSelf.cateLabel.text = employee.name;
    };
    [self.navigationController pushViewController:selectEmployeeVC animated:YES];
}

#pragma mark 确认转移
- (void)confirmTransferAction:(UIButton *)sender {
    kSelfWeak;
    [self.adapter transferCustomerWithfromId:self.employeeId toId:self.selEmployee.employeeId complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [kKeyWindow makeToast:@"客户转移成功" duration:1.5 position:CSToastPositionCenter];
        } else {
            [weakSelf.view makeToast:weakSelf.adapter.errorString duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.transferBtn];
    [self.transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(kStatusBar_Height+10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [self.view addSubview:self.cateTitleLabel];
     [self.cateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(18);
         make.top.mas_equalTo(kNavBar_Height+20);
         make.size.mas_equalTo(CGSizeMake(110, 24));
     }];
    
     [self.view addSubview:self.cateLabel];
     [self.cateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.cateTitleLabel.mas_right).offset(10);
         make.top.mas_equalTo(self.cateTitleLabel.mas_top);
         make.right.mas_equalTo(-40);
         make.height.mas_equalTo(24);
     }];
     
     [self.view addSubview:self.arrowBtn];
     [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.cateLabel.mas_centerY);
         make.right.mas_equalTo(-18);
         make.size.mas_equalTo(CGSizeMake(20, 20));
     }];
     
     [self.view addSubview:self.line];
     [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.cateTitleLabel.mas_left);
         make.top.mas_equalTo(self.cateLabel.mas_bottom).offset(16);
         make.right.mas_equalTo(-18);
         make.height.mas_equalTo(1);
     }];
}

#pragma mark -- Getters
#pragma mark 转移
- (UIButton *)transferBtn {
    if (!_transferBtn) {
        _transferBtn = [[UIButton alloc] init];
        [_transferBtn setTitle:@"确认转移" forState:UIControlStateNormal];
        [_transferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _transferBtn.titleLabel.font = [UIFont mediumFontWithSize:14];
        [_transferBtn addTarget:self action:@selector(confirmTransferAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferBtn;;
}

#pragma mark 标题
- (UILabel *)cateTitleLabel {
    if (!_cateTitleLabel) {
        _cateTitleLabel = [[UILabel alloc] init];
        _cateTitleLabel.font = [UIFont regularFontWithSize:16];
        _cateTitleLabel.textColor = [UIColor textBlackColor];
        _cateTitleLabel.text = @"将客户转移到";
    }
    return _cateTitleLabel;
}

#pragma mark 品类
- (UILabel *)cateLabel {
    if (!_cateLabel) {
        _cateLabel = [[UILabel alloc] init];
        _cateLabel.font = [UIFont regularFontWithSize:16];
        _cateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _cateLabel.text = @"选择员工";
        [_cateLabel addTapPressed:@selector(chooseEmployeeAction) target:self];
    }
    return _cateLabel;
}

- (UIButton *)arrowBtn {
    if (!_arrowBtn) {
        _arrowBtn = [[UIButton alloc] init];
        [_arrowBtn setImage:ImageNamed(@"arrow_right") forState:UIControlStateNormal];
    }
    return _arrowBtn;
}

#pragma mark 线条
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lineColor];
    }
    return _line;
}

- (FMCustomerViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMCustomerViewModel alloc] init];
    }
    return _adapter;
}

@end
