//
//  FMEmployeeViewModel.m
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMEmployeeViewModel.h"


@interface FMEmployeeViewModel ()

@property (nonatomic,strong) NSMutableArray *employeesArray;
@property (nonatomic,strong) FMPageModel    *employeePage;

@end

@implementation FMEmployeeViewModel


- (instancetype)init {
    self = [super init];
    if (self) {
        self.employeesArray = [[NSMutableArray alloc] init];
        self.employeePage = [[FMPageModel alloc] init];
    }
    return self;
}

#pragma mark 获取员工列表
- (void)loadEmployeeListDataWithPage:(FMPageModel *)pageModel
                                name:(NSString *)name
                              status:(NSInteger)status
                            complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (pageModel.pageNum > 0) {
        parameters[@"pageNum"] = @(pageModel.pageNum);
    }
    if (pageModel.pageSize > 0) {
        parameters[@"pageSize"] = @(pageModel.pageSize);
    }
    parameters[@"status"] = @(status);
    if (!kIsEmptyString(name)) {
        parameters[@"name"] = name;
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_employee_list parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            self.employeePage.total = [json safe_integerForKey:@"total"];
            
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

#pragma mark 添加或修改员工
- (void)addOrUpdateEmployeeWithType:(NSInteger)type
                         employeeId:(NSInteger)employeeId
                               logo:(NSString *)logo
                               name:(NSString *)name
                                sex:(NSInteger)sex
                     organizationId:(NSInteger)organizationId
                             postId:(NSInteger)postId
                          telephone:(NSString *)telephone
                          companyId:(NSInteger)companyId
                           complete:(AdpaterComplete)complete {
    NSString *url = type == 0 ? api_employee_add : api_employee_update;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (employeeId > 0) {
        parameters[@"employeeId"] = @(employeeId);
    }
    parameters[@"logo"] = logo;
    parameters[@"name"] = name;
    parameters[@"sex"] = @(sex);
    parameters[@"organizationId"] = @(organizationId);
    parameters[@"postId"] = @(postId);
    parameters[@"telephone"] = telephone;
    parameters[@"companyId"] = @(companyId);
    [[HttpRequest sharedInstance] postWithUrl:url parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (type == 0) {
                NSDictionary *data = [json safe_objectForKey:@"data"];
                self.employeeId = [data safe_integerForKey:@"id"];
            }
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 员工启用或禁用
- (void)setEmployeeEnable:(BOOL)isEnable
               employeeId:(NSInteger)employeeId
                 complete:(AdpaterComplete)complete {
    NSString *url = isEnable ? api_employee_enable : api_employee_disable;
    [[HttpRequest sharedInstance] postWithUrl:url parameters:@{@"employeeId":@(employeeId)} complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 组织机构
- (void)loadOrganizationDataComplete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] getRequestWithUrl:api_select_organization parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSArray *data = [json safe_objectForKey:@"data"];
            self.organizationArray = [NSArray yy_modelArrayWithClass:[FMOrganizationModel class] json:data];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 职位
- (void)loadPositionDataComplete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] getRequestWithUrl:api_select_position parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSArray *data = [json safe_objectForKey:@"data"];
            self.posisionArray = [NSArray yy_modelArrayWithClass:[FMPositionModel class] json:data];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
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

- (BOOL)hasMoreData {
    if(self.employeePage && self.employeesArray.count > 0) {
        return self.employeePage.total > self.employeesArray.count;
    }
    return NO;
}

#pragma mark 删除员工
- (void)deleteFromListWithEmployee:(FMEmployeeModel *)employee {
    [self.employeesArray removeObject:employee];
}

#pragma mark 替换员工
- (void)replaceEmployeeWithNewGoods:(FMEmployeeModel *)model {
    NSInteger index = -1;
    for (NSInteger i=0; i<self.employeesArray.count; i++) {
        FMEmployeeModel *aModel = self.employeesArray[i];
        if (aModel.employeeId == model.employeeId) {
            index = i;
            break;
        }
    }
    if (index > -1) {
        [self.employeesArray replaceObjectAtIndex:index withObject:model];
    }
}

#pragma mark 插入员工
- (void)insertEmployee:(FMEmployeeModel *)model {
    [self.employeesArray insertObject:model atIndex:0];
}

#pragma mark 选择员工
- (void)didSelectedEmployeeWithEmployeeId:(NSInteger)employeeId{
    for (FMEmployeeModel *aModel in self.employeesArray) {
        if (aModel.employeeId == employeeId) {
            aModel.isSelected = YES;
        } else {
            aModel.isSelected = NO;
        }
    }
}

@end
