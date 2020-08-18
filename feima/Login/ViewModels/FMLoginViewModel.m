//
//  FMLoginViewModel.m
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMLoginViewModel.h"
#import "FMUserModel.h"

@implementation FMLoginViewModel

#pragma mark 登录
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                complete:(AdpaterComplete)complete {
    NSDictionary *paraDict = @{
        @"telephone":account,
        @"password": password
    };
    [[HttpRequest sharedInstance] postWithUrl:api_login parameters:paraDict complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSDictionary *data = [json safe_objectForKey:@"data"];
            FMUserBeanModel *userBean = [FMUserBeanModel  yy_modelWithJSON:data[@"userBean"]];
            [NSUserDefaultsInfos putKey:kLoginStateKey andValue:[NSNumber numberWithBool:YES]];
            [NSUserDefaultsInfos putKey:kLoginAccountKey andValue:account];
            [NSUserDefaultsInfos putKey:kUserNameKey andValue:userBean.users.name];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 退出登录
- (void)logoutComplete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] postWithUrl:api_logout parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

@end
