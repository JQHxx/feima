//
//  FMEmployeeListViewController.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMEmployeeListViewController.h"
#import "FMRouteRecordsViewController.h"
#import "SlideMenuView.h"
#import "FMListTableViewCell.h"
#import "FMEmployeeModel.h"

@interface FMEmployeeListViewController ()<UITableViewDelegate,UITableViewDataSource,SlideMenuViewDelegate>

@property (nonatomic,strong) SlideMenuView *menuView;
@property (nonatomic,strong) UITableView   *listTableView;

@property (nonatomic,strong) NSMutableArray *employeeArray;

@end

@implementation FMEmployeeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"员工列表";
    
    [self setupUI];
    [self loadEmployeeListData];
}


#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.employeeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMListTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMEmployeeModel * model = self.employeeArray[indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMEmployeeModel * model = self.employeeArray[indexPath.row];
    FMRouteRecordsViewController *recordsVC = [[FMRouteRecordsViewController alloc] init];
    [self.navigationController pushViewController:recordsVC animated:YES];
}

#pragma mark -- Delegate
#pragma mark SlideMenuViewDelegate
- (void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index {
    
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.listTableView];
}

#pragma mark load data
- (void)loadEmployeeListData {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    NSArray *arr = @[@"王大锤",@"马画藤",@"张京东",@"以于涛",@"鹏佳骏",@"洛瑶灰",@"周姐坤",@"鹏佳骏",@"洛瑶灰",@"周姐坤"];
    for (NSInteger i=0; i<arr.count; i++) {
        FMEmployeeModel * model = [[FMEmployeeModel alloc] init];
        model.name = arr[i];
        model.organizationName = @"飞马测试";
        model.telephone = @"13548761594";
        model.companyName = @"飞马总部";
        model.postName = @"业务员";
        model.address = @"湖南省长沙市岳麓区文轩路185号靠近成城工业园";
        model.updateTime = 1596988800;
        [tempArr addObject:model];
    }
    self.employeeArray = tempArr;
    [self.listTableView reloadData];
}

#pragma mark -- Getters
#pragma mark 菜单
- (SlideMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[SlideMenuView alloc] initWithFrame:CGRectMake(0, kNavBar_Height,kScreen_Width, 50) btnTitleFont:[UIFont regularFontWithSize:16.0f] color:[UIColor colorWithHexString:@"#666666"] selColor:[UIColor systemColor]];
        _menuView.btnCapWidth = 10;
        _menuView.lineWidth = 40.0;
        _menuView.selectTitleFont = [UIFont mediumFontWithSize:20.0f];
        _menuView.myTitleArray = [NSMutableArray arrayWithArray:@[@"全部",@"当前在线",@"当天在线",@"离线"]];
        _menuView.currentIndex = 0;
        _menuView.delegate = self;
    }
    return _menuView;
}

#pragma mark
- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.menuView.bottom, kScreen_Width, kScreen_Height-self.menuView.bottom) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.backgroundColor = [UIColor whiteColor];
        _listTableView.separatorInset = UIEdgeInsetsZero;
        [_listTableView registerClass:[FMListTableViewCell class] forCellReuseIdentifier:[FMListTableViewCell identifier]];
    }
    return _listTableView;
}

@end
