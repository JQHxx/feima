//
//  FMContactViewModel.m
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMContactViewModel.h"

@interface FMContactViewModel ()

@property (nonatomic,strong) NSMutableArray *employeesArray;
@property (nonatomic,strong) NSMutableArray *customersArray;
@property (nonatomic,strong) FMPageModel    *employeePage;
@property (nonatomic,strong) FMPageModel    *customerPage;


@end

@implementation FMContactViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.employeesArray = [[NSMutableArray alloc] init];
        self.customersArray = [[NSMutableArray alloc] init];
        self.employeePage = [[FMPageModel alloc] init];
        self.customerPage = [[FMPageModel alloc] init];
    }
    return self;
}

#pragma mark 获取员工通讯录数据
- (void)loadEmployeeContactsDataWithPage:(FMPageModel *)pageModel
                                    name:(NSString *)name
                                complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    parameters[@"pageSize"] = @(pageModel.pageSize);
    if (!kIsEmptyString(name)) {
        parameters[@"name"] = name;
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_employee_phone parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (kIsEmptyString(name)) {
                self.employeePage.total = [json safe_integerForKey:@"total"];
            }
            
            NSArray *data = [json safe_objectForKey:@"data"];
            NSArray *emloyeeArr = [NSArray yy_modelArrayWithClass:[FMEmployeeModel class] json:data];
            if (pageModel.pageNum == 1) {
                [self.employeesArray removeAllObjects];
            }
            [self.employeesArray addObjectsFromArray:emloyeeArr];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 客户通讯录
- (void)loadCustomerContactsDataWithPage:(FMPageModel *)pageModel
                             contactName:(NSString *)contactName
                                  action:(NSString *)action
                                complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    parameters[@"pageSize"] = @(pageModel.pageSize);
    if (!kIsEmptyString(contactName)) {
        parameters[@"contactName"] = contactName;
    }
    if (!kIsEmptyString(action)) {
        parameters[@"action"] = action;
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_customer_phone parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
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

#pragma mark 是否更多员工
- (BOOL)hasMoreEmployeeData {
    if(self.employeePage && self.employeesArray.count > 0) {
        return self.employeePage.total > self.employeesArray.count;
    }
    return NO;
}

#pragma mark 员工总数
- (NSInteger)employeeTotalCount {
    return self.employeePage.total;
}

#pragma mark 返回员工数
- (NSInteger)numberOfEmployeesList {
    return self.employeesArray.count;
}

#pragma mark 返回员工对象
- (FMEmployeeModel *)getEmployeeModelWithIndex:(NSInteger)index {
    FMEmployeeModel *model = [self.employeesArray safe_objectAtIndex:index];
    return model;
}

#pragma mark 客户总数
- (NSInteger)customerTotalCount {
    return self.customerPage.total;
}

#pragma mark  返回客户数
- (NSInteger)numberOfCustomersList {
    return self.customersArray.count;
}

#pragma mark   返回客户对象
- (FMCustomerModel *)getCustomerModelWithIndex:(NSInteger)index {
    FMCustomerModel *model = [self.customersArray safe_objectAtIndex:index];
    return model;
}

#pragma mark 是否更多客户
- (BOOL)hasMoreCustomerData {
    if(self.customerPage && self.customersArray.count > 0) {
        return self.customerPage.total > self.customersArray.count;
    }
    return NO;
}


@end
