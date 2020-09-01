//
//  FMMonthyReportTableView.m
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMonthyReportTableView.h"
#import "FMMonthyReportTableViewCell.h"
#import "FMDateToolView.h"
#import "FMMonthyReportModel.h"
#import "FMAttendanceViewModel.h"

#define kMyWidth (kScreen_Width-16)/3.0

@interface FMMonthyReportTableView ()<UITableViewDataSource,UITableViewDelegate,FMDateToolViewDelegate>

@property (nonatomic, strong) UIView                *headView;
@property (nonatomic, strong) FMAttendanceViewModel *adapter;
@property (nonatomic, assign) NSInteger selTime;
@property (nonatomic, assign) NSInteger selOrganizationId;

@end

@implementation FMMonthyReportTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [[UIView alloc] init];
        [self registerClass:[FMMonthyReportTableViewCell class] forCellReuseIdentifier:[FMMonthyReportTableViewCell identifier]];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        self.separatorInset = UIEdgeInsetsZero;
        self.tableHeaderView = self.headView;
        
        NSString *currentTime = [NSDate currentYearMonthWithFormat:@"yyyy-MM"];
        self.selTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:currentTime format:@"yyyy-MM"];
        self.selOrganizationId = 0;
        
        [self loadMonthyReportData];
    }
    return self;
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfMonthyReportList];
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
    FMMonthyReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMMonthyReportTableViewCell identifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMMonthyReportModel *model = [self.adapter getMonthyReportWithIndex:indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark FMDateToolViewDelegate
#pragma mark 设置时间
- (void)dateToolViewDidSelectedDate:(NSString *)date {
    self.selTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:date format:@"yyyy.MM"];
    [self loadMonthyReportData];
}

#pragma mark 选择部门
- (void)dateToolViewDidSelectedOrganizationWithOriganizationId:(NSInteger)organizationId {
    self.selOrganizationId = organizationId;
    [self loadMonthyReportData];
}

#pragma mark -- Private methods
#pragma mark  load data
- (void)loadMonthyReportData {
    NSString *orgId = self.selOrganizationId > 0 ? [NSString stringWithFormat:@"%ld",self.selOrganizationId] : nil;
    [self.adapter loadAttendanceMonthyReportWithTime:self.selTime organizationIds:orgId complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [self reloadData];
        }
    }];
}

#pragma mark -- Getters
#pragma mark 头部
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-20, 80)];
        _headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
        FMDateToolView *dateView = [[FMDateToolView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width-20, 60) type:FMDateToolViewTypeMonth];
        dateView.layer.cornerRadius = 4;
        dateView.clipsToBounds = YES;
        dateView.delegate = self;
        [_headView addSubview:dateView];
    }
    return _headView;
}

- (FMAttendanceViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMAttendanceViewModel alloc] init];
    }
    return _adapter;
}

@end
