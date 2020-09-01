//
//  FMGoodsSalesViewModel.m
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMGoodsSalesViewModel.h"

@interface FMGoodsSalesViewModel ()

@property (nonatomic, copy ) NSArray *goodsSalesList;

@end

@implementation FMGoodsSalesViewModel

#pragma mark 产品销售报表
- (void)loadGoodsSalesReportWithType:(NSInteger)type
                           startTime:(NSInteger)sTime
                             endTime:(NSInteger)eTime
                            complete:(AdpaterComplete)complete {
    NSString *url = type == 0 ? api_report_employee_goods_sales : api_report_organization_goods_sales;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sTime"] = @(sTime);
    parameters[@"eTime"] = @(eTime);
    [[HttpRequest sharedInstance] getRequestWithUrl:url parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSDictionary *data = [json safe_objectForKey:@"data"];
            //数据统计
            NSDictionary *salesData = [data safe_objectForKey:@"salesData"];
            self.salesData = [FMSalesDataModel yy_modelWithJSON:salesData];
            
            //时间统计
            NSArray *goodsSaleData = [data safe_objectForKey:@"goodsSalesData"];
            self.goodsSalesData = [NSArray yy_modelArrayWithClass:[FMGoodsSalesDataModel class] json:goodsSaleData];
            
            //报表
            NSArray *list = [data safe_objectForKey:@"tables"];
            self.goodsSalesList = [NSArray yy_modelArrayWithClass:[FMGoodsSalesModel class] json:list];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 产品销售报表数量
- (NSInteger)numberOfGoodsSalesReportList {
    return self.goodsSalesList.count;
}

#pragma mark 产品销售报表对象
- (FMGoodsSalesModel *)getGoodsSalesReportWithIndex:(NSInteger)index {
    FMGoodsSalesModel *model = [self.goodsSalesList safe_objectAtIndex:index];
    return model;
}

@end
