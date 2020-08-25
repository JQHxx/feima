//
//  FMEmployeeViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMEmployeeViewController.h"
#import "FMEditEmployeeViewController.h"
#import "FMEmployeeInfoViewController.h"
#import "FMRouteRecordsViewController.h"
#import "FMTransferViewController.h"
#import "FMEmployeeContentView.h"

@interface FMEmployeeViewController ()<FMEmployeeContentViewDelegate>

@property (nonatomic, strong) UISegmentedControl    *segmentedControl;
@property (nonatomic, strong) UIButton              *addBtn;
@property (nonatomic, strong) UIScrollView          *rootScrollView;
@property (nonatomic, strong) FMEmployeeContentView *employeeView;
@property (nonatomic, strong) FMEmployeeContentView *disableEmployeeView;

@end

@implementation FMEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark -- FMEmployeeContentViewDelegate
#pragma mark 更多
- (void)employeeContentView:(FMEmployeeContentView *)contentView didSlectedEmployee:(FMEmployeeModel *)employee index:(NSInteger)index {
    switch (index) {
        case 0:{ //轨迹路径
            FMRouteRecordsViewController *recordsVC = [[FMRouteRecordsViewController alloc] init];
            [self.navigationController pushViewController:recordsVC animated:YES];
        }
            break;
        case 1:{ //基本信息
            FMEmployeeInfoViewController *infoVC = [[FMEmployeeInfoViewController alloc] init];
            infoVC.employeeModel = employee;
            kSelfWeak;
            infoVC.updateBlock = ^(FMEmployeeModel *employee) {
                if (weakSelf.segmentedControl.selectedSegmentIndex == 0) {
                    [weakSelf.employeeView updateEmployeeInfoWithModel:employee];
                } else {
                    [weakSelf.disableEmployeeView updateEmployeeInfoWithModel:employee];
                }
            };
            [self.navigationController pushViewController:infoVC animated:YES];
        }
            break;
        case 2:{ //转移客户
            FMTransferViewController *transferVC = [[FMTransferViewController alloc] init];
            transferVC.employeeId = employee.employeeId;
            [self.navigationController pushViewController:transferVC animated:YES];
        }
        default: 
            break;
    }
}

#pragma mark -- Events
#pragma mark segment value change
- (void)chooseSegmentControlAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 1) {
        if (!self.disableEmployeeView) {
            self.disableEmployeeView = [[FMEmployeeContentView alloc] initWithFrame:CGRectMake(kScreen_Width, 0, kScreen_Width, kScreen_Height-kNavBar_Height) status:0];
            self.disableEmployeeView.viewDelegate = self;
        }
        [self.rootScrollView addSubview:self.disableEmployeeView];
        if ([FeimaManager sharedFeimaManager].employeeListReload) {
            [self.disableEmployeeView loadNewEmployeeData];
            [FeimaManager sharedFeimaManager].employeeListReload = NO;
        }
    } else {
        if ([FeimaManager sharedFeimaManager].employeeListReload) {
            [self.employeeView loadNewEmployeeData];
            [FeimaManager sharedFeimaManager].employeeListReload = NO;
        }
    }
    [self.rootScrollView setContentOffset:CGPointMake(kScreen_Width*sender.selectedSegmentIndex, 0)];
}

#pragma mark 添加员工
- (void)addEmployeeAction:(UIButton *)sender {
    FMEditEmployeeViewController *addEmployeeVC = [[FMEditEmployeeViewController alloc] init];
    kSelfWeak;
    addEmployeeVC.addSuccess = ^(FMEmployeeModel *employee) {
        [weakSelf.employeeView insertEmployeeWithModel:employee];
    };
    [self.navigationController pushViewController:addEmployeeVC animated:YES];
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBar_Height+2);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    if ([[FeimaManager sharedFeimaManager] hasPermissionWithApiStr:api_employee_list]) {
        [self.view addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view.mas_right).offset(-10);
            make.top.mas_equalTo(kStatusBar_Height+6);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
    
    [self.rootScrollView addSubview:self.employeeView];
    [self.employeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.height.mas_equalTo(self.rootScrollView.mas_height);
        make.width.mas_equalTo(kScreen_Width);
    }];
}

#pragma mark -- Getters
#pragma mark 菜单
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"启用",@"禁用"]];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor systemColor]} forState:UIControlStateSelected];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(chooseSegmentControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

#pragma mark 添加
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setImage:ImageNamed(@"add_white") forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addEmployeeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;;
}

#pragma mark
- (UIScrollView *)rootScrollView {
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] init];
        _rootScrollView.showsHorizontalScrollIndicator = NO;
        _rootScrollView.scrollEnabled = NO;
        [_rootScrollView setContentSize:CGSizeMake(kScreen_Width*2, kScreen_Height-kNavBar_Height)];
    }
    return _rootScrollView;
}

#pragma mark 启用
- (FMEmployeeContentView *)employeeView {
    if (!_employeeView) {
        _employeeView = [[FMEmployeeContentView alloc] initWithFrame:CGRectZero status:1];
        _employeeView.viewDelegate = self;
    }
    return _employeeView;
}


@end
