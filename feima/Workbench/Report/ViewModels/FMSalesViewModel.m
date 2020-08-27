//
//  FMSalesViewModel.m
//  feima
//
//  Created by fei on 2020/8/26.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSalesViewModel.h"

@interface FMSalesViewModel ()

@property (nonatomic, copy ) NSArray *salesList;

@end

@implementation FMSalesViewModel


- (void)loadSalesReportWithType:(NSInteger)type
                      startTime:(NSInteger)sTime
                        endTime:(NSInteger)eTime
                       complete:(AdpaterComplete)complete {
    NSString *url = type == 0 ? api_report_employee_sales : api_report_organization_sales;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sTime"] = @(sTime);
    parameters[@"eTime"] = @(eTime);
    [[HttpRequest sharedInstance] getRequestWithUrl:url parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSDictionary *data = [json safe_objectForKey:@"data"];
            //数据统计
            NSDictionary *salesData = [data safe_objectForKey:@"salesData"];
            self.salesDataModel = [FMSalesDataModel yy_modelWithJSON:salesData];
            
            //时间统计
            NSDictionary *timeData = [data safe_objectForKey:@"timeData"];
            self.timeDataModel = [FMTimeDataModel yy_modelWithJSON:timeData];
            
            //报表
            NSArray *list = [data safe_objectForKey:@"tables"];
            self.salesList = [NSArray yy_modelArrayWithClass:[FMSalesModel class] json:list];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 报表数
- (NSInteger)numberOfSalesReportList {
    return self.salesList.count;
}

#pragma mark 报表对象
- (FMSalesModel *)getSalesReportWithIndex:(NSInteger)index {
    FMSalesModel *model = [self.salesList safe_objectAtIndex:index];
    return model;
}

@end
