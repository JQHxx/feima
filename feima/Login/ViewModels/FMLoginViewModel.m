//
//  FMLoginViewModel.m
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMLoginViewModel.h"
#import "FMUserModel.h"

//登录
static NSString * const api_login = @"login";

@implementation FMLoginViewModel

#pragma mark 登录
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                complete:(AdpaterComplete)complete {
    NSDictionary *paraDict = @{
        @"telephone":account,
        @"password": password
    };
    [[HttpRequest sharedInstance] postWithUrl:api_login parameters:paraDict complete:^(BOOL isSuccess, id data, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            FMUserBeanModel *userBean = [FMUserBeanModel  yy_modelWithJSON:data[@"userBean"]];
            [NSUserDefaultsInfos putKey:kLoginStateKey andValue:[NSNumber numberWithBool:YES]];
            [NSUserDefaultsInfos putKey:kUserTypeKey andValue:@(userBean.type)];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

@end
