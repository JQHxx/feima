//
//  FMCustomerViewModel.m
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerViewModel.h"



@interface FMCustomerViewModel ()

@property (nonatomic,strong) FMPageModel    *customerPage;
@property (nonatomic,strong) NSMutableArray *customersArray;

@end

@implementation FMCustomerViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.customerPage = [[FMPageModel alloc] init];
        self.customersArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark 客户列表
- (void)loadCustomerListWithPage:(FMPageModel *)pageModel
                     contactName:(NSString *)contactName
                       visitCode:(NSInteger)visitCode
                        complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    parameters[@"pageSize"] = @(pageModel.pageSize);
    parameters[@"action"] = @"visit";
    if (!kIsEmptyString(contactName)) {
        parameters[@"contactName"] = contactName;
    }
    if (visitCode > 0) {
        parameters[@"visitCode"] = @(visitCode);
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_customer_list parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            self.customerPage.total = [json safe_integerForKey:@"total"];
            NSDictionary *data = [json safe_objectForKey:@"data"];
            if (kIsDictionary(data)) {
                NSArray *customerBeans = [data safe_objectForKey:@"customerBeans"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[FMCustomerModel class] json:customerBeans];
                if (pageModel.pageNum == 1) {
                    [self.customersArray removeAllObjects];
                }
                [self.customersArray addObjectsFromArray:arr];
            }
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 添加或修改客户
- (void)addOrUpdateCustomerWithType:(NSInteger)type
                       businessName:(NSString *)businessName
                           nickName:(NSString *)nickName
                        contactName:(NSString *)contactName
                          telephone:(NSString *)telephone
                            address:(NSString *)address
                          doorPhoto:(NSArray *)images
                       industryType:(NSInteger)industryType
                              grade:(NSInteger)grade
                        displayArea:(NSString *)displayArea
                           progress:(NSInteger)progress
                         employeeId:(NSInteger)employeeId
                           complete:(AdpaterComplete)complete {
    NSString *url = type == 1 ? api_customer_update : api_customer_add;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"businessName"] = businessName;
    if (!kIsEmptyString(nickName)) {
        parameters[@"nickName"] = nickName;
    }
    parameters[@"contactName"] = contactName;
    parameters[@"telephone"] = telephone;
    parameters[@"address"] = address;
    parameters[@"doorPhoto"] = [images componentsJoinedByString:@","];
    parameters[@"industryType"] = @(industryType);
    parameters[@"grade"] = @(grade);
    parameters[@"displayArea"] = displayArea;
    parameters[@"progress"] = @(progress);
    if (employeeId > 0) {
        parameters[@"employeeId"] = @(employeeId);
    }
    [[HttpRequest sharedInstance] postWithUrl:url parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 客户数
- (NSInteger)numberOfCustomerList {
    return self.customersArray.count;
}

#pragma mark   返回客户对象
- (FMCustomerModel *)getCustomerModelWithIndex:(NSInteger)index {
    FMCustomerModel *model = [self.customersArray safe_objectAtIndex:index];
    return model;
}

#pragma mark 是否还有更多
- (BOOL)hasMoreData {
    if(self.customerPage && self.customersArray.count > 0) {
        return self.customerPage.total > self.customersArray.count;
    }
    return NO;
}

@end
