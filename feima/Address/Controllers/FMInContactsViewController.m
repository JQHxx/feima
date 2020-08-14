//
//  FMInContactsViewController.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInContactsViewController.h"
#import "FMSubEmployeeTableViewCell.h"
#import "FMOrganizationViewModel.h"

@interface FMInContactsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar        *searchBar;
@property (nonatomic, strong) UITableView        *contactsTableView;
@property (nonatomic, strong) FMOrganizationViewModel *adapter;
@property (nonatomic, strong) FMPageModel       *organizationPage;
@property (nonatomic,  copy ) NSString           *nameStr;

@end

@implementation FMInContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"组织结构";
    
    [self setupUI];
    [self loadOrganizationData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [self.adapter numberOfEmployeeList];
    } else {
        return [self.adapter numberOfOrgnazitionsList];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = ImageNamed(@"company_manager");
        FMOrganizationModel *model = [self.adapter getOrganizationModelWithIndex:indexPath.row];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",model.orgSum];
        return cell;
    } else {
        FMSubEmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMSubEmployeeTableViewCell identifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FMEmployeeModel *model = [self.adapter getEmployeeModelWithIndex:indexPath.row];
        [cell fillContentWithData:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return nil;
    } else {
        if ([self.adapter isOrganizationEmpty]||[self.adapter isEmployeeEmpty]) {
            return nil;
        } else {
            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
            aView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
            return aView;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.adapter isOrganizationEmpty]||[self.adapter isEmployeeEmpty]) {
        return 0.01;
    } else {
        return 15.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FMOrganizationModel *model = [self.adapter getOrganizationModelWithIndex:indexPath.row];
        FMInContactsViewController *contactsVC = [[FMInContactsViewController alloc] init];
        contactsVC.pid = model.organizationId;
        [self.navigationController pushViewController:contactsVC animated:YES];
    }
}

#pragma mark -- Delegate
#pragma mark  UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.nameStr = searchText;
    self.organizationPage.pageNum = 1;
    [self loadOrganizationData];
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadOrganizationData {
    [SVProgressHUD show];
    [self.adapter loadOrganizationBeansWithPage:self.organizationPage pid:self.pid name:self.nameStr complete:^(BOOL isSuccess) {
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
- (void)loadMoreOrganizationsData {
    self.organizationPage.pageNum ++ ;
    [self loadOrganizationData];
}

#pragma mark 更多底部视图
- (void)createLoadMoreView {
    if ([self.adapter hasMoreData]) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrganizationsData)];
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
        _contactsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contactsTableView.delegate = self;
        _contactsTableView.dataSource = self;
        _contactsTableView.showsVerticalScrollIndicator = NO;
        _contactsTableView.backgroundColor = [UIColor whiteColor];
        _contactsTableView.separatorInset = UIEdgeInsetsMake(0, 84, 0, 0);
        [_contactsTableView registerClass:[FMSubEmployeeTableViewCell class] forCellReuseIdentifier:[FMSubEmployeeTableViewCell identifier]];
    }
    return _contactsTableView;
}

- (FMOrganizationViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMOrganizationViewModel alloc] init];
    }
    return _adapter;
}

- (FMPageModel *)organizationPage {
    if (!_organizationPage) {
        _organizationPage = [[FMPageModel alloc] init];
        _organizationPage.pageNum = 1;
        _organizationPage.pageSize = 15;
    }
    return _organizationPage;
}

@end
