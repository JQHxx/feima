//
//  FMSelectCompanyViewController.m
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSelectCompanyViewController.h"
#import "FMCompanyViewModel.h"

@interface FMSelectCompanyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView        *myTableView;
@property (nonatomic,strong) FMCompanyViewModel *adapter;


@end

@implementation FMSelectCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"选择公司";
    
    [self.view addSubview:self.myTableView];
    [self loadAllCompanyData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfCompanyList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMCompanyModel *model = [self.adapter getCompanyModelWithIndex:indexPath.row];
    cell.textLabel.text = model.name;
    if (model.isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMCompanyModel *model = [self.adapter getCompanyModelWithIndex:indexPath.row];
    self.selectedBlock(model);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Private methods
#pragma mark 加载公司信息
- (void)loadAllCompanyData {
    FMPageModel *page = [[FMPageModel alloc] init];
    kSelfWeak;
    [self.adapter loadCompanyListWithPage:page name:nil complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.adapter didSelectedCompanyWithCompanyId:weakSelf.selCompanyId];
            [weakSelf.myTableView reloadData];
        }
    }];
}

#pragma mark -- Getters
#pragma mark tableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBar_Height, kScreen_Width, kScreen_Height-kNavBar_Height) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.tableFooterView = [[UIView alloc] init];
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCell"];
    }
    return _myTableView;
}

- (FMCompanyViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMCompanyViewModel alloc] init];
    }
    return _adapter;
}

@end
