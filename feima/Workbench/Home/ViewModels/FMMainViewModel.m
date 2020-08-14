//
//  FMMainViewModel.m
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMainViewModel.h"


@interface FMMainViewModel ()

@property (nonatomic,strong) NSMutableArray *menuList;

@end

@implementation FMMainViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark 获取菜单权限
- (void)loadMenuListComplete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] getRequestWithUrl:api_menu_list parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSArray *data = [json safe_objectForKey:@"data"];
            NSArray *list = [NSArray yy_modelArrayWithClass:[FMWorkbenchModel class] json:data];
            [self getWorkbenchInfoWithMenuData:list];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 返回工作台信息数量
- (NSInteger)numberOfWorkbenchList {
    return self.menuList.count;
}

#pragma mark 返回某一个工作台信息
- (NSDictionary *)getWorkbenchInfoWithIndex:(NSInteger)index {
    NSDictionary *dict = [self.menuList safe_objectAtIndex:index];
    return dict;
}

#pragma mark -- Private methods
#pragma mark 获取工作台信息
- (void)getWorkbenchInfoWithMenuData:(NSArray *)list {
    NSMutableArray *urlsArr = [[NSMutableArray alloc] init];
    for (FMWorkbenchModel *model in list) {
        [urlsArr addObject:model.url];
    }
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    if (urlsArr.count > 0) {
        if ([urlsArr containsObject:api_customer_phone]&&[urlsArr containsObject:api_employee_phone]) {
            [tempArr addObject:@{@"icon":@"contacts",@"name":@"通讯录",@"router":@"Address"}];
        }
        if ([urlsArr containsObject:api_customer_list]) {
            [tempArr addObject:@{@"icon":@"customer",@"name":@"客户管理",@"router":@"Customer"}];
            [tempArr addObject:@{@"icon":@"visit",@"name":@"客户分布",@"router":@"CustomerDistributed"}];
        }
        if ([urlsArr containsObject:api_workRoute_history_list]) {
            [tempArr addObject:@{@"icon":@"work_path",@"name":@"工作路线",@"router":@"WorkRoute"}];
        }
        if ([urlsArr containsObject:api_workRoute_employee_list]) {
            [tempArr addObject:@{@"icon":@"work_path",@"name":@"员工分布",@"router":@"Distributed"}];
        }
        if ([urlsArr containsObject:api_instruction_accept_list]) {
            [tempArr addObject:@{@"icon":@"intructions",@"name":@"指令",@"router":@"Instruction"}];
        }
        if ([urlsArr containsObject:api_orderGoods_distribution_list]) {
            [tempArr addObject:@{@"icon":@"goods",@"name":@"进销存",@"router":@"Invoicing"}];
        }
        if ([urlsArr containsObject:api_employee_list]) {
            [tempArr addObject:@{@"icon":@"employee_manage",@"name":@"员工管理",@"router":@"Employee"}];
        }
        if ([urlsArr containsObject:api_goods_list]) {
            [tempArr addObject:@{@"icon":@"goods_manage",@"name":@"商品管理",@"router":@"Goods"}];
        }
        if ([urlsArr containsObject:api_company_list]) {
            [tempArr addObject:@{@"icon":@"company_manager",@"name":@"公司管理",@"router":@"Company"}];
        }
        [tempArr addObject:@{@"icon":@"company_manager",@"name":@"报表管理",@"router":@"Report"}];
    }
    self.menuList = tempArr;
}

@end
