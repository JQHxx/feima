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

@interface FMCompanyViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISearchBar    *searchBar;
@property (nonatomic, strong) UITableView    *comanyTableView;
@property (nonatomic, strong) UIButton       *addBtn;

@property (nonatomic, strong) NSMutableArray *comanyArray;



@end

@implementation FMCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"公司列表";
    
    [self setupUI];
    [self loadCompanyData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comanyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    FMCompanyModel *model = self.comanyArray[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMCompanyModel *model = self.comanyArray[indexPath.row];
    FMAddCompanyViewController *addVC = [[FMAddCompanyViewController alloc] init];
    addVC.company = model;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark -- Event response
#pragma mark 添加公司
- (void)addGoodsAction:(UIButton *)sender {
    FMAddCompanyViewController *addVC = [[FMAddCompanyViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadCompanyData {
     NSMutableArray *tempArr = [[NSMutableArray alloc] init];
       NSArray *arr = @[@"和成天下50",@"和成天下30",@"和成天下20",@"口味王50",@"口味王30",@"口味王20",@"和成天下50",@"和成天下30",@"和成天下20",@"口味王50",@"口味王30",@"口味王20"];
       for (NSInteger i=0; i<arr.count; i++) {
           FMCompanyModel * model = [[FMCompanyModel alloc] init];
           model.name = arr[i];
           [tempArr addObject:model];
       }
       self.comanyArray = tempArr;
       [self.comanyTableView reloadData];
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
        _searchBar.placeholder = @"输入姓名、手机号进行搜索";
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

- (NSMutableArray *)comanyArray {
    if (!_comanyArray) {
        _comanyArray = [[NSMutableArray alloc] init];
    }
    return _comanyArray;
}

@end
