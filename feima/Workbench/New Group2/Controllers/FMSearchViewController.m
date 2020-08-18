//
//  FMSearchViewController.m
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSearchViewController.h"

@interface FMSearchViewController ()<UISearchBarDelegate>

@property (nonatomic,strong)UISearchBar *searchBar;

@end

@implementation FMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"客户搜索";
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.didClickSearch(searchBar.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UI
- (void)setupUI {
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(kNavBar_Height);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 60));
    }];
}

#pragma mark -- Getters
#pragma mark 搜索
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"请输入客户名称，联系人或手机号搜索";
    }
    return _searchBar;
}

@end
