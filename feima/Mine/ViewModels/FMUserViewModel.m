//
//  FMUserViewModel.m
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMUserViewModel.h"

@implementation FMUserViewModel

#pragma mark 修改密码
- (void)updateUserPasswordWithOldPassword:(NSString *)oldPassword
                                 password:(NSString *)password
                                  account:(NSString *)account
                                 complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oldPassword"] = oldPassword;
    parameters[@"password"] = password;
    parameters[@"account"] = account;
    [[HttpRequest sharedInstance] postWithUrl:api_user_update_password parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 修改手机号
- (void)updateUserTelephoneWithTelephone:(NSString *)telephone
                                 account:(NSString *)account
                                complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"telephone"] = telephone;
    parameters[@"account"] = account;
    [[HttpRequest sharedInstance] postWithUrl:api_user_update_telephone parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

@end
