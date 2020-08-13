//
//  FMLoginViewModel.h
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMLoginViewModel : BaseViewModel

/**
 *  登录
 *  @param account 帐号
 *  @param password 密码
 *  @param complete  请求成功
*/
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                complete:(AdpaterComplete)complete;

@end

NS_ASSUME_NONNULL_END
