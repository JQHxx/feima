//
//  FMSelectGoodsViewController.m
//  feima
//
//  Created by fei on 2020/8/25.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSelectGoodsViewController.h"
#import "FMConfirmViewController.h"
#import "FMDistributionTableViewCell.h"
#import "FMGoodsViewModel.h"

@interface FMSelectGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,FMDistributionTableViewCellDelegate>

@property (nonatomic, strong) UIButton         *nextBtn;
@property (nonatomic, strong) UISearchBar      *searchBar;
@property (nonatomic, strong) UITableView      *myTableView;
@property (nonatomic, strong) FMGoodsViewModel *adapter;
@property (nonatomic, strong) FMPageModel      *pageModel;


@end

@implementation FMSelectGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"选择商品";
    
    [self setupUI];
    [self loadGoodsData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfGoodsList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMDistributionTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellDelegate = self;
    FMGoodsModel  *model = [self.adapter getGoodsModelWithIndex:indexPath.row];
    [cell fillContentWithData:model type:self.type+1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

#pragma mark FMDistributionTableViewCellDelegate
#pragma mark 设置商品数量
- (void)distributionTableViewDidSelectedGoods:(FMGoodsModel *)goods {
    [self.adapter replaceGoodsWithNewGoods:goods];
}

#pragma mark -- Event response
#pragma mark 下一步
- (void)nextAction:(UIButton *)sender {
    NSInteger count = [self.adapter numberOfGoodsList];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<count; i++) {
        FMGoodsModel *model = [self.adapter getGoodsModelWithIndex:i];
        if (model.quantity > 0) {
            [tempArr addObject:model];
        }
    }
    if (tempArr.count == 0) {
        [self.view makeToast:@"请先选择商品" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    FMConfirmViewController *confirmVC = [[FMConfirmViewController alloc] init];
    confirmVC.type = self.type;
    confirmVC.selGoodsArr = tempArr;
    [self.navigationController pushViewController:confirmVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadGoodsData {
    kSelfWeak;
    [self.adapter loadSalesGoodsListWithType:self.type page:self.pageModel complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.myTableView.mj_footer endRefreshing];
            [weakSelf.myTableView reloadData];
            [weakSelf createLoadMoreView];
        } else {
            [weakSelf.view makeToast:self.adapter.errorString duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark 加载更多
- (void)loadMoreGoodsData {
    self.pageModel.pageNum ++ ;
    [self loadGoodsData];
}

#pragma mark 更多底部视图
- (void)createLoadMoreView {
    if ([self.adapter hasMoreData]) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGoodsData)];
        footer.automaticallyRefresh = NO;
        self.myTableView.mj_footer = footer;
    } else {
        self.myTableView.mj_footer = nil;
    }
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(kStatusBar_Height+6);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(kNavBar_Height+10);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 50));
    }];
    
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-60);
    }];
}

#pragma mark -- Getters
#pragma mark 筛选
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont mediumFontWithSize:14];
        [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

#pragma mark 搜索
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"请输入商品名称";
    }
    return _searchBar;
}

#pragma mark 商品列表
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_myTableView registerClass:[FMDistributionTableViewCell class] forCellReuseIdentifier:[FMDistributionTableViewCell identifier]];
    }
    return _myTableView;
}

- (FMGoodsViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMGoodsViewModel alloc] init];
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
