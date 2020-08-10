//
//  FMCustomerViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerViewController.h"
#import "FMCustomerTableViewCell.h"
#import "FMCustomerModel.h"

@interface FMCustomerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton    *filterBtn;
@property (nonatomic, strong) UITableView *customerTableView;
@property (nonatomic, strong) NSMutableArray  *customerArray;

@end

@implementation FMCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"客户管理";
    
    [self setupUI];
    [self loadCustomerData];
}
 
#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMCustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMCustomerTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMCustomerModel *model = self.customerArray[indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadCustomerData {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<10; i++) {
        FMCustomerModel *model = [[FMCustomerModel alloc] init];
        model.businessName = @"俊哥铺子";
        model.contactName = @"俊哥";
        model.telephone = 18974022637;
        model.employeeName = @"业务员";
        model.address = @"湖南省长沙市岳麓区文轩路185号靠近成城工业园";
        model.statusName = @"未拜访";
        [tempArr addObject:model];
    }
    self.customerArray = tempArr;
    [self.customerTableView reloadData];
}

#pragma mark 界面初始化
- (void)setupUI {
    [self.view addSubview:self.filterBtn];
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(kStatusBar_Height+6);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    [self.view addSubview:self.customerTableView];
    [self.customerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
}

#pragma mark -- Getters
#pragma mark 筛选
- (UIButton *)filterBtn {
    if (!_filterBtn) {
        _filterBtn = [[UIButton alloc] init];
        [_filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [_filterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _filterBtn.titleLabel.font = [UIFont mediumFontWithSize:12];
    }
    return _filterBtn;
}

#pragma mark 客户列表
- (UITableView *)customerTableView {
    if (!_customerTableView) {
        _customerTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _customerTableView.showsVerticalScrollIndicator = NO;
        _customerTableView.dataSource = self;
        _customerTableView.delegate = self;
        _customerTableView.tableFooterView = [[UIView alloc] init];
        [_customerTableView registerClass:[FMCustomerTableViewCell class] forCellReuseIdentifier:[FMCustomerTableViewCell identifier]];
        _customerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _customerTableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _customerTableView;
}

- (NSMutableArray *)customerArray {
    if (!_customerArray) {
        _customerArray = [[NSMutableArray alloc] init];
    }
    return _customerArray;
}

@end
