//
//  FMSaleReportViewController.m
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSaleReportViewController.h"
#import "FMReportHeadView.h"
#import "FMSalesReportTableViewCell.h"
#import "FMSalesViewModel.h"
#import "FMSalesModel.h"
#import "FMTimeDataModel.h"
#import "FMSalesDataModel.h"

@interface FMSaleReportViewController ()<UITableViewDelegate,UITableViewDataSource,FMReportHeadViewDelegate>

@property (nonatomic, strong) FMReportHeadView *headView;
@property (nonatomic, strong) UITableView      *salesTableView;
@property (nonatomic, strong) FMSalesViewModel *adapter;

@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;

@end

@implementation FMSaleReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"销售报表";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
    
    //获取默认开始结束时间
    NSString *currentDate = [NSDate currentDateTimeWithFormat:@"yyyy-MM-dd"];
    NSArray *days = [[FeimaManager sharedFeimaManager] getMonthFirstAndLastDayWithDate:currentDate format:@"yyyy-MM-dd"];
    NSString *firstDay = [days firstObject];
    self.startTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:firstDay format:@"yyyy-MM-dd"];
    self.endTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:currentDate format:@"yyyy-MM-dd"];
    
    [self setupUI];
    [self loadSalesData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfSalesReportList];
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
    
    NSArray *arr = @[@"上月销量",@"本月销量",@"完成进度"];
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
    FMSalesReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMSalesReportTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMSalesModel *model = [self.adapter getSalesReportWithIndex:indexPath.row];
    [cell fillContentWithData:model type:self.type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark -- Delegate
#pragma mark FMReportHeadViewDelegate
- (void)reportHeadViewDidSelectedMonthWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime {
    self.startTime = startTime;
    self.endTime = endTime;
    [self loadSalesData];
}

#pragma mark -- Private methods
#pragma mark load data
- (void)loadSalesData {
    kSelfWeak;
    [self.adapter loadSalesReportWithType:self.type startTime:self.startTime endTime:self.endTime complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.salesTableView reloadData];
            if (weakSelf.type == 0) {
                [weakSelf.headView displayViewWithTimeData:weakSelf.adapter.timeDataModel];
            } else {
                [weakSelf.headView displayViewWithTimeData:weakSelf.adapter.timeDataModel salesData:weakSelf.adapter.salesDataModel];
            }
        } else {
            [weakSelf.view makeToast:weakSelf.adapter.errorString duration:1.5 position:CSToastPositionCenter];
        }
    }];
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
        _headView = [[FMReportHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-16, 210)];
        _headView.delegate = self;
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
        [_salesTableView registerClass:[FMSalesReportTableViewCell class] forCellReuseIdentifier:[FMSalesReportTableViewCell identifier]];
        _salesTableView.tableHeaderView = self.headView;
    }
    return _salesTableView;
}

- (FMSalesViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMSalesViewModel alloc] init];
    }
    return _adapter;
}

@end
