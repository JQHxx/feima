//
//  FMClockInRecordViewController.m
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMClockInRecordViewController.h"
#import "FMPunchRecordHeadView.h"
#import "FMPunchRecordBottomView.h"
#import "FMPunchRecordTableViewCell.h"
#import "FMClockInViewModel.h"
#import "CustomDatePickerView.h"

@interface FMClockInRecordViewController ()<UITableViewDelegate,UITableViewDataSource,FMPunchRecordHeadViewDelegate,FMPunchRecordBottomViewDelegate>

@property (nonatomic, strong) FMPunchRecordHeadView *headView;
@property (nonatomic, strong) UITableView *recordsTableView;
@property (nonatomic, strong) FMPunchRecordBottomView *bottomView;
@property (nonatomic, strong) FMClockInViewModel *adapter;

@property (nonatomic, copy ) NSString *selMonth;
@property (nonatomic, copy ) NSString *selStatus;

@end


@implementation FMClockInRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selMonth = [NSDate currentYearMonthWithFormat:@"yyyy-MM"];
    self.selStatus = @"";
    self.baseTitle = @"打卡记录";
    
    [self setupUI];
    [self loadRecordsData];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfPunchRecordsData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"日期",@"上班",@"下班"];
    for (NSInteger i=0; i<arr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width/3.0)*i, 10, kScreen_Width/3.0, 30)];
        lab.font = [UIFont mediumFontWithSize:14];
        lab.textColor = [UIColor textBlackColor];
        lab.text = arr[i];
        lab.textAlignment = NSTextAlignmentCenter;
        [aView addSubview:lab];
        
        if (i<2) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width/3.0)*(i+1), 0, 1, 50)];
            line.backgroundColor = [UIColor lineColor];
            [aView addSubview:line];
        }
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreen_Width, 1)];
    line.backgroundColor = [UIColor lineColor];
    [aView addSubview:line];
    
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMPunchRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMPunchRecordTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMPunchRecordModel *model = [self.adapter getRecordModelWithIndex:indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark -- Delegate
#pragma mark FMPunchRecordHeadViewDelegate
#pragma mark 选择状态
- (void)headViewDidSelectedStatus:(NSString *)status {
    self.selStatus = status;
    [self loadRecordsData];
}

#pragma mark FMPunchRecordBottomViewDelegate
#pragma mark 选择月份
- (void)bottomViewDidSelectedMonth {
    kSelfWeak;
    [CustomDatePickerView showDatePickerWithTitle:@"选择月份" defauldValue:self.selMonth minDateStr:kMinMonth maxDateStr:nil resultBlock:^(NSString *selectValue) {
        weakSelf.selMonth = selectValue;
        [weakSelf loadRecordsData];
    }];
}

#pragma mark 前一月、下一月
- (void)bottomViewDidClickActionWithIndex:(NSInteger)index {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *currentDate = [formatter dateFromString:self.selMonth];
        
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    if (index == 0) { //前一月
        [lastMonthComps setMonth:-1];
    } else {
        [lastMonthComps setMonth:1];
    }
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    self.selMonth = [formatter stringFromDate:newdate];
    [self loadRecordsData];
}

#pragma mark -- Private methods
#pragma mark load data
- (void)loadRecordsData {
    [self.adapter loadPunchRecordsDataWithMonth:self.selMonth status:self.selStatus complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [self.headView dispalyViewWithStatusData:self.adapter.statusArray];
            [self.recordsTableView reloadData];
        }
    }];
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(180);
    }];
    
    [self.view addSubview:self.recordsTableView];
    [self.recordsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-190-kTabBar_Height);
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kTabBar_Height+10);
    }];
}

#pragma mark -- Getters
#pragma mark 头部视图
- (FMPunchRecordHeadView *)headView {
    if (!_headView) {
        _headView = [[FMPunchRecordHeadView alloc] init];
        _headView.delegate = self;
    }
    return _headView;
}

#pragma mark 打卡记录
- (UITableView *)recordsTableView {
    if (!_recordsTableView) {
        _recordsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _recordsTableView.delegate = self;
        _recordsTableView.dataSource = self;
        _recordsTableView.showsVerticalScrollIndicator = NO;
        _recordsTableView.tableFooterView = [[UIView alloc] init];
        _recordsTableView.separatorInset = UIEdgeInsetsZero;
        [_recordsTableView registerClass:[FMPunchRecordTableViewCell class] forCellReuseIdentifier:[FMPunchRecordTableViewCell identifier]];
    }
    return _recordsTableView;
}

#pragma mark 底部视图
- (FMPunchRecordBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[FMPunchRecordBottomView alloc] init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (FMClockInViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMClockInViewModel alloc] init];
    }
    return _adapter;
}

@end
