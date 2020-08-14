//
//  FMAddressViewController.m
//  feima
//
//  Created by fei on 2020/7/29.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAddressViewController.h"
#import "FMInContactsViewController.h"
#import "FMOutContactsViewController.h"
#import "FMSubEmployeeTableViewCell.h"
#import "FMContactViewModel.h"

@interface FMAddressViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSArray *imagesArr;
    NSArray *titlesArr;
}

@property (nonatomic, strong) UISearchBar        *searchBar;
@property (nonatomic, strong) UITableView        *contactsTableView;
@property (nonatomic, strong) FMContactViewModel *adapter;
@property (nonatomic, strong) FMPageModel        *pageModel;
@property (nonatomic,  copy ) NSString           *nameStr;

@end

@implementation FMAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"通讯录";
    self.isHiddenBackBtn = self.backBtnHidden;
    
    imagesArr = @[@"company_manager",@"customer"];
    titlesArr = @[@"公司内部通讯录",@"外部客户通讯录"];
    self.nameStr = @"";
    
    [self setupUI];
    [self loadContactsData];
    [self loadEmployeeContactsData];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [self.adapter numberOfEmployeesList];
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        FMSubEmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMSubEmployeeTableViewCell identifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FMEmployeeModel *model = [self.adapter getEmployeeModelWithIndex:indexPath.row];
        [cell fillContentWithData:model];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = ImageNamed(imagesArr[indexPath.row]);
        cell.textLabel.text = titlesArr[indexPath.row];
        
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",[self.adapter employeeTotalCount]];
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",[self.adapter customerTotalCount]];
        }
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
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
        aView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        return aView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FMInContactsViewController *inContactsVC = [[FMInContactsViewController alloc] init];
            inContactsVC.pid = 0;
            [self.navigationController pushViewController:inContactsVC animated:YES];
        } else {
            FMOutContactsViewController *outContactsVC = [[FMOutContactsViewController alloc] init];
            [self.navigationController pushViewController:outContactsVC animated:YES];
        }
    }
}

#pragma mark -- Delegate
#pragma mark  UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.nameStr = searchText;
    self.pageModel.pageNum = 1;
    [self loadEmployeeContactsData];
}

#pragma mark -- Event response
#pragma mark 打电话
- (void)callAction:(UIButton *)sender {
    FMEmployeeModel *model = [self.adapter getEmployeeModelWithIndex:sender.tag];
    [[FeimaManager sharedFeimaManager] callPhoneWithNumber:model.telephone];
}

#pragma mark -- Private methods
#pragma mark 加载客户通讯录
- (void)loadContactsData {
    FMPageModel *contactPage = [[FMPageModel alloc] init];
    contactPage.pageNum = 1;
    contactPage.pageSize = 15;
    [self.adapter loadCustomerContactsDataWithPage:contactPage contactName:@"" action:@"total" complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [self.contactsTableView reloadData];
        }
    }];
}

#pragma mark 加载员工通讯录
- (void)loadEmployeeContactsData {
    [SVProgressHUD show];
    [self.adapter loadEmployeeContactsDataWithPage:self.pageModel name:self.nameStr complete:^(BOOL isSuccess) {
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
- (void)loadMoreEmployeeContactsData {
    self.pageModel.pageNum ++ ;
    [self loadEmployeeContactsData];
}

#pragma mark 更多底部视图
- (void)createLoadMoreView {
    if ([self.adapter hasMoreEmployeeData]) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreEmployeeContactsData)];
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
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-60-(self.backBtnHidden?kTabBar_Height:0));
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

- (FMContactViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMContactViewModel alloc] init];
    }
    return _adapter;
}

- (FMPageModel *)pageModel {
    if (!_pageModel) {
        _pageModel = [[FMPageModel alloc] init];
        _pageModel.pageNum = 1;
        _pageModel.pageSize = 15;
    }
    return _pageModel;
}

@end
