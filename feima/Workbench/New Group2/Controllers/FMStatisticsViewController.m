//
//  FMStatisticsViewController.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMStatisticsViewController.h"
#import "FMVisitRecordTableViewCell.h"
#import "FMCustomerHeadView.h"
#import "FMCustomerChartView.h"
#import "FMVisitViewModel.h"

@interface FMStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView          *myTableView;
@property (nonatomic, strong) FMCustomerHeadView   *headView;
@property (nonatomic, strong) FMCustomerChartView  *chartView;
@property (nonatomic, strong) FMVisitViewModel     *adapter;

@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;

@end

@implementation FMStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"数据统计";
    
    //获取默认开始结束时间
    NSString *currentDate = [NSDate currentDateTimeWithFormat:@"yyyy-MM-dd"];
    NSArray *days = [[FeimaManager sharedFeimaManager] getDayFirstAndLastWithDate:currentDate format:@"yyyy-MM-dd HH:mm:ss"];
    self.startTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:[days firstObject] format:@"yyyy-MM-dd HH:mm:ss"];
    self.endTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:[days lastObject] format:@"yyyy-MM-dd HH:mm:ss"];
    
    [self setupUI];
    [self loadVisitRecordData];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfVisitRecordList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMVisitRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMVisitRecordTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMCustomerVisitModel *model = [self.adapter getVisitRecordModelWithIndex:indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

#pragma mark -- Private methods
#pragma mark 获取拜访计划
- (void)loadVisitRecordData {
    kSelfWeak;
    [self.adapter loadVisitRecordDataWithCustomerId:self.customer.customerId sTime:self.startTime eTime:self.endTime complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.myTableView reloadData];
        } else {
            [weakSelf.view makeToast:weakSelf.adapter.errorString duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNavBar_Height);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
}

#pragma mark -- Getters
#pragma mark 头部视图
- (FMCustomerHeadView *)headView {
    if (!_headView) {
        _headView = [[FMCustomerHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 140)];
        [_headView displayViewWithData:self.customer];
    }
    return _headView;
}

#pragma mark 滚动视图
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.estimatedRowHeight = 100;
        _myTableView.rowHeight = UITableViewAutomaticDimension;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.tableHeaderView = self.headView;
        [_myTableView registerClass:[FMVisitRecordTableViewCell class] forCellReuseIdentifier:[FMVisitRecordTableViewCell identifier]];
    }
    return _myTableView;
}

#pragma mark 图表
- (FMCustomerChartView *)chartView {
    if (!_chartView) {
        _chartView = [[FMCustomerChartView alloc] init];
    }
    return _chartView;
}

- (FMVisitViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMVisitViewModel alloc] init];
    }
    return _adapter;
}


@end
