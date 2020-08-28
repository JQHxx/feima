//
//  FMCustomerSalesViewModel.m
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerSalesViewModel.h"

@interface FMCustomerSalesViewModel ()

@property (nonatomic, copy ) NSArray <FMCustomerSalesModel *> *salesList;

@end

@implementation FMCustomerSalesViewModel

#pragma mark 客户销售报表
- (void)loadCustomerSalesReportWithTime:(NSInteger)time organizationIds:(NSString *)organizationIds complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"time"] = @(time);
    if (!kIsEmptyString(organizationIds)) {
        parameters[@"organizationIds"] = organizationIds;
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_report_customer_sales parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSDictionary *data = [json safe_objectForKey:@"data"];
            //数据统计
            NSDictionary *salesData = [data safe_objectForKey:@"customerData"];
            self.customerData = [FMCustomerDataModel yy_modelWithJSON:salesData];
            
            //报表
            NSArray *list = [data safe_objectForKey:@"tables"];
            self.salesList = [NSArray yy_modelArrayWithClass:[FMCustomerSalesModel class] json:list];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 客户销售报表数量
- (NSInteger)numberOfCustomerSalesReportList {
    return self.salesList.count;
}

#pragma mark 客户销售报表对象
- (FMCustomerSalesModel *)getCustomerSalesReportWithIndex:(NSInteger)index {
    FMCustomerSalesModel *model = [self.salesList safe_objectAtIndex:index];
    return model;
}

@end
