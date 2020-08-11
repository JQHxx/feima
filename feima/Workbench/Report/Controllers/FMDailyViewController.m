//
//  FMDailyViewController.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDailyViewController.h"
#import "FMDailyTableViewCell.h"
#import "FMDailyHeadView.h"
#import "SlideMenuView.h"


@interface FMDailyViewController ()<UITableViewDataSource,UITableViewDelegate,SlideMenuViewDelegate>

@property (nonatomic, strong) FMDailyHeadView    *headView;
@property (nonatomic, strong) UITableView        *myTableView;
@property (nonatomic, strong) NSMutableArray     *dailyData;

@end

@implementation FMDailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
    [self.view addSubview:self.myTableView];
    [self loadDailyData];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dailyData.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-18, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    [aView setCircleCorner:UIRectCornerTopLeft|UIRectCornerTopRight radius:4.0];
    
    SlideMenuView *menuView = [[SlideMenuView alloc] initWithFrame:CGRectMake(10, 5, 180, 40) btnTitleFont:[UIFont regularFontWithSize:14] color:[UIColor colorWithHexString:@"#666666"] selColor:[UIColor colorWithHexString:@"#333333"]];
    menuView.btnCapWidth = 10;
    menuView.lineWidth = 40.0;
    menuView.selectTitleFont = [UIFont mediumFontWithSize:16.0f];
    menuView.myTitleArray = [NSMutableArray arrayWithArray:@[@"全部",@"上班",@"下班"]];
    menuView.currentIndex = 0;
    menuView.delegate = self;
    [aView addSubview:menuView];
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMDailyTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    FMDailyReportModel *model = self.dailyData[indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDailyReportModel *model = self.dailyData[indexPath.row];
    if ([self.controlerDelegate respondsToSelector:@selector(dailyViewControllerDidSelectedRowWithModel:)]) {
        [self.controlerDelegate dailyViewControllerDidSelectedRowWithModel:model];
    }
}

#pragma mark SlideMenuViewDelegate
- (void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index {
    
}

#pragma mark -- Private methods
#pragma mark loadData
- (void)loadDailyData {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    NSArray *namesArr = @[@"黄稀薄",@"刘海涛",@"叶翠红",@"方伟",@"张利兴",@"张利兴",@"黄稀薄",@"刘海涛",@"叶翠红",@"方伟",@"张利兴",@"张利兴"];
    NSArray *types = @[@"上班打卡",@"下班打卡"];
    for (NSInteger i=0; i<namesArr.count; i++) {
        FMDailyReportModel *model = [[FMDailyReportModel alloc] init];
        model.employeeName = namesArr[i];
        model.punchTypeName = types[i%2];
        model.punchSecondTimeStr = @"2020.02.24  18:00";
        model.organizationName = @"市场销售部";
        model.address = @"长沙市岳麓区枫林三路268号";
        [tempArr addObject:model];
    }
    self.dailyData = tempArr;
    [self.myTableView reloadData];
    
    FMDailyFigureModel *figure = [[FMDailyFigureModel alloc] init];
    figure.punchNumber = 80;
    figure.shouldBeToNumber = 120;
    
    FMDailyStatusModel *statusModel = [[FMDailyStatusModel alloc] init];
    statusModel.notPunchNumber = 5;
    statusModel.punchNumber = 80;
    statusModel.abnormalNumber = 2;
    
    [self.headView fillDataWithFigure:figure statusModel:statusModel];
}

#pragma mark -- Getters
#pragma mark 头部
- (FMDailyHeadView *)headView {
    if (!_headView) {
        _headView = [[FMDailyHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-16, 310)];
    }
    return _headView;
}

#pragma mark 日报表
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 0, kScreen_Width-16, kScreen_Height-kNavBar_Height) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView = [[UIView alloc] init];
        [_myTableView registerClass:[FMDailyTableViewCell class] forCellReuseIdentifier:[FMDailyTableViewCell identifier]];
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.layer.cornerRadius = 4;
        _myTableView.clipsToBounds = YES;
        _myTableView.separatorInset = UIEdgeInsetsZero;
        _myTableView.tableHeaderView = self.headView;
    }
    return _myTableView;
}

- (NSMutableArray *)dailyData {
    if (!_dailyData) {
        _dailyData = [[NSMutableArray alloc] init];
    }
    return _dailyData;
}

@end
