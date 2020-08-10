//
//  FMProductReportViewController.m
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMProductReportViewController.h"
#import "FMReportHeadView.h"
#import "FMProductTableViewCell.h"
#import "FMGoodsSalesModel.h"


@interface FMProductReportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FMReportHeadView *headView;
@property (nonatomic, strong) UITableView      *salesTableView;

@property (nonatomic, strong) NSMutableArray *reportArray;

@end

@implementation FMProductReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"员工产品销售报表";
    
     self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
    
    [self setupUI];
    [self loadData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-18, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kReportWidth, 30)];
    titleLab.text = self.type == 1 ? @"部门": @"业务员";
    titleLab.font = [UIFont mediumFontWithSize:14];
    titleLab.textColor = [UIColor textBlackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [aView addSubview:titleLab];
    
    UIView *aLine = [[UIView alloc] initWithFrame:CGRectMake(titleLab.right-1, 0, 1, 50)];
    aLine.backgroundColor = [UIColor lineColor];
    [aView addSubview:aLine];
    
    NSArray *arr = @[@"品名",@"上月销量(占比)",@"本月销量(占比)"];
    for (NSInteger i=0; i<arr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(titleLab.right+kReportWidth*i, 10, kReportWidth, 30)];
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
    FMProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMProductTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMEmployeeGoodsModel * model = self.reportArray[indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMEmployeeGoodsModel * model = self.reportArray[indexPath.row];
    return [FMProductTableViewCell getCellHeightWithModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark -- Private methods
#pragma mark load data
- (void)loadData {
    NSArray *arr = @[@"黄稀薄",@"刘海涛",@"叶翠红",@"方伟"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<arr.count; i++) {
        FMEmployeeGoodsModel *employee = [[FMEmployeeGoodsModel alloc] init];
        employee.employeeName = arr[i];
        
        NSMutableArray *goodsArr = [[NSMutableArray alloc] init];
        NSArray *goodsNames = @[@"和成天下蓝",@"和成天下红",@"青果"];
        for (NSInteger j=0; j<goodsNames.count; j++) {
            FMGoodsSalesModel *model = [[FMGoodsSalesModel alloc] init];
            model.goodsName = goodsNames[j];
            model.lastSales = (i+1)*10445.0;
            model.thisSales = (i+1)*24445.0;
            model.progress = (i+1)*12;
            [goodsArr addObject:model];
        }
        employee.goods = goodsArr;
        [tempArr addObject:employee];
    }
    self.reportArray = tempArr;
    [self.salesTableView reloadData];
    
    NSMutableArray *tempGoodsArr = [[NSMutableArray alloc] init];
    NSArray *names = @[@"和成天下",@"青果"];
    for (NSInteger i=0; i<names.count; i++) {
        FMGoodsSalesModel *model = [[FMGoodsSalesModel alloc] init];
        model.goodsName = names[i];
        model.sales = 0.3;
        model.progress = 0.2;
        model.salesSum = 1.5;
        [tempGoodsArr addObject:model];
    }
    
    FMSalesDataModel *salesData = [[FMSalesDataModel alloc] init];
    salesData.lastSalesSum = 0.34;
    salesData.thisSalesSum = 0.22;
    salesData.progress = 0.22/0.34;
    
    [self.headView displayViewWithGoodsData:tempGoodsArr salesData:salesData];
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.salesTableView];
    [self.salesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-16, kScreen_Height-kNavBar_Height));
    }];
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
- (UITableView *)salesTableView {
    if (!_salesTableView) {
        _salesTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _salesTableView.delegate = self;
        _salesTableView.dataSource = self;
        _salesTableView.showsVerticalScrollIndicator = NO;
        _salesTableView.tableFooterView = [[UIView alloc] init];
        _salesTableView.backgroundColor = [UIColor whiteColor];
        _salesTableView.layer.cornerRadius = 4;
        _salesTableView.clipsToBounds = YES;
        _salesTableView.separatorInset = UIEdgeInsetsZero;
        [_salesTableView registerClass:[FMProductTableViewCell class] forCellReuseIdentifier:[FMProductTableViewCell identifier]];
        _salesTableView.tableHeaderView = self.headView;
    }
    return _salesTableView;
}

- (NSMutableArray *)reportArray {
    if (!_reportArray) {
        _reportArray = [[NSMutableArray alloc] init];
    }
    return _reportArray;
}

@end
