//
//  FMAttendanceViewModel.h
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMDailyReportModel.h"
#import "FMMonthyReportModel.h"


@interface FMAttendanceViewModel : BaseViewModel


@property (nonatomic,strong) FMDailyFigureModel *figureData;
@property (nonatomic,strong) FMDailyStatusModel *punchStatusData;

/**
 *  考勤日报表
 *
 *  @param time  当日时间
 *  @param organizationIds  指定部门 逗号分隔
 *  @param complete  请求成功
*/
- (void)loadAttendanceDailyReportWithTime:(NSInteger)time
                          organizationIds:(NSString *)organizationIds
                                 complete:(AdpaterComplete)complete;

/*
 * 日报表列表数据
*/
- (void)loadAttendanceDailyReportDataWithIndex:(NSInteger)index;

/*
 * 日报表数量
 */
- (NSInteger)numberOfDailyReportList;

/*
 * 日报表对象
*/
- (FMDailyReportModel *)getDailyReportWithIndex:(NSInteger)index;

/**
 *  考勤月报表
 *
 *  @param time  当日时间
 *  @param organizationIds  指定部门 逗号分隔
 *  @param complete  请求成功
*/
- (void)loadAttendanceMonthyReportWithTime:(NSInteger)time
                           organizationIds:(NSString *)organizationIds
                                  complete:(AdpaterComplete)complete;

/*
 * 月报表数量
 */
- (NSInteger)numberOfMonthyReportList;

/*
 * 月报表对象
*/
- (FMMonthyReportModel *)getMonthyReportWithIndex:(NSInteger)index;


@end

