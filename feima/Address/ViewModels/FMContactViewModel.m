//
//  FMContactViewModel.m
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMContactViewModel.h"

//通讯录
static NSString * const api_customer_phone = @"rest/customer/phone";
static NSString * const api_employee_phone = @"rest/employee/phone";

@interface FMContactViewModel ()

@property (nonatomic,strong) NSMutableArray *contactsArray;


@end

@implementation FMContactViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contactsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark 获取员工通讯录数据
- (void)loadEmployeeContactsDataWithPage:(FMPageModel *)pageModel
                                complete:(AdpaterComplete)complete {
   NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    parameters[@"pageSize"] = @(pageModel.pageSize);
    [[HttpRequest sharedInstance] postWithUrl:api_employee_phone parameters:parameters complete:^(BOOL isSuccess, id data, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 客户通讯录
- (void)loadCustomerContactsDataWithPage:(FMPageModel *)pageModel
                                  action:(NSString *)action
                                complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    parameters[@"pageSize"] = @(pageModel.pageSize);
    if (!kIsEmptyString(action)) {
        parameters[@"action"] = action;
    }
    [[HttpRequest sharedInstance] postWithUrl:api_customer_phone parameters:parameters complete:^(BOOL isSuccess, id data, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

@end
