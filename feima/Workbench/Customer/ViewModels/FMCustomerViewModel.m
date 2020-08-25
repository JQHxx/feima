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
                        latitude:(double)latitude
                       longitude:(double)longitude
                     contactName:(NSString *)contactName
                       visitCode:(NSInteger)visitCode
                        complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    if (pageModel.pageSize > 0) {
        parameters[@"pageSize"] = @(pageModel.pageSize);
    }
    if (latitude > 0 && longitude > 0) {
        parameters[@"latitude"] = @(latitude);
        parameters[@"longitude"] = @(longitude);
    }
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
                         customerId:(NSInteger)customerId
                       businessName:(NSString *)businessName
                           nickName:(NSString *)nickName
                        contactName:(NSString *)contactName
                          telephone:(NSString *)telephone
                            address:(NSString *)address
                           latitude:(double)latitude
                          longitude:(double)longitude
                          doorPhoto:(NSArray *)images
                       industryType:(NSInteger)industryType
                              grade:(NSInteger)grade
                        displayArea:(NSString *)displayArea
                           progress:(NSInteger)progress
                         employeeId:(NSInteger)employeeId
                           complete:(AdpaterComplete)complete {
    NSString *url = type == 1 ? api_customer_update : api_customer_add;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (customerId > 0) {
        parameters[@"customerId"] = @(customerId);
    }
    parameters[@"businessName"] = businessName;
    if (!kIsEmptyString(nickName)) {
        parameters[@"nickName"] = nickName;
    }
    parameters[@"contactName"] = contactName;
    parameters[@"telephone"] = telephone;
    parameters[@"address"] = address;
    parameters[@"longitude"] = @(longitude);
    parameters[@"latitude"] = @(latitude);
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

#pragma mark 客户移动
- (void)transferCustomerWithfromId:(NSInteger)fromId
                              toId:(NSInteger)toId
                          complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"fromId"] = @(fromId);
    parameters[@"toId"] = @(toId);
    [[HttpRequest sharedInstance] getRequestWithUrl:api_customer_transfer parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
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

#pragma mark 插入客户数据
- (void)insertCustomersList:(NSArray *)customerList {
    [self.customersArray removeAllObjects];
    [self.customersArray addObjectsFromArray:customerList];
}

#pragma mark 筛选
- (void)filterCustomersWithVisitCode:(NSInteger)code{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (FMCustomerModel *model in self.customersArray) {
        if (model.visitCode == code) {
            [tempArr addObject:model];
        }
    }
    self.customersArray = tempArr;
}

#pragma mark 搜索
- (void)seachCustomersWithKeyword:(NSString *)word {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (FMCustomerModel *model in self.customersArray) {
        if ([model.businessName containsString:word] || [model.contactName containsString:word] || [model.telephone containsString:word] ) {
            [tempArr addObject:model];
        }
    }
    self.customersArray = tempArr;
    self.customersArray = tempArr;
}

@end
