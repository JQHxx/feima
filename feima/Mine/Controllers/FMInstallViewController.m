//
//  FMInstallViewController.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInstallViewController.h"
#import "FMChangeViewController.h"
#import "FMLoginViewModel.h"

@interface FMInstallViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *titlesArr;
}

@property (nonatomic, strong) UITableView      *setTableView;
@property (nonatomic, strong) UIButton         *logoutBtn;
@property (nonatomic, strong) FMLoginViewModel *adapter;

@end

@implementation FMInstallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"设置";
    titlesArr = @[@"修改密码",@"更改手机号"];
    self.adapter = [[FMLoginViewModel alloc] init];
    
    [self.view addSubview:self.setTableView];
    [self.setTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNavBar_Height);
        make.height.mas_equalTo(106);
    }];
    
    [self.view addSubview:self.logoutBtn];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.setTableView.mas_bottom).offset(60);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-36, 46));
    }];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = titlesArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMChangeViewController *changeVC = [[FMChangeViewController alloc] init];
    changeVC.isChangingPwd = indexPath.row == 0;
    [self.navigationController pushViewController:changeVC animated:YES];
}

#pragma mark -- Events response
#pragma mark 退出登录
- (void)logoutAction:(UIButton *)sender {
    [SVProgressHUD show];
    [self.adapter logoutComplete:^(BOOL isSuccess) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            [[FeimaManager sharedFeimaManager] logout];
        } else {
            [self.view makeToast:self.adapter.errorString duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark -- Getters
#pragma mark 我的
- (UITableView *)setTableView {
    if (!_setTableView) {
        _setTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _setTableView.delegate = self;
        _setTableView.dataSource = self;
        _setTableView.showsVerticalScrollIndicator = NO;
        _setTableView.tableFooterView = [[UIView alloc] init];
    }
    return _setTableView;
}

#pragma mark 退出登录
- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:[UIColor systemColor] forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        _logoutBtn.layer.cornerRadius = 5;
        _logoutBtn.layer.borderColor = [UIColor systemColor].CGColor;
        _logoutBtn.layer.borderWidth = 1;
        _logoutBtn.clipsToBounds = YES;
        [_logoutBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}




@end
