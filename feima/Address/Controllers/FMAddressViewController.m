//
//  FMAddressViewController.m
//  feima
//
//  Created by fei on 2020/7/29.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAddressViewController.h"
#import "FMInContactsViewController.h"
#import "FMOutContactsViewController.h"

@interface FMAddressViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISearchBar  *searchBar;
@property (nonatomic, strong) UITableView  *contactsTableView;

@end

@implementation FMAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"通讯录";
    self.isHiddenBackBtn = self.backBtnHidden;
    
    [self setupUI];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        static NSString *identifier = @"ContactTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = ImageNamed(@"customer");
        cell.textLabel.text = @"曹磊";
    
        UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width-60, 10, 34, 34)];
        [callBtn setImage:ImageNamed(@"call") forState:UIControlStateNormal];
        callBtn.tag = indexPath.row;
        [callBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:callBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(90, 53, kScreen_Width-94, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        [cell.contentView addSubview:line];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.imageView.image = ImageNamed(@"company_manager");
            cell.textLabel.text = @"公司内部通讯录";
            cell.detailTextLabel.text = @"17";
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(90, 61, kScreen_Width-90, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
            [cell.contentView addSubview:line];
        } else {
            cell.imageView.image = ImageNamed(@"customer");
            cell.textLabel.text = @"外部客户通讯录";
            cell.detailTextLabel.text = @"3";
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 62;
    } else {
        return 54;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FMInContactsViewController *inContactsVC = [[FMInContactsViewController alloc] init];
            [self.navigationController pushViewController:inContactsVC animated:YES];
        } else {
            FMOutContactsViewController *outContactsVC = [[FMOutContactsViewController alloc] init];
            [self.navigationController pushViewController:outContactsVC animated:YES];
        }
    }
}

#pragma mark -- Event response
#pragma mark 打电话
- (void)callAction:(UIButton *)sender {
    
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadContactsData {
    [[HttpRequest sharedInstance] postWithUrl:api_customer_phone parameters:nil success:^(id responseObject) {
        
    } failure:^(NSString *errorStr) {
        
    }];
}

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
        _contactsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contactsTableView.delegate = self;
        _contactsTableView.dataSource = self;
        _contactsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _contactsTableView.showsVerticalScrollIndicator = NO;
    }
    return _contactsTableView;
}



@end
