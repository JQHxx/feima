//
//  FMInvoicingViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInvoicingViewController.h"
#import "FMDistributionViewController.h"
#import "FMInvoicingTableViewCell.h"
#import "SlideMenuView.h"
#import "FMOrderModel.h"

@interface FMInvoicingViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,SlideMenuViewDelegate>

@property (nonatomic, strong) UISearchBar        *searchBar;
@property (nonatomic, strong) SlideMenuView      *menuView;
@property (nonatomic, strong) UITableView        *myTableView;
@property (nonatomic, strong) NSMutableArray     *ordersArray;

@end

@implementation FMInvoicingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"货物进销存";
    
    [self setupUI];
    [self loadInvoicingData];
}


#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ordersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMInvoicingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMInvoicingTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMOrderModel *model = self.ordersArray[indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDistributionViewController *distributionVC = [[FMDistributionViewController alloc] init];
    [self.navigationController pushViewController:distributionVC animated:YES];
}

#pragma mark SlideMenuViewDelegate
- (void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index {
    
}

#pragma mark -- Private emthods
#pragma mark load data
- (void)loadInvoicingData {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<15; i++) {
        FMOrderModel *model = [[FMOrderModel alloc] init];
        model.toEmployeeName = @"钟雄";
        FMEmployeeModel *eModel = [[FMEmployeeModel alloc] init];
        eModel.name = @"张卫良";
        model.employee = eModel;
        [tempArr addObject:model];
    }
    self.ordersArray = tempArr;
    [self.myTableView reloadData];
}


#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.myTableView];
}

#pragma mark -- Getters
#pragma mark 搜索
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, kNavBar_Height, kScreen_Width-30, 50)];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"请输入名称、品类";
    }
    return _searchBar;
}

#pragma mark 菜单
- (SlideMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[SlideMenuView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom,150, 50) btnTitleFont:[UIFont regularFontWithSize:16.0f] color:[UIColor colorWithHexString:@"#666666"] selColor:[UIColor systemColor]];
        _menuView.btnCapWidth = 10;
        _menuView.lineWidth = 40.0;
        _menuView.selectTitleFont = [UIFont mediumFontWithSize:20.0f];
        _menuView.myTitleArray = [NSMutableArray arrayWithArray:@[@"配货",@"退换货"]];
        _menuView.currentIndex = 0;
        _menuView.delegate = self;
    }
    return _menuView;
}

#pragma mark 
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.menuView.bottom, kScreen_Width, kScreen_Height-self.menuView.bottom) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_myTableView registerClass:[FMInvoicingTableViewCell class] forCellReuseIdentifier:[FMInvoicingTableViewCell identifier]];
    }
    return _myTableView;
}

- (NSMutableArray *)ordersArray {
    if (!_ordersArray) {
        _ordersArray = [[NSMutableArray alloc] init];
    }
    return _ordersArray;
}


@end
