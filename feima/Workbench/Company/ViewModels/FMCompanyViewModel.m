//
//  FMCompanyViewModel.m
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCompanyViewModel.h"

@interface FMCompanyViewModel ()

@property (nonatomic,strong) NSMutableArray *companyList;
@property (nonatomic,strong) FMPageModel    *companyPage;

@end

@implementation FMCompanyViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.companyList = [[NSMutableArray alloc] init];
        self.companyPage = [[FMPageModel alloc] init];
    }
    return self;
}

#pragma mark 公司列表
- (void)loadCompanyListWithPage:(FMPageModel *)pageModel
                           name:(NSString *)name
                       complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (pageModel.pageNum > 0) {
        parameters[@"pageNum"] = @(pageModel.pageNum);
    }
    if (pageModel.pageSize > 0) {
        parameters[@"pageSize"] = @(pageModel.pageSize);
    }
    if (!kIsEmptyString(name)) {
        parameters[@"name"] = name;
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_company_list parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            self.companyPage.total = [json safe_integerForKey:@"total"];
            NSArray *data = [json safe_objectForKey:@"data"];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FMCompanyModel class] json:data];
            if (pageModel.pageNum == 1) {
                [self.companyList removeAllObjects];
            }
            [self.companyList addObjectsFromArray:arr];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 添加或修改公司
- (void)addOrUpdateCompanyWithType:(NSInteger)type
                         companyId:(NSInteger)companyId
                              name:(NSString *)name
                             phone:(NSString *)phone
                           address:(NSString *)address
                          complete:(AdpaterComplete)complete {
    NSString *url = type == 1 ? api_company_update : api_company_add;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (companyId > 0) {
        parameters[@"id"] = @(companyId);
    }
    parameters[@"name"] = name;
    parameters[@"phone"] = phone;
    parameters[@"address"] = address;
    [[HttpRequest sharedInstance] postWithUrl:url parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (type == 0) {
                NSDictionary *data = [json safe_objectForKey:@"data"];
                self.companyId = [data safe_integerForKey:@"id"];
            }
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 删除公司
- (void)deleteCompanyWithCompanyId:(NSInteger)companyId complete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] postWithUrl:api_company_delete parameters:@{@"companyId":@(companyId)} complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            FMCompanyModel *selModel;
            for (FMCompanyModel *model in self.companyList) {
                if (model.companyId == companyId) {
                    selModel = model;
                    break;
                }
            }
            [self.companyList removeObject:selModel];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 公司数
- (NSInteger)numberOfCompanyList {
    return self.companyList.count;
}

#pragma mark   返回公司对象
- (FMCompanyModel *)getCompanyModelWithIndex:(NSInteger)index {
    FMCompanyModel *model = [self.companyList safe_objectAtIndex:index];
    return model;
}

#pragma mark 是否还有更多
- (BOOL)hasMoreData {
    if(self.companyPage && self.companyList.count > 0) {
        return self.companyPage.total > self.companyList.count;
    }
    return NO;
}

- (void)replaceCompanyWithNewCompany:(FMCompanyModel *)model {
    NSInteger index = -1;
    for (NSInteger i=0; i<self.companyList.count; i++) {
        FMCompanyModel *aModel = self.companyList[i];
        if (aModel.companyId == model.companyId) {
            index = i;
            break;
        }
    }
    if (index > -1) {
        [self.companyList replaceObjectAtIndex:index withObject:model];
    }
}

#pragma mark 插入公司
- (void)insertCompany:(FMCompanyModel *)model {
    [self.companyList insertObject:model atIndex:0];
}

#pragma mark 选择公司
- (void)didSelectedCompanyWithCompanyId:(NSInteger)companyId {
    for (FMCompanyModel *aModel in self.companyList) {
        if (aModel.companyId == companyId) {
            aModel.isSelected = YES;
        } else {
            aModel.isSelected = NO;
        }
    }
}

@end
