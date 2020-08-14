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

#pragma mark 获取员工通讯录数据
- (void)loadEmployeeContactsDataWithPage:(FMPageModel *)pageModel
                                complete:(AdpaterComplete)complete {
   NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    parameters[@"pageSize"] = @(pageModel.pageSize);
    [[HttpRequest sharedInstance] getRequestWithUrl:api_employee_phone parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
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

@end
