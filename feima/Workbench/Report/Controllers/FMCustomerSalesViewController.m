//
//  FMCustomerSalesViewController.m
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerSalesViewController.h"
#import "FMCustomerSalesTableViewCell.h"
#import "FMCustomerSalesHeadView.h"
#import "FMCustomerSalesViewModel.h"
#import "FMCustomerSalesModel.h"

@interface FMCustomerSalesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FMCustomerSalesHeadView  *headView;
@property (nonatomic, strong) UITableView              *reportTableView;
@property (nonatomic, strong) FMCustomerSalesViewModel *adapter;
@property (nonatomic, assign) NSInteger selTime;
@property (nonatomic, assign) NSInteger selOrganizationId;

@end

@implementation FMCustomerSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"客户销售报表";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
    
    NSString *currentTime = [NSDate currentYearMonthWithFormat:@"yyyy-MM-dd"];
    self.selTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:currentTime format:@"yyyy-MM-dd"];
    self.selOrganizationId = 0;
    
    [self.view addSubview:self.reportTableView];
    [self loadCustomerSalesData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfCustomerSalesReportList];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-18, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"客户名称",@"跟进人",@"上月销量",@"本月销量",@"同比"];
    for (NSInteger i=0; i<arr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kCustomerSalesWidth*i, 10, kCustomerSalesWidth, 30)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont mediumFontWithSize:14];
        [aView addSubview:btn];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreen_Width-16, 1)];
    line.backgroundColor = [UIColor lineColor];
    [aView addSubview:line];
    
    [aView setCircleCorner:UIRectCornerTopLeft|UIRectCornerTopRight radius:4.0];
    
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMCustomerSalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMCustomerSalesTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMCustomerSalesModel *model = [self.adapter getCustomerSalesReportWithIndex:indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark -- Private methods
#pragma mark load Data
- (void)loadCustomerSalesData {
    NSString *orgId = self.selOrganizationId > 0 ? [NSString stringWithFormat:@"%ld",self.selOrganizationId] : nil;
    kSelfWeak;
    [self.adapter loadCustomerSalesReportWithTime:self.selTime organizationIds:orgId complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.reportTableView reloadData];
            FMCustomerDataModel *model = weakSelf.adapter.customerData;
            weakSelf.headView.valueStr = [NSString stringWithFormat:@"%ld/%ld",model.addCustomer,model.customerSum];
        } else {
            [weakSelf.view makeToast:weakSelf.adapter.errorString duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark -- Getters
#pragma mark 头部视图
- (FMCustomerSalesHeadView *)headView {
    if (!_headView) {
        _headView = [[FMCustomerSalesHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-16, 230)];
        kSelfWeak;
        _headView.selDateBlock = ^(NSInteger time) {
            weakSelf.selTime = time;
            [weakSelf loadCustomerSalesData];
        };
        _headView.selOrganiztionBlock = ^(NSInteger organizationId) {
            weakSelf.selOrganizationId = organizationId;
            [weakSelf loadCustomerSalesData];
        };
    }
    return _headView;
}

#pragma mark 销售报表
- (UITableView *)reportTableView {
    if (!_reportTableView) {
        _reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(8, kNavBar_Height, kScreen_Width-16, kScreen_Height-kNavBar_Height) style:UITableViewStylePlain];
        _reportTableView.delegate = self;
        _reportTableView.dataSource = self;
        _reportTableView.showsVerticalScrollIndicator = NO;
        _reportTableView.tableFooterView = [[UIView alloc] init];
        _reportTableView.backgroundColor = [UIColor whiteColor];
        _reportTableView.layer.cornerRadius = 4;
        _reportTableView.clipsToBounds = YES;
        _reportTableView.separatorInset = UIEdgeInsetsZero;
        _reportTableView.tableHeaderView = self.headView;
        [_reportTableView registerClass:[FMCustomerSalesTableViewCell class] forCellReuseIdentifier:[FMCustomerSalesTableViewCell identifier]];
    }
    return _reportTableView;
}

- (FMCustomerSalesViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMCustomerSalesViewModel alloc] init];
    }
    return _adapter;
}


@end
