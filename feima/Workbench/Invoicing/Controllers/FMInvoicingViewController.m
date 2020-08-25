//
//  FMInvoicingViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInvoicingViewController.h"
#import "FMDistributionViewController.h"
#import "FMInvoicingTableView.h"
#import "SlideMenuView.h"
#import "FMOrderModel.h"

@interface FMInvoicingViewController ()<UISearchBarDelegate,SlideMenuViewDelegate>

@property (nonatomic, strong) SlideMenuView         *menuView;
@property (nonatomic, strong) UISearchBar           *searchBar;
@property (nonatomic, strong) UIScrollView          *rootScrollView;
@property (nonatomic, strong) FMInvoicingTableView  *distributionTableView; //配货
@property (nonatomic, strong) FMInvoicingTableView  *returnTableView; //退换货

@property (nonatomic, assign) NSInteger  selectedIndex;

@end

@implementation FMInvoicingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"货物进销存";
    
    self.selectedIndex = 0;
    
    [self setupUI];
}

#pragma mark SlideMenuViewDelegate
- (void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index {
    self.selectedIndex = index;
    if (index == 1) {
        if (!_returnTableView) {
            _returnTableView = [[FMInvoicingTableView alloc] initWithFrame:CGRectMake(kScreen_Width, 0, kScreen_Width, self.rootScrollView.height) style:UITableViewStylePlain type:1];
            [self.rootScrollView addSubview:_returnTableView];
        }
    }
    [self.rootScrollView setContentOffset:CGPointMake(kScreen_Width*index, 0)];
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView addSubview:self.distributionTableView];
}

#pragma mark -- Getters
#pragma mark 搜索
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, kNavBar_Height, kScreen_Width-30, 50)];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"请输入名称、品类";
    }
    return _searchBar;
}

#pragma mark 菜单
- (SlideMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[SlideMenuView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom,150, 50) btnTitleFont:[UIFont regularFontWithSize:16.0f] color:[UIColor colorWithHexString:@"#666666"] selColor:[UIColor systemColor]];
        _menuView.btnCapWidth = 10;
        _menuView.lineWidth = 40.0;
        _menuView.selectTitleFont = [UIFont mediumFontWithSize:20.0f];
        _menuView.myTitleArray = [NSMutableArray arrayWithArray:@[@"配货",@"退换货"]];
        _menuView.currentIndex = 0;
        _menuView.delegate = self;
    }
    return _menuView;
}

#pragma mark 滚动视图
- (UIScrollView *)rootScrollView {
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.menuView.bottom, kScreen_Width, kScreen_Height-self.menuView.bottom)];
        _rootScrollView.showsHorizontalScrollIndicator = NO;
        _rootScrollView.pagingEnabled = YES;
        _rootScrollView.contentSize = CGSizeMake(kScreen_Width*2, kScreen_Height-self.menuView.bottom);
    }
    return _rootScrollView;
}

#pragma mark 配货
- (FMInvoicingTableView *)distributionTableView {
    if (!_distributionTableView) {
        _distributionTableView = [[FMInvoicingTableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.rootScrollView.height) style:UITableViewStylePlain type:0];
    }
    return _distributionTableView;
}

@end
