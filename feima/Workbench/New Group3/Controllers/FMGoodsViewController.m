//
//  FMGoodsViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMGoodsViewController.h"
#import "FMAddGoodsViewController.h"
#import "FMGoodsDetailsViewController.h"
#import "FMGoodsTableViewCell.h"
#import "FMGoodsViewModel.h"
#import "FMGoodsModel.h"

@interface FMGoodsViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,FMGoodsTableViewCellDelegate>

@property (nonatomic, strong) UISearchBar        *searchBar;
@property (nonatomic, strong) UITableView        *goodsTableView;
@property (nonatomic, strong) UIButton           *addBtn;

@property (nonatomic, strong) FMPageModel        *pageModel;
@property (nonatomic, strong) FMGoodsViewModel   *adapter;
@property (nonatomic,  copy ) NSString       *name;


@end

@implementation FMGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"商品列表";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self setupUI];
    [self loadGoodsData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfGoodsList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMGoodsTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMGoodsModel * model = [self.adapter getGoodsModelWithIndex:indexPath.row];
    [cell fillContentWithData:model];
    cell.cellDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMGoodsModel * model = [self.adapter getGoodsModelWithIndex:indexPath.row];
    FMGoodsDetailsViewController *goodsDetailsVC = [[FMGoodsDetailsViewController alloc] init];
    goodsDetailsVC.goods = model;
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}

#pragma mark 删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FMGoodsModel *model = [self.adapter getGoodsModelWithIndex:indexPath.row];
        kSelfWeak;
        [self.adapter deleteGoodsWithGoodsIds:[NSString stringWithFormat:@"%ld",model.goodsId] complete:^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.goodsTableView reloadData];
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
    BOOL hasPermission = [[FeimaManager sharedFeimaManager] hasPermissionWithApiStr:api_goods_remove];
    return hasPermission;
}

#pragma mark 设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
      return NO;
}

#pragma mark FMGoodsTableViewCellDelegate
- (void)tableViewCell:(FMGoodsTableViewCell *)cell didSelectedGoods:(FMGoodsModel *)model withBtnTag:(NSInteger)tag {
    if (tag == 1) { //上架、下架
        kSelfWeak;
        [self.adapter setGoodsEnableWithGoodsId:model.goodsId enable:model.status == 0 complete:^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.goodsTableView reloadData];
            }
        }];
    } else { //编辑
        FMAddGoodsViewController *addVC = [[FMAddGoodsViewController alloc] init];
        addVC.goods = model;
        kSelfWeak;
        addVC.updateSuccess = ^(FMGoodsModel *goods) {
            [weakSelf.adapter replaceGoodsWithNewGoods:goods];
            [weakSelf.goodsTableView reloadData];
        };
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

#pragma mark -- UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.name = searchText;
    [self loadNewGoodsData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.name = searchBar.text;
    [self loadNewGoodsData];
}

#pragma mark -- Event response
#pragma mark 添加公司
- (void)addGoodsAction:(UIButton *)sender {
    FMAddGoodsViewController *addGoodsVC = [[FMAddGoodsViewController alloc] init];
    kSelfWeak;
    addGoodsVC.addSuccess = ^(FMGoodsModel *goods) {
        [weakSelf.adapter insertGoods:goods];
        [weakSelf.goodsTableView reloadData];
    };
    [self.navigationController pushViewController:addGoodsVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadGoodsData {
    kSelfWeak;
    [self.adapter loadGoodsListWithPage:self.pageModel name:self.name complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.goodsTableView.mj_header endRefreshing];
            [weakSelf.goodsTableView.mj_footer endRefreshing];
            [weakSelf.goodsTableView reloadData];
            [weakSelf createLoadMoreView];
        } else {
            [weakSelf.view makeToast:self.adapter.errorString duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark
- (void)loadNewGoodsData {
    self.pageModel.pageNum = 1;
    [self loadGoodsData];
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
        self.goodsTableView.mj_footer = footer;
    } else {
        self.goodsTableView.mj_footer = nil;
    }
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(kNavBar_Height+10);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 50));
    }];
    
    [self.view addSubview:self.goodsTableView];
    [self.goodsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-65);
    }];
    
    BOOL hasPermission = [[FeimaManager sharedFeimaManager] hasPermissionWithApiStr:api_goods_add];
    if (hasPermission) {
        [self.view addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-(kTabBar_Height-30));
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
}

#pragma mark -- Getters
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
- (UITableView *)goodsTableView {
    if (!_goodsTableView) {
        _goodsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodsTableView.delegate = self;
        _goodsTableView.dataSource = self;
        _goodsTableView.showsVerticalScrollIndicator = NO;
        _goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsTableView.tableFooterView = [[UIView alloc] init];
        _goodsTableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_goodsTableView registerClass:[FMGoodsTableViewCell class] forCellReuseIdentifier:[FMGoodsTableViewCell identifier]];
    }
    return _goodsTableView;
}

#pragma mark 添加商品
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton addButtonWithTarget:self selector:@selector(addGoodsAction:)];
    }
    return _addBtn;
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
