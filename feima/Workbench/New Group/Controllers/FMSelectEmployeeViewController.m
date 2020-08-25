//
//  FMSelectEmployeeViewController.m
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSelectEmployeeViewController.h"
#import "FMEmployeeViewModel.h"


@interface FMSelectEmployeeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic, strong) FMEmployeeViewModel *adapter;

@end

@implementation FMSelectEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"选择员工";
    
    [self.view addSubview:self.myTableView];
    [self loadAllEmployeeData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfEmployeesList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMEmployeeModel *model = [self.adapter getEmployeeModelWithIndex:indexPath.row];
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
    FMEmployeeModel *model = [self.adapter getEmployeeModelWithIndex:indexPath.row];
    self.selectedComplete(model);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Private methods
#pragma mark 加载员工
- (void)loadAllEmployeeData {
    FMPageModel *page = [[FMPageModel alloc] init];
    kSelfWeak;
    [self.adapter loadEmployeeListDataWithPage:page name:nil status:1 complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.adapter didSelectedEmployeeWithEmployeeId:weakSelf.selEmployeeId];
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

- (FMEmployeeViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMEmployeeViewModel alloc] init];
    }
    return _adapter;
}

@end
