//
//  FMEmployeeRouteViewModel.m
//  feima
//
//  Created by fei on 2020/8/31.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMEmployeeRouteViewModel.h"

@interface FMEmployeeRouteViewModel ()

@property (nonatomic,strong) NSArray *routeList;

@end

@implementation FMEmployeeRouteViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark 员工工作路线列表
- (void)loadEmployeeWorkRouteListWithAction:(NSString *)action complete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] getRequestWithUrl:api_workRoute_employee_list parameters:@{@"action":@"visit"} complete:^(BOOL isSuccess, id json, NSError *error) {
        
    }];
}


@end
