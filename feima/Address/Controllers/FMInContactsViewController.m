//
//  FMInContactsViewController.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInContactsViewController.h"

@interface FMInContactsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView  *contactsTableView;

@end

@implementation FMInContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"组织结构";
    
    [self setupUI];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = ImageNamed(@"company_manager");
    cell.textLabel.text = @"飞马测试";
    cell.detailTextLabel.text = @"68";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

#pragma mark -- Private methods
#pragma mark 界面初始化
- (void)setupUI {
    [self.view addSubview:self.contactsTableView];
    [self.contactsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-50);
    }];
}

#pragma mark -- Getters
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
