//
//  FMCustomerSalesViewController.m
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerSalesViewController.h"
#import "FMReportHeadView.h"
#import "FMCustomerSalesModel.h"


#define kMyWidth (kScreen_Width-16)/5.0
@interface FMCustomerSalesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FMReportHeadView *headView;
@property (nonatomic, strong) UITableView      *reportTableView;
@property (nonatomic, strong) NSMutableArray   *reportArray;

@end

@implementation FMCustomerSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = self.isCustomerSales ? @"客户销售报表" : @"竞品分析报表";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
    
    [self.view addSubview:self.reportTableView];
    
    [self loadCustomerSalesData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-18, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"客户名称",@"跟进人",@"上月销量",@"本月销量",@"同比"];
    for (NSInteger i=0; i<arr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kMyWidth*i, 10, kMyWidth, 30)];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FMCustomerSalesTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FMCustomerSalesModel *goods = self.reportArray[indexPath.row];
    NSArray *arr = @[goods.customerName,goods.followUpPeopleName,[NSString stringWithFormat:@"%ld",goods.lastSales],[NSString stringWithFormat:@"%ld",goods.thisSales],[NSString stringWithFormat:@"%.f%%",goods.progress]];
    for (NSInteger i=0; i<arr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kMyWidth*i, 10, kMyWidth, 24)];
        lab.font = [UIFont mediumFontWithSize:14];
        lab.textColor = [UIColor colorWithHexString:@"#666666"];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = arr[i];
        [cell.contentView addSubview:lab];
    }

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
    NSArray *arr = @[@"芙蓉兴盛",@"锦和天下",@"京东小店",@"苏宁小店",@"天猫超市",@"咖啡厅",@"芙蓉兴盛",@"罗马超市"];
    NSArray *names = @[@"黄稀薄",@"刘海涛",@"叶翠红",@"方伟",@"张利兴",@"张利兴",@"黄稀薄",@"刘海涛"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<arr.count; i++) {
        FMCustomerSalesModel *model = [[FMCustomerSalesModel alloc] init];
        model.customerName = arr[i];
        model.followUpPeopleName = names[i];
        model.lastSales = (i+1)*10445.0;
        model.thisSales = (i+1)*24445.0;
        model.progress = (i+1);
        [tempArr addObject:model];
    }
    self.reportArray = tempArr;
    [self.reportTableView reloadData];
    
    if (self.isCustomerSales) {
        FMCustomerDataModel *model = [[FMCustomerDataModel alloc] init];
        model.addCustomer = 80;
        model.customerSum = 120;
        
        [self.headView displayViewWithCustomerData:model];
    } else {
        [self.headView displayViewWithCompetitorData];
    }
}

#pragma mark -- Getters
#pragma mark 头部视图
- (FMReportHeadView *)headView {
    if (!_headView) {
        _headView = [[FMReportHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-16, 200)];
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
        [_reportTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FMCustomerSalesTableViewCell"];
    }
    return _reportTableView;
}

- (NSMutableArray *)reportArray {
    if (!_reportArray) {
        _reportArray = [[NSMutableArray alloc] init];
    }
    return _reportArray;
}

@end
