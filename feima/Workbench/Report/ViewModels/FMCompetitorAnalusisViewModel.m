//
//  FMCompetitorAnalusisViewModel.m
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCompetitorAnalusisViewModel.h"

@interface FMCompetitorAnalusisViewModel ()

@property (nonatomic, copy ) NSArray <FMCompetitorDataModel *> *competitorDataList;

@end

@implementation FMCompetitorAnalusisViewModel

#pragma mark 竞品分析报表
- (void)loadCompetitorAnalysisReportWithTime:(NSInteger)time
                             organizationIds:(NSString *)organizationIds
                                    complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"time"] = @(time);
    if (!kIsEmptyString(organizationIds)) {
        parameters[@"organizationIds"] = organizationIds;
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_report_compete_analysis parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSDictionary *data = [json safe_objectForKey:@"data"];
            //数据分析统计
            NSArray *salesData = [data safe_objectForKey:@"competitiveProductAnalysisData"];
            self.competitorAnalysisList = [NSArray yy_modelArrayWithClass:[FMCompetitorAnalysisModel class] json:salesData];
            
            //报表
            NSArray *list = [data safe_objectForKey:@"tables"];
            self.competitorDataList = [NSArray yy_modelArrayWithClass:[FMCompetitorDataModel class] json:list];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 报表数量
- (NSInteger)numberOfCompetitorDataReportList {
    return self.competitorDataList.count;
}


#pragma mark 报表对象
- (FMCompetitorDataModel *)getCompetitorDataReportWithIndex:(NSInteger)index {
    FMCompetitorDataModel *model = [self.competitorDataList safe_objectAtIndex:index];
    return model;
}


@end
