//
//  FMOutContactsViewController.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMOutContactsViewController.h"

@interface FMOutContactsViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UISearchBar  *searchBar;
@property (nonatomic, strong) UITableView  *contactsTableView;

@end

@implementation FMOutContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"客户列表";
    
    [self setupUI];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = ImageNamed(@"company_manager");
    cell.textLabel.text = @"飞马测试";
    
    UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width-60, 10, 34, 34)];
    [callBtn setImage:ImageNamed(@"call") forState:UIControlStateNormal];
    callBtn.tag = indexPath.row;
    [callBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:callBtn];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

#pragma mark -- Event response
#pragma mark 打电话
- (void)callAction:(UIButton *)sender {
    
}

#pragma mark -- Private methods
#pragma mark 界面初始化
- (void)setupUI {
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(kNavBar_Height);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 50));
    }];
    
    [self.view addSubview:self.contactsTableView];
    [self.contactsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-kTabBar_Height-50);
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
    }
    return _contactsTableView;
}


@end
