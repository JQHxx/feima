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

@property (nonatomic,strong) FMUserModel *user;

@end

@implementation FMUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"个人信息";
    
    titlesArr = @[@"头像",@"姓名",@"性别",@"部门",@"职务",@"手机号"];
    self.user = [FeimaManager sharedFeimaManager].userBean.users;
    
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
        [headImgView sd_setImageWithURL:[NSURL URLWithString:self.user.logo] placeholderImage:[UIImage ctPlaceholderImage]];
        headImgView.layer.cornerRadius = 30;
        headImgView.layer.masksToBounds = YES;
        [cell.contentView addSubview:headImgView];
        [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    } else {
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = kIsEmptyString(self.user.name)?@"":self.user.name;
        } else if (indexPath.row == 2) {
            cell.detailTextLabel.text = kIsEmptyString(self.user.sexName)?@"":self.user.sexName;
        } else if (indexPath.row == 3) {
            cell.detailTextLabel.text = kIsEmptyString(self.user.organizationName)?@"":self.user.organizationName;
        } else if (indexPath.row == 4) {
            cell.detailTextLabel.text = kIsEmptyString(self.user.postName)?@"":self.user.postName;
        } else if (indexPath.row == 5) {
            cell.detailTextLabel.text = kIsEmptyString(self.user.telephone)?@"":self.user.telephone;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 82;
    } else {
        return 60;
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

@end
