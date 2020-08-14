//
//  FMOrganizationViewModel.m
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMOrganizationViewModel.h"



@interface FMOrganizationViewModel ()

@property (nonatomic,strong) NSMutableArray *employeesArray;
@property (nonatomic,strong) NSMutableArray *organiztionsArray;
@property (nonatomic,strong) FMPageModel    *employeePage;

@end


@implementation FMOrganizationViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.organiztionsArray = [[NSMutableArray alloc] init];
        self.employeesArray = [[NSMutableArray alloc] init];
        self.employeePage = [[FMPageModel alloc] init];
    }
    return self;
}

#pragma mark 组织结构列表
- (void)loadOrganizationBeansWithPage:(FMPageModel *)pageModel
                                  pid:(NSInteger)pid
                                 name:(NSString *)name
                             complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    parameters[@"pageSize"] = @(pageModel.pageSize);
    parameters[@"pid"] = @(pid);
    if (!kIsEmptyString(name)) {
        parameters[@"name"] = name;
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_organization_list parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            self.employeePage.total = [json safe_integerForKey:@"total"];
            
            NSDictionary *data = [json safe_objectForKey:@"data"];
            //组织
            NSArray *orgBeans = [data safe_objectForKey:@"organizationBeans"];
            NSArray *orgArr = [NSArray yy_modelArrayWithClass:[FMOrganizationModel class] json:orgBeans];
            [self.organiztionsArray removeAllObjects];
            [self.organiztionsArray addObjectsFromArray:orgArr];
            
            //客户
            NSArray *empBeans = [data safe_objectForKey:@"employeeBeans"];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FMEmployeeModel class] json:empBeans];
            if (pageModel.pageNum == 1) {
                [self.employeesArray removeAllObjects];
            }
            [self.employeesArray addObjectsFromArray:arr];
            
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 返回组织数
- (NSInteger)numberOfOrgnazitionsList {
    return self.organiztionsArray.count;
}

#pragma mark 返回组织对象
- (FMOrganizationModel *)getOrganizationModelWithIndex:(NSInteger)index {
    FMOrganizationModel *model = [self.organiztionsArray safe_objectAtIndex:index];
    return model;
}

#pragma mark 组织数组为空
- (BOOL)isOrganizationEmpty {
    return self.organiztionsArray.count == 0;
}

#pragma mark 返回员工数
- (NSInteger)numberOfEmployeeList {
    return self.employeesArray.count;
}

#pragma mark 返回员工对象
- (FMEmployeeModel *)getEmployeeModelWithIndex:(NSInteger)index {
    FMEmployeeModel *model = [self.employeesArray safe_objectAtIndex:index];
    return model;
}

#pragma mark 员工数组为空
- (BOOL)isEmployeeEmpty {
    return self.employeesArray.count == 0;
}

#pragma mark 是否更多
- (BOOL)hasMoreData {
    if(self.employeePage && self.employeesArray.count > 0) {
        return self.employeePage.total > self.employeesArray.count;
    }
    return NO;
}


@end
