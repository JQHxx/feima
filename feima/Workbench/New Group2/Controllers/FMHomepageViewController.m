//
//  FMHomepageViewController.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMHomepageViewController.h"

@interface FMHomepageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titlesArr;
}

@property (nonatomic, strong) UIButton        *statisticsBtn;
@property (nonatomic, strong) UITableView     *mainTableView;

@end

@implementation FMHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"客户主页";
    
    titlesArr = @[@"客户拜访",@"商品销售",@"库存上报",@"竞品上报"];
    
    [self setupUI];
}


#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = titlesArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark 界面初始化
- (void)setupUI {
    [self.view addSubview:self.statisticsBtn];
    [self.statisticsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(kStatusBar_Height+6);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
}

#pragma mark -- Getters
#pragma mark 筛选
- (UIButton *)statisticsBtn {
    if (!_statisticsBtn) {
        _statisticsBtn = [[UIButton alloc] init];
        [_statisticsBtn setTitle:@"统计" forState:UIControlStateNormal];
        [_statisticsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _statisticsBtn.titleLabel.font = [UIFont mediumFontWithSize:14];
    }
    return _statisticsBtn;
}

#pragma mark 客户列表
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
    }
    return _mainTableView;
}

@end
