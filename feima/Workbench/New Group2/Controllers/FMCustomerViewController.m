//
//  FMCustomerViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerViewController.h"
#import "FMAddCustomerViewController.h"
#import "FMCustomerDetailsViewController.h"
#import "FMStatisticsViewController.h"
#import "FMSearchViewController.h"
#import "FMCustomerTableViewCell.h"
#import "FMCustomerModel.h"
#import "FMCustomerViewModel.h"
#import "BRStringPickerView.h"

@interface FMCustomerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton        *filterBtn;
@property (nonatomic, strong) UIButton        *searchBtn;
@property (nonatomic, strong) UITableView     *customerTableView;
@property (nonatomic, strong) UIButton        *addBtn;
@property (nonatomic, strong) FMCustomerViewModel  *adapter;
@property (nonatomic, strong) FMPageModel    *pageModel;

@property (nonatomic, assign) NSInteger      visitCode;
@property (nonatomic,  copy ) NSString       *contactName;

@end

@implementation FMCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = self.isShowList ? @"客户分布" : @"客户管理";
    
    [self setupUI];
    [self loadCustomerData];
}
 
#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfCustomerList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMCustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMCustomerTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMCustomerModel *model = [self.adapter getCustomerModelWithIndex:indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMCustomerModel *model = [self.adapter getCustomerModelWithIndex:indexPath.row];
    if (self.isShowList) {
        FMStatisticsViewController *statisticsVC = [[FMStatisticsViewController alloc] init];
        statisticsVC.customer = model;
        [self.navigationController pushViewController:statisticsVC animated:YES];
    } else {
        FMCustomerDetailsViewController *customerVC = [[FMCustomerDetailsViewController alloc] init];
        customerVC.customer = model;
        [self.navigationController pushViewController:customerVC animated:YES];
    }
}

#pragma mark -- Events response
#pragma mark 新增客户
- (void)addCustomerAction:(UIButton *)sender {
    FMAddCustomerViewController *addCustomerVC = [[FMAddCustomerViewController alloc] init];
    [self.navigationController pushViewController:addCustomerVC animated:YES];
}

#pragma mark 筛选
- (void)filterAction:(UIButton *)sender {
    NSArray *titles = @[@"未拜访",@"已拜访"];
    kSelfWeak;
    [BRStringPickerView showStringPickerWithTitle:@"筛选" dataSource:titles defaultSelValue:nil isAutoSelect:NO resultBlock:^(id selectValue) {
        weakSelf.visitCode = [titles indexOfObject:selectValue] + 1;
        [weakSelf loadNewCustomersData];
    }];
}

#pragma mark 搜索
- (void)searchCustomerAction:(UIButton *)sender {
    FMSearchViewController *searchVC = [[FMSearchViewController alloc] init];
    kSelfWeak;
    searchVC.didClickSearch = ^(NSString *keyword) {
        weakSelf.contactName = keyword;
        [weakSelf loadNewCustomersData];
    };
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadCustomerData {
    kSelfWeak;
    [SVProgressHUD show];
    [self.adapter loadCustomerListWithPage:self.pageModel contactName:self.contactName visitCode:self.visitCode complete:^(BOOL isSuccess) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            [weakSelf.customerTableView.mj_header endRefreshing];
            [weakSelf.customerTableView.mj_footer endRefreshing];
            [weakSelf.customerTableView reloadData];
            [weakSelf createLoadMoreView];
        } else {
            [weakSelf.view makeToast:self.adapter.errorString duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark
- (void)loadNewCustomersData {
    self.pageModel.pageNum = 1;
    [self loadCustomerData];
}

#pragma mark 加载更多
- (void)loadMoreCustomersData {
    self.pageModel.pageNum ++ ;
    [self loadCustomerData];
}

#pragma mark 更多底部视图
- (void)createLoadMoreView {
    if ([self.adapter hasMoreData]) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCustomersData)];
        footer.automaticallyRefresh = NO;
        self.customerTableView.mj_footer = footer;
    } else {
        self.customerTableView.mj_footer = nil;
    }
}

#pragma mark 界面初始化
- (void)setupUI {
    [self.view addSubview:self.searchBtn];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(kStatusBar_Height+6);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.view addSubview:self.filterBtn];
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.searchBtn.mas_left).offset(-10);
        make.top.mas_equalTo(kStatusBar_Height+6);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.view addSubview:self.customerTableView];
    [self.customerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
    
    if (!self.isShowList) {
        [self.view addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-(kTabBar_Height-30));
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
}

#pragma mark -- Getters
#pragma mark 筛选
- (UIButton *)filterBtn {
    if (!_filterBtn) {
        _filterBtn = [[UIButton alloc] init];
        [_filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [_filterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _filterBtn.titleLabel.font = [UIFont mediumFontWithSize:14];
        [_filterBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
}

#pragma mark 搜索
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setImage:ImageNamed(@"search_white") forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchCustomerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

#pragma mark 客户列表
- (UITableView *)customerTableView {
    if (!_customerTableView) {
        _customerTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _customerTableView.showsVerticalScrollIndicator = NO;
        _customerTableView.dataSource = self;
        _customerTableView.delegate = self;
        _customerTableView.tableFooterView = [[UIView alloc] init];
        _customerTableView.estimatedRowHeight = 100;
        _customerTableView.rowHeight = UITableViewAutomaticDimension;
        [_customerTableView registerClass:[FMCustomerTableViewCell class] forCellReuseIdentifier:[FMCustomerTableViewCell identifier]];
        _customerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _customerTableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewCustomersData)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _customerTableView.mj_header = header;
    }
    return _customerTableView;
}

#pragma mark 添加商品
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton addButtonWithTarget:self selector:@selector(addCustomerAction:)];
    }
    return _addBtn;
}

- (FMCustomerViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMCustomerViewModel alloc] init];
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
