//
//  FMAttendanceViewController.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAttendanceViewController.h"
#import "FMDailyDetailsViewController.h"
#import "FMDailyReportTableView.h"
#import "FMMonthyReportTableView.h"

@interface FMAttendanceViewController ()<FMDailyReportTableViewDelegate>

@property (nonatomic, strong) UISegmentedControl      *segmentedControl;
@property (nonatomic, strong) UIScrollView            *rootScrollView;
@property (nonatomic, strong) FMDailyReportTableView  *dailyTableView;
@property (nonatomic, strong) FMMonthyReportTableView *monthyTableView;

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
        if (!self.monthyTableView) {
            self.monthyTableView = [[FMMonthyReportTableView alloc] initWithFrame:CGRectMake(kScreen_Width+10, 0, kScreen_Width-20, kScreen_Height-kNavBar_Height)];
            [self.rootScrollView addSubview:self.monthyTableView];
        }
    }
    [self.rootScrollView setContentOffset:CGPointMake(kScreen_Width*control.selectedSegmentIndex, 0)];
}

#pragma mark -- Delegate
#pragma mark FMDailyReportTableViewDelegate
#pragma mark 查看打卡详情
- (void)dailyReportTableViewDidSelectedRowWithModel:(FMDailyReportModel *)dailyModel {
    FMDailyDetailsViewController *dailyDetailsVC = [[FMDailyDetailsViewController alloc] init];
    dailyDetailsVC.reportModel = dailyModel;
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
    
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
    
    [self.rootScrollView addSubview:self.dailyTableView];
    [self.dailyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(self.rootScrollView.mas_height);
        make.width.mas_equalTo(kScreen_Width-20);
    }];
    
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

#pragma mark 日报表
- (FMDailyReportTableView *)dailyTableView {
    if (!_dailyTableView) {
        _dailyTableView = [[FMDailyReportTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dailyTableView.viewDelegate = self;
    }
    return _dailyTableView;
}


@end
