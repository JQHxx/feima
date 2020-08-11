//
//  FMAttendanceViewController.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAttendanceViewController.h"
#import "FMDailyViewController.h"
#import "FMMonthyViewController.h"
#import "FMDailyDetailsViewController.h"

@interface FMAttendanceViewController ()<FMDailyViewControllerDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) FMDailyViewController  *dailyVC;
@property (nonatomic, strong) FMMonthyViewController *monthVC;

@end

@implementation FMAttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
    [self setupUI];
}

#pragma mark --
- (void)selectedSegementAction:(UISegmentedControl *)control {
    if (control.selectedSegmentIndex == 1) {
        if (self.dailyVC) {
            [self.dailyVC.view removeFromSuperview];
            self.dailyVC = nil;
        }
        [self.view addSubview:self.monthVC.view];
    } else {
        if (self.monthVC) {
            [self.monthVC.view removeFromSuperview];
            self.monthVC = nil;
        }
        [self.view addSubview:self.dailyVC.view];
    }
}

#pragma mark -- Delegate
#pragma mark FMDailyViewControllerDelegate
#pragma mark 查看打卡详情
- (void)dailyViewControllerDidSelectedRowWithModel:(FMDailyReportModel *)model {
    FMDailyDetailsViewController *dailyDetailsVC = [[FMDailyDetailsViewController alloc] init];
    dailyDetailsVC.reportModel = model;
    [self.navigationController pushViewController:dailyDetailsVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBar_Height+2);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    [self.view addSubview:self.dailyVC.view];
}

#pragma mark -- Getters
#pragma mark 菜单
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"日报表",@"月报表"]];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor systemColor]} forState:UIControlStateSelected];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(selectedSegementAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (FMDailyViewController *)dailyVC {
    if (!_dailyVC) {
        _dailyVC = [[FMDailyViewController alloc] init];
        _dailyVC.view.frame = CGRectMake(0, kNavBar_Height, kScreen_Width, kScreen_Height-kNavBar_Height);
        _dailyVC.controlerDelegate = self;
    }
    return _dailyVC;
}

- (FMMonthyViewController *)monthVC {
    if (!_monthVC) {
        _monthVC = [[FMMonthyViewController alloc] init];
        _monthVC.view.frame = CGRectMake(0, kNavBar_Height, kScreen_Width, kScreen_Height-kNavBar_Height);
    }
    return _monthVC;
}

@end
