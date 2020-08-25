//
//  FMEmployeeContentView.m
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMEmployeeContentView.h"
#import "FMEmployeeTableViewCell.h"
#import "FMEmployeeViewModel.h"

@interface FMEmployeeContentView ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISearchBar     *searchBar;
@property (nonatomic, strong) UITableView     *employeeTableView;

@property (nonatomic, strong) FMEmployeeViewModel *adapter;
@property (nonatomic, assign) NSInteger           status;
@property (nonatomic, strong) FMPageModel         *myPage;
@property (nonatomic,  copy ) NSString            *name;

@end

@implementation FMEmployeeContentView

- (instancetype)initWithFrame:(CGRect)frame status:(NSInteger)status{
    self = [super initWithFrame:frame];
    if (self) {
        self.status = status;
        
        [self setupUI];
        [self loadEmployeeData];
    }
    return self;
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfEmployeesList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMEmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMEmployeeTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMEmployeeModel * model = [self.adapter getEmployeeModelWithIndex:indexPath.row];
    [cell fillContentWithData:model status:self.status];
    kSelfWeak;
    cell.moreBlock = ^(FMEmployeeModel *employee, NSInteger index) {
        if (index == 3) {
            BOOL isEnable = weakSelf.status == 0;
            [weakSelf.adapter setEmployeeEnable:isEnable employeeId:employee.employeeId complete:^(BOOL isSuccess) {
                if (isSuccess) {
                    [FeimaManager sharedFeimaManager].employeeListReload = YES;
                    [weakSelf.adapter deleteFromListWithEmployee:employee];
                    [weakSelf.employeeTableView reloadData];
                    [weakSelf makeToast:[NSString stringWithFormat:@"%@成功",isEnable?@"启用":@"禁用"] duration:1.5 position:CSToastPositionCenter];
                }
            }];
        } else {
            if ([weakSelf.viewDelegate respondsToSelector:@selector(employeeContentView:didSlectedEmployee:index:)]) {
                [weakSelf.viewDelegate employeeContentView:self didSlectedEmployee:employee index:index];
            }
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}


#pragma mark -- UISearchBarDelegate
#pragma mark 输入时回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.name = searchText;
    [self loadNewEmployeeData];
}

#pragma mark 点击搜索时回调
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.name = searchBar.text;
    [self loadNewEmployeeData];
}

#pragma mark -- Public methods
#pragma mark 插入
- (void)insertEmployeeWithModel:(FMEmployeeModel *)model {
    [self.adapter insertEmployee:model];
    [self.employeeTableView reloadData];
}

#pragma mark 修改
- (void)updateEmployeeInfoWithModel:(FMEmployeeModel *)model {
    [self.adapter replaceEmployeeWithNewGoods:model];
    [self.employeeTableView reloadData];
}

#pragma mark -- Private methods
#pragma mark Load Data
- (void)loadEmployeeData {
    kSelfWeak;
    [self.adapter loadEmployeeListDataWithPage:self.myPage name:self.name status:self.status complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.employeeTableView.mj_header endRefreshing];
            [weakSelf.employeeTableView.mj_footer endRefreshing];
            [weakSelf.employeeTableView reloadData];
            [weakSelf createLoadMoreView];
        }
    }];
}

#pragma mark UI
- (void)setupUI {
    [self addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.employeeTableView];
    [self.employeeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-50);
    }];
}

#pragma mark
- (void)loadNewEmployeeData {
    self.myPage.pageNum = 1;
    [self loadEmployeeData];
}

#pragma mark 加载更多
- (void)loadMoreEmployeeData {
    self.myPage.pageNum ++ ;
    [self loadEmployeeData];
}

#pragma mark 更多底部视图
- (void)createLoadMoreView {
    if ([self.adapter hasMoreData]) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreEmployeeData)];
        footer.automaticallyRefresh = NO;
        self.employeeTableView.mj_footer = footer;
    } else {
        self.employeeTableView.mj_footer = nil;
    }
}

#pragma mark -- Getters
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

#pragma mark tableView
- (UITableView *)employeeTableView {
    if (!_employeeTableView) {
        _employeeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _employeeTableView.showsVerticalScrollIndicator = NO;
        _employeeTableView.dataSource = self;
        _employeeTableView.delegate = self;
        _employeeTableView.tableFooterView = [[UIView alloc] init];
        [_employeeTableView registerClass:[FMEmployeeTableViewCell class] forCellReuseIdentifier:[FMEmployeeTableViewCell identifier]];
    }
    return _employeeTableView;
}

- (FMEmployeeViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMEmployeeViewModel alloc] init];
    }
    return _adapter;
}

- (FMPageModel *)myPage {
    if (!_myPage) {
        _myPage = [[FMPageModel alloc] init];
        _myPage.pageNum = 1;
        _myPage.pageSize = 15;
    }
    return _myPage;
}


@end
