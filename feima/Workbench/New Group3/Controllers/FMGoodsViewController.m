//
//  FMGoodsViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMGoodsViewController.h"
#import "FMAddGoodsViewController.h"
#import "FMGoodsTableViewCell.h"
#import "FMGoodsModel.h"

@interface FMGoodsViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,FMGoodsTableViewCellDelegate>

@property (nonatomic, strong) UISearchBar        *searchBar;
@property (nonatomic, strong) UITableView        *goodsTableView;
@property (nonatomic, strong) UIButton           *addBtn;
@property (nonatomic, strong) NSMutableArray     *goodsArray;


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
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMGoodsTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMGoodsModel * model = self.goodsArray[indexPath.row];
    [cell fillContentWithData:model];
    cell.cellDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark 删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

#pragma mark FMGoodsTableViewCellDelegate
- (void)tableViewCell:(FMGoodsTableViewCell *)cell didSelectedGoods:(FMGoodsModel *)model withBtnTag:(NSInteger)tag {
    if (tag == 1) { //下架
        
    } else { //编辑
        FMAddGoodsViewController *addVC = [[FMAddGoodsViewController alloc] init];
        addVC.goods = model;
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

#pragma mark -- Event response
#pragma mark 添加商品
- (void)addGoodsAction:(UIButton *)sender {
    FMAddGoodsViewController *addGoodsVC = [[FMAddGoodsViewController alloc] init];
    [self.navigationController pushViewController:addGoodsVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark Load Data
- (void)loadGoodsData {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    NSArray *arr = @[@"和成天下50",@"和成天下30",@"和成天下20",@"口味王50",@"口味王30",@"口味王20",@"和成天下50",@"和成天下30",@"和成天下20",@"口味王50",@"口味王30",@"口味王20"];
    for (NSInteger i=0; i<arr.count; i++) {
        FMGoodsModel * model = [[FMGoodsModel alloc] init];
        model.name = arr[i];
        model.stock = 10000;
        model.categoryName = @"本品";
        [tempArr addObject:model];
    }
    self.goodsArray = tempArr;
    [self.goodsTableView reloadData];
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
    
    [self.view addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-(kTabBar_Height-30));
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
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

- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc] init];
    }
    return _goodsArray;
}

@end
