//
//  FMReportViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMReportViewController.h"
#import "FMSaleReportViewController.h"
#import "FMProductReportViewController.h"
#import "FMCustomerSalesViewController.h"
#import "FMCompetitorAnalysisViewController.h"
#import "FMAttendanceViewController.h"

@interface FMReportViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray  *titlesArr;
}

@property (nonatomic, assign) NSInteger      postId;
@property (nonatomic, strong) UITableView    *myTableView;

@end

@implementation FMReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"报表管理";
    
    self.postId = [FeimaManager sharedFeimaManager].userBean.users.postId;
    titlesArr = self.postId == 5 ? @[@"个人销售报表",@"客户销售报表",@"员工产品销售报表",@"竞品分析报表"]: @[@"个人销售报表",@"部门销售报表",@"客户销售报表",@"员工产品销售报表",@"部门产品销售报表",@"竞品分析报表",@"考勤报表"];
    
    [self.view addSubview:self.myTableView];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
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
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.postId == 5) { //业务员
        if (indexPath.row == 0) {
            FMSaleReportViewController *saleVC = [[FMSaleReportViewController alloc] init];
            saleVC.type = 0;
            [self.navigationController pushViewController:saleVC animated:YES];
        } else if (indexPath.row == 2) {
            FMProductReportViewController *productVC = [[FMProductReportViewController alloc] init];
            productVC.type = 0;
            [self.navigationController pushViewController:productVC animated:YES];
        } else if (indexPath.row == 3) {
            FMCustomerSalesViewController *salesVC = [[FMCustomerSalesViewController alloc] init];
            [self.navigationController pushViewController:salesVC animated:YES];
        } else {
            FMCompetitorAnalysisViewController *competitorVC = [[FMCompetitorAnalysisViewController alloc] init];
            [self.navigationController pushViewController:competitorVC animated:YES];
        }
    } else {
        if (indexPath.row == 0 || indexPath.row == 1) {
            FMSaleReportViewController *saleVC = [[FMSaleReportViewController alloc] init];
            saleVC.type = indexPath.row;
            [self.navigationController pushViewController:saleVC animated:YES];
        } else if (indexPath.row == 2) {
            FMCustomerSalesViewController *salesVC = [[FMCustomerSalesViewController alloc] init];
            [self.navigationController pushViewController:salesVC animated:YES];
        } else if (indexPath.row == 3 || indexPath.row == 4) {
            FMProductReportViewController *productVC = [[FMProductReportViewController alloc] init];
            productVC.type = indexPath.row - 3;
            [self.navigationController pushViewController:productVC animated:YES];
        } else if (indexPath.row == 5) {
            FMCompetitorAnalysisViewController *competitorVC = [[FMCompetitorAnalysisViewController alloc] init];
            [self.navigationController pushViewController:competitorVC animated:YES];
        } else {
            FMAttendanceViewController *attendanceVC = [[FMAttendanceViewController alloc] init];
            [self.navigationController pushViewController:attendanceVC animated:YES];
        }
    }
}


#pragma mark -- Getters
#pragma mark tableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBar_Height, kScreen_Width, kScreen_Height-kNavBar_Height) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.backgroundColor = [UIColor whiteColor];
    }
    return _myTableView;
}

@end
