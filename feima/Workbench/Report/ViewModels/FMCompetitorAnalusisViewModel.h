//
//  FMCompetitorAnalusisViewModel.h
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMCompetitorDataModel.h"

@interface FMCompetitorAnalusisViewModel : BaseViewModel

@property (nonatomic, copy ) NSArray <FMCompetitorAnalysisModel *> *competitorAnalysisList;

/**
 *  竞品分析报表
 *
 *  @param time  当日时间
 *  @param organizationIds  指定部门 逗号分隔
 *  @param complete  请求成功
*/
- (void)loadCompetitorAnalysisReportWithTime:(NSInteger)time
                             organizationIds:(NSString *)organizationIds
                                    complete:(AdpaterComplete)complete;

/*
 * 报表数量
 */
- (NSInteger)numberOfCompetitorDataReportList;

/*
 * 报表对象
*/
- (FMCompetitorDataModel *)getCompetitorDataReportWithIndex:(NSInteger)index;

@end

