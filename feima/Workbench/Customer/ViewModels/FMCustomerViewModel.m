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

@end

@implementation FMCustomerViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.customerPage = [[FMPageModel alloc] init];
    }
    return self;
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
    [[HttpRequest sharedInstance] getRequestWithUrl:api_customer_phone parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            self.customerPage.total = [json safe_integerForKey:@"total"];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 客户总数
- (NSInteger)customerTotalCount {
    return self.customerPage.total;
}

@end
