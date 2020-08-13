//
//  FMMineViewController.m
//  feima
//
//  Created by fei on 2020/7/29.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMineViewController.h"
#import "FMUserInfoViewController.h"
#import "FMHeadView.h"
#import "FMMineTableViewCell.h"

@interface FMMineViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray  *imagesArr;
    NSArray  *titlesArr;
    NSArray  *classes;
}

@property (nonatomic,strong) FMHeadView  *headView;
@property (nonatomic,strong) UITableView *mineTableView;

@end

@implementation FMMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    imagesArr = @[@"company_manager",@"company_manager",@"company_manager",@"company_manager"];
    titlesArr = @[@"我的消息",@"通讯录",@"公司组织结构",@"设置"];
    classes = @[@"Message",@"Address",@"InContacts",@"Install"];
    
    [self.view addSubview:self.mineTableView];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMMineTableViewCell *cell = [[FMMineTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImgView.image = ImageNamed(imagesArr[indexPath.row]);
    cell.titleLabel.text = titlesArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *classStr = [NSString stringWithFormat:@"FM%@ViewController",classes[indexPath.row]];
    Class aClass = NSClassFromString(classStr);
    BaseViewController *vc = (BaseViewController *)[[aClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

#pragma mark -- Event response
#pragma mark 用户资料
- (void)userInfoAction:(UITapGestureRecognizer *)sender {
    FMUserInfoViewController *userInfoVC = [[FMUserInfoViewController alloc] init];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark -- Getters
#pragma mark 头部视图
- (FMHeadView *)headView {
    if (!_headView) {
        _headView = [[FMHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width,kNavBar_Height+120)];
        [_headView addTapPressed:@selector(userInfoAction:) target:self];
    }
    return _headView;
}

#pragma mark 我的
- (UITableView *)mineTableView {
    if (!_mineTableView) {
        _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-kTabBar_Height) style:UITableViewStylePlain];
        _mineTableView.delegate = self;
        _mineTableView.dataSource = self;
        _mineTableView.showsVerticalScrollIndicator = NO;
        _mineTableView.tableHeaderView = self.headView;
        _mineTableView.backgroundColor = [UIColor bgColor];
        _mineTableView.tableFooterView = [[UIView alloc] init];
        _mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (@available(iOS 11.0, *)) {
            _mineTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _mineTableView;
}


@end
