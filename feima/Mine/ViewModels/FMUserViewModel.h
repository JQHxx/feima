//
//  FMUserViewModel.h
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"

@interface FMUserViewModel : BaseViewModel

/**
 *  修改密码
 *
 *  @param oldPassword 旧密码
 *  @param password 新密码
 *  @param account 帐号
 *  @param complete  请求成功
*/
- (void)updateUserPasswordWithOldPassword:(NSString *)oldPassword
                                 password:(NSString *)password
                                  account:(NSString *)account
                                 complete:(AdpaterComplete)complete;

/**
 *  修改手机号
 *
 *  @param telephone 手机号
 *  @param account 帐号
 *  @param complete  请求成功
*/
- (void)updateUserTelephoneWithTelephone:(NSString *)telephone
                                 account:(NSString *)account
                                complete:(AdpaterComplete)complete;

@end

