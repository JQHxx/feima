//
//  FMMonthyViewController.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMonthyViewController.h"
#import "FMMonthHeadView.h"
#import "FMMonthyReportModel.h"

#define kMyWidth (kScreen_Width-16)/3.0

@interface FMMonthyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) FMMonthHeadView   *headView;
@property (nonatomic, strong) UITableView        *myTableView;
@property (nonatomic, strong) NSMutableArray     *monthyData;

@end

@implementation FMMonthyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
    
    [self.view addSubview:self.myTableView];
    [self loadMonthyReportData];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.monthyData.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-18, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"姓名",@"上班打卡/异常",@"下班打卡/异常"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FMMonthTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FMMonthyReportModel *model = self.monthyData[indexPath.row];
    NSArray *arr = @[model.employeeName,[NSString stringWithFormat:@"%ld/%ld",model.punchInNumber,model.punchInAbnormalNumber],[NSString stringWithFormat:@"%ld/%ld",model.punchOutNumber,model.punchOutAbnormalNumber]];
    for (NSInteger i=0; i<arr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kMyWidth*i, 10, kMyWidth, 24)];
        lab.font = [UIFont regularFontWithSize:14];
        lab.textColor = [UIColor colorWithHexString:@"#333333"];
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
#pragma mark  load data
- (void)loadMonthyReportData {
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    NSArray *namesArr = @[@"黄稀薄",@"刘海涛",@"叶翠红",@"方伟",@"张利兴",@"张利兴",@"黄稀薄",@"刘海涛",@"叶翠红",@"方伟",@"张利兴",@"张利兴"];
    for (NSInteger i=0; i<namesArr.count; i++) {
        FMMonthyReportModel *model = [[FMMonthyReportModel alloc] init];
        model.employeeName = namesArr[i];
        model.punchInNumber = 20;
        model.punchInAbnormalNumber = 5;
        model.punchOutNumber = 20;
        model.punchOutAbnormalNumber = 0;
        [tempArr addObject:model];
    }
    self.monthyData = tempArr;
    [self.myTableView reloadData];
}

#pragma mark -- Getters
#pragma mark 日期选择
- (FMMonthHeadView *)headView {
    if (!_headView) {
        _headView = [[FMMonthHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-16, 70)];
    }
    return _headView;
}

#pragma mark 月报表
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 0, kScreen_Width-16, kScreen_Height-kNavBar_Height) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView = [[UIView alloc] init];
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FMMonthTableViewCell"];
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.layer.cornerRadius = 4;
        _myTableView.clipsToBounds = YES;
        _myTableView.separatorInset = UIEdgeInsetsZero;
        _myTableView.tableHeaderView = self.headView;
    }
    return _myTableView;
}

- (NSMutableArray *)monthyData {
    if (!_monthyData) {
        _monthyData = [[NSMutableArray alloc] init];
    }
    return _monthyData;
}

@end
