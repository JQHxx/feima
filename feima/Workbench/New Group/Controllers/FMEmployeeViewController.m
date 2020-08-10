//
//  FMEmployeeViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMEmployeeViewController.h"
#import "UISegmentedControl+Extend.h"
#import "FMEmployeeTableViewCell.h"
#import "FMEmployeeModel.h"

@interface FMEmployeeViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UISearchBar        *searchBar;
@property (nonatomic, strong) UITableView        *employeeTableView;
@property (nonatomic, strong) NSMutableArray     *employeeArray;

@end

@implementation FMEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadEmployeeData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.employeeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMEmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMEmployeeTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMEmployeeModel * model = self.employeeArray[indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

#pragma mark -- Private methods
#pragma mark Load Data
- (void)loadEmployeeData {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    NSArray *arr = @[@"王大锤",@"马画藤",@"张京东",@"以于涛",@"鹏佳骏",@"洛瑶灰",@"周姐坤",@"鹏佳骏",@"洛瑶灰",@"周姐坤"];
    for (NSInteger i=0; i<arr.count; i++) {
        FMEmployeeModel * model = [[FMEmployeeModel alloc] init];
        model.name = arr[i];
        model.organizationName = @"业务员";
        [tempArr addObject:model];
    }
    self.employeeArray = tempArr;
    [self.employeeTableView reloadData];
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBar_Height+2);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(kNavBar_Height);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 50));
    }];
    
    [self.view addSubview:self.employeeTableView];
    [self.employeeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-50);
    }];
}

#pragma mark -- Getters
#pragma mark 菜单
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"正常",@"禁用"]];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor systemColor]} forState:UIControlStateSelected];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

#pragma mark 搜索
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"输入姓名、手机号进行搜索";
    }
    return _searchBar;
}

#pragma mark 通讯录
- (UITableView *)employeeTableView {
    if (!_employeeTableView) {
        _employeeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _employeeTableView.delegate = self;
        _employeeTableView.dataSource = self;
        _employeeTableView.showsVerticalScrollIndicator = NO;
        _employeeTableView.tableFooterView = [[UIView alloc] init];
        [_employeeTableView registerClass:[FMEmployeeTableViewCell class] forCellReuseIdentifier:[FMEmployeeTableViewCell identifier]];
    }
    return _employeeTableView;
}

- (NSMutableArray *)employeeArray {
    if (!_employeeArray) {
        _employeeArray = [[NSMutableArray alloc] init];
    }
    return _employeeArray;
}

@end
