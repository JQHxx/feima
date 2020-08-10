//
//  FMUserInfoViewController.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMUserInfoViewController.h"

@interface FMUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray        *titlesArr;
    UIImageView    *headImgView;
}

@property (nonatomic,strong) UITableView *userTableView;
@property (nonatomic,strong) NSMutableArray *userInfo;

@end

@implementation FMUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"个人信息";
    
    titlesArr = @[@"头像",@"姓名",@"性别",@"部门",@"职务",@"手机号"];
    NSArray *arr = @[@"11",@"亦于涛",@"男",@"市场一部",@"主管",@"18229729653"];
    [self.userInfo addObjectsFromArray:arr];
    
    [self.view addSubview:self.userTableView];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = titlesArr[indexPath.row];
    if (indexPath.row == 0) {
        headImgView = [[UIImageView alloc] init];
        headImgView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:headImgView];
        [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    } else {
        cell.detailTextLabel.text = self.userInfo[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 72;
    } else {
        return 50;
    }
}

#pragma mark -- Getters
#pragma mark 我的
- (UITableView *)userTableView {
    if (!_userTableView) {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBar_Height+18, kScreen_Width, kScreen_Height-kNavBar_Height-18) style:UITableViewStylePlain];
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        _userTableView.showsVerticalScrollIndicator = NO;
        _userTableView.tableFooterView = [[UIView alloc] init];
        _userTableView.backgroundColor = [UIColor whiteColor];
    }
    return _userTableView;
}

#pragma mark 用户信息
- (NSMutableArray *)userInfo {
    if (!_userInfo) {
        _userInfo = [[NSMutableArray alloc] init];
    }
    return _userInfo;
}

@end
