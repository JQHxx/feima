//
//  FMCompanyViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCompanyViewController.h"
#import "FMAddCompanyViewController.h"
#import "FMCompanyModel.h"
#import "FMCompanyViewModel.h"

@interface FMCompanyViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISearchBar    *searchBar;
@property (nonatomic, strong) UITableView    *comanyTableView;
@property (nonatomic, strong) UIButton       *addBtn;

@property (nonatomic, strong) FMPageModel    *pageModel;
@property (nonatomic, strong) FMCompanyViewModel *adapter;
@property (nonatomic,  copy ) NSString       *name;


@end

@implementation FMCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"公司列表";
    
    self.name = nil;
    
    [self setupUI];
    [self loadCompanyData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfCompanyList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    FMCompanyModel *model = [self.adapter getCompanyModelWithIndex:indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMCompanyModel *model = [self.adapter getCompanyModelWithIndex:indexPath.row];
    FMAddCompanyViewController *addVC = [[FMAddCompanyViewController alloc] init];
    addVC.company = model;
    kSelfWeak;
    addVC.updateSuccess = ^(FMCompanyModel *company) {
        [weakSelf.adapter replaceCompanyWithNewCompany:company];
        [weakSelf.comanyTableView reloadData];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark 删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FMCompanyModel *model = [self.adapter getCompanyModelWithIndex:indexPath.row];
        kSelfWeak;
        [self.adapter deleteCompanyWithCompanyId:model.companyId complete:^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.comanyTableView reloadData];
            } else {
                [weakSelf.view makeToast:weakSelf.adapter.errorString duration:2.0 position:CSToastPositionCenter];
            }
        }];
    }
}

#pragma mark 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark 修改Delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark 先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark 设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark -- UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.name = searchText;
    [self loadNewCompanyData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.name = searchBar.text;
    [self loadNewCompanyData];
}

#pragma mark -- Event response
#pragma mark 添加公司
- (void)addGoodsAction:(UIButton *)sender {
    FMAddCompanyViewController *addVC = [[FMAddCompanyViewController alloc] init];
    kSelfWeak;
    addVC.addSuccess = ^(FMCompanyModel *company) {
        [weakSelf.adapter insertCompany:company];
        [weakSelf.comanyTableView reloadData];
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadCompanyData {
    kSelfWeak;
    [self.adapter loadCompanyListWithPage:self.pageModel name:self.name complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.comanyTableView.mj_header endRefreshing];
            [weakSelf.comanyTableView.mj_footer endRefreshing];
            [weakSelf.comanyTableView reloadData];
            [weakSelf createLoadMoreView];
        } else {
            [weakSelf.view makeToast:self.adapter.errorString duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark
- (void)loadNewCompanyData {
    self.pageModel.pageNum = 1;
    [self loadCompanyData];
}

#pragma mark 加载更多
- (void)loadMoreCompanyData {
    self.pageModel.pageNum ++ ;
    [self loadCompanyData];
}

#pragma mark 更多底部视图
- (void)createLoadMoreView {
    if ([self.adapter hasMoreData]) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCompanyData)];
        footer.automaticallyRefresh = NO;
        self.comanyTableView.mj_footer = footer;
    } else {
        self.comanyTableView.mj_footer = nil;
    }
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(kNavBar_Height);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 50));
    }];
    
    [self.view addSubview:self.comanyTableView];
    [self.comanyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-50);
    }];
    
    [self.view addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-(kTabBar_Height-30));
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

#pragma mark -- Getter
#pragma mark 搜索
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"请输入公司名称";
    }
    return _searchBar;
}

#pragma mark 公司列表
- (UITableView *)comanyTableView {
    if (!_comanyTableView) {
        _comanyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _comanyTableView.delegate = self;
        _comanyTableView.dataSource = self;
        _comanyTableView.showsVerticalScrollIndicator = NO;
        _comanyTableView.tableFooterView = [[UIView alloc] init];
        _comanyTableView.backgroundColor = [UIColor whiteColor];
    }
    return _comanyTableView;
}

#pragma mark 添加商品
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton addButtonWithTarget:self selector:@selector(addGoodsAction:)];
    }
    return _addBtn;
}

- (FMCompanyViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMCompanyViewModel alloc] init];
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
