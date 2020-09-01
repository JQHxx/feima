//
//  FMAttendanceViewModel.m
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAttendanceViewModel.h"

@interface FMAttendanceViewModel ()

@property (nonatomic,strong) NSDictionary  *myData;
@property (nonatomic, copy ) NSArray  *menuList;
@property (nonatomic, copy ) NSArray  *dailyData;
@property (nonatomic, copy ) NSArray  *monthyData;


@end

@implementation FMAttendanceViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuList = @[@"allTable",@"punchInTable",@"punchOutTable",@"abnormalTable",@"punchNotTable"];
    }
    return self;
}

#pragma mark 考勤日报表
- (void)loadAttendanceDailyReportWithTime:(NSInteger)time
                          organizationIds:(NSString *)organizationIds
                                 complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"time"] = @(time);
    if (!kIsEmptyString(organizationIds)) {
        parameters[@"organizationIds"] = organizationIds;
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_report_daily_attendance parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            self.myData = [json safe_objectForKey:@"data"];
            //打卡状态人数统计
            NSDictionary *statusDict = [self.myData safe_objectForKey:@"punchStatusNumber"];
            self.punchStatusData = [FMDailyStatusModel yy_modelWithJSON:statusDict];
            //打卡人数/应到人数
            NSDictionary *figureDict = [self.myData safe_objectForKey:@"figure"];
            self.figureData = [FMDailyFigureModel yy_modelWithJSON:figureDict];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 获取日报表列表数据
- (void)loadAttendanceDailyReportDataWithIndex:(NSInteger)index {
    NSString *key = [self.menuList safe_objectAtIndex:index];
    NSArray *data = [self.myData safe_objectForKey:key];
    self.dailyData = [NSArray yy_modelArrayWithClass:[FMDailyReportModel class] json:data];
}

#pragma mark 日报表数量
- (NSInteger)numberOfDailyReportList {
    return self.dailyData.count;
}

#pragma mark 日报表对象
- (FMDailyReportModel *)getDailyReportWithIndex:(NSInteger)index {
    FMDailyReportModel *model = [self.dailyData safe_objectAtIndex:index];
    return model;
}

#pragma mark 考勤月报表
- (void)loadAttendanceMonthyReportWithTime:(NSInteger)time
                           organizationIds:(NSString *)organizationIds
                                  complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"time"] = @(time);
    if (!kIsEmptyString(organizationIds)) {
        parameters[@"organizationIds"] = organizationIds;
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_report_monthly_attendance parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSDictionary *data = [json safe_objectForKey:@"data"];
            NSArray *list = [data safe_objectForKey:@"tables"];
            self.monthyData = [NSArray yy_modelArrayWithClass:[FMMonthyReportModel class] json:list];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 月报表数量
- (NSInteger)numberOfMonthyReportList {
    return self.monthyData.count;
}

#pragma mark 月报表对象
- (FMMonthyReportModel *)getMonthyReportWithIndex:(NSInteger)index {
    FMMonthyReportModel *model = [self.monthyData safe_objectAtIndex:index];
    return model;
}

@end
