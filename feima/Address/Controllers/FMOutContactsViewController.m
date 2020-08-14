//
//  FMOutContactsViewController.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMOutContactsViewController.h"
#import "FMSubEmployeeTableViewCell.h"
#import "FMContactViewModel.h"

@interface FMOutContactsViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UISearchBar        *searchBar;
@property (nonatomic, strong) UITableView        *contactsTableView;
@property (nonatomic, strong) FMContactViewModel *adapter;
@property (nonatomic, strong) FMPageModel        *customerPage;
@property (nonatomic,  copy ) NSString           *nameStr;

@end

@implementation FMOutContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"客户列表";
    
    [self setupUI];
    [self loadCustomersData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfCustomersList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMSubEmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMSubEmployeeTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMCustomerModel *model = [self.adapter getCustomerModelWithIndex:indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

#pragma mark -- Delegate
#pragma mark  UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.nameStr = searchText;
    self.customerPage.pageNum = 1;
    [self loadCustomersData];
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadCustomersData {
    [SVProgressHUD show];
    [self.adapter loadCustomerContactsDataWithPage:self.customerPage contactName:self.nameStr action:@"" complete:^(BOOL isSuccess) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            [self.contactsTableView.mj_footer endRefreshing];
            [self.contactsTableView reloadData];
            [self createLoadMoreView];
        } else {
            [self.view makeToast:self.adapter.errorString duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark 加载更多
- (void)loadMoreCustomersData {
    self.customerPage.pageNum ++ ;
    [self loadCustomersData];
}

#pragma mark 更多底部视图
- (void)createLoadMoreView {
    if ([self.adapter hasMoreCustomerData]) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCustomersData)];
        footer.automaticallyRefresh = NO;
        self.contactsTableView.mj_footer = footer;
    } else {
        self.contactsTableView.mj_footer = nil;
    }
}

#pragma mark 界面初始化
- (void)setupUI {
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(kNavBar_Height);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 60));
    }];
    
    [self.view addSubview:self.contactsTableView];
    [self.contactsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-60);
    }];
}

#pragma mark -- Getters
#pragma mark 搜索
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜索联系人，一键通话";
    }
    return _searchBar;
}

#pragma mark 通讯录
- (UITableView *)contactsTableView {
    if (!_contactsTableView) {
        _contactsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contactsTableView.delegate = self;
        _contactsTableView.dataSource = self;
        _contactsTableView.showsVerticalScrollIndicator = NO;
        _contactsTableView.tableFooterView = [[UIView alloc] init];
        _contactsTableView.backgroundColor = [UIColor whiteColor];
        _contactsTableView.separatorInset = UIEdgeInsetsMake(0, 84, 0, 0);
        [_contactsTableView registerClass:[FMSubEmployeeTableViewCell class] forCellReuseIdentifier:[FMSubEmployeeTableViewCell identifier]];
    }
    return _contactsTableView;
}

- (FMContactViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMContactViewModel alloc] init];
    }
    return _adapter;
}

- (FMPageModel *)customerPage {
    if (!_customerPage) {
        _customerPage = [[FMPageModel alloc] init];
        _customerPage.pageNum = 1;
        _customerPage.pageSize = 15;
    }
    return _customerPage;
}

@end
