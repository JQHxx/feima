//
//  FMDailyReportTableView.m
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDailyReportTableView.h"
#import "FMDailyHeadView.h"
#import "FMDailyTableViewCell.h"
#import "SlideMenuView.h"
#import "FMAttendanceViewModel.h"

@interface FMDailyReportTableView ()<UITableViewDelegate,UITableViewDataSource,SlideMenuViewDelegate>

@property (nonatomic, strong) FMDailyHeadView       *headView;
@property (nonatomic, strong) SlideMenuView         *menuView;
@property (nonatomic, strong) FMAttendanceViewModel *adapter;
@property (nonatomic, assign) NSInteger             selTime;
@property (nonatomic, assign) NSInteger             selOrganizationId;
@property (nonatomic, assign) NSInteger             currentIndex;

@end

@implementation FMDailyReportTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [[UIView alloc] init];
        [self registerClass:[FMDailyTableViewCell class] forCellReuseIdentifier:[FMDailyTableViewCell identifier]];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        self.separatorInset = UIEdgeInsetsZero;
        self.tableHeaderView = self.headView;
        
        NSString *currentTime = [NSDate currentYearMonthWithFormat:@"yyyy-MM-dd"];
        self.selTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:currentTime format:@"yyyy-MM-dd"];
        self.selOrganizationId = 0;
        self.currentIndex = 0;
        
        [self loadDailyData];
    }
    return self;
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfDailyReportList];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-18, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    aView.userInteractionEnabled = YES;
//    [aView setCircleCorner:UIRectCornerTopLeft|UIRectCornerTopRight radius:4.0];
    [aView addSubview:self.menuView];
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMDailyTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.currentIndex > 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    FMDailyReportModel *model = [self.adapter getDailyReportWithIndex:indexPath.row];
    [cell fillContentWithData:model index:self.currentIndex];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndex < 3) {
        FMDailyReportModel *model = [self.adapter getDailyReportWithIndex:indexPath.row];
        if ([self.viewDelegate respondsToSelector:@selector(dailyReportTableViewDidSelectedRowWithModel:)]) {
            [self.viewDelegate dailyReportTableViewDidSelectedRowWithModel:model];
        }
    }
}

#pragma mark SlideMenuViewDelegate
- (void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index {
    self.currentIndex = index;
    [self.adapter loadAttendanceDailyReportDataWithIndex:index];
    [self reloadData];
}

#pragma mark -- Private methods
#pragma mark loadData
- (void)loadDailyData {
    NSString *orgId = self.selOrganizationId > 0 ? [NSString stringWithFormat:@"%ld",self.selOrganizationId] : nil;
    kSelfWeak;
    [self.adapter loadAttendanceDailyReportWithTime:self.selTime organizationIds:orgId complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.adapter loadAttendanceDailyReportDataWithIndex:weakSelf.currentIndex];
            [weakSelf.headView fillDataWithFigure:weakSelf.adapter.figureData statusModel:weakSelf.adapter.punchStatusData];
            [weakSelf reloadData];
        } else {
            [weakSelf makeToast:weakSelf.adapter.errorString duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


#pragma mark -- Getters
#pragma mark 头部
- (FMDailyHeadView *)headView {
    if (!_headView) {
        _headView = [[FMDailyHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-16, 300)];
        kSelfWeak;
        _headView.selDateBlock = ^(NSInteger time) {
            weakSelf.selTime = time;
            [weakSelf loadDailyData];
        };
        _headView.selOrganiztionBlock = ^(NSInteger organizationId) {
            weakSelf.selOrganizationId = organizationId;
            [weakSelf loadDailyData];
        };
    }
    return _headView;
}

- (SlideMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[SlideMenuView alloc] initWithFrame:CGRectMake(0, 5, kScreen_Width-18, 40) btnTitleFont:[UIFont regularFontWithSize:14] color:[UIColor colorWithHexString:@"#666666"] selColor:[UIColor colorWithHexString:@"#333333"]];
        _menuView.btnCapWidth = 10;
        _menuView.lineWidth = 40.0;
        _menuView.selectTitleFont = [UIFont mediumFontWithSize:16.0f];
        _menuView.myTitleArray = [NSMutableArray arrayWithArray:@[@"全部",@"上班",@"下班",@"打卡异常",@"未打卡"]];
        _menuView.currentIndex = 0;
        _menuView.delegate = self;
    }
    return _menuView;
}

- (FMAttendanceViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMAttendanceViewModel alloc] init];
    }
    return _adapter;
}


@end
