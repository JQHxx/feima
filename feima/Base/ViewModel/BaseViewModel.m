//
//  BaseViewModel.m
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

#pragma mark
+ (NSInteger)pageSize{
    return 15;
}

#pragma mark 是否还有更多数据
- (BOOL)hasMoreData{
    return NO;
}

#pragma mark 是否为空数据
- (BOOL)isEmpty{
    return YES;
}

#pragma mark 错误码
- (FMErrorType)errorType {
    return self.apiErrorType;
}

#pragma mark 错误提示
- (NSString *)errorString {
    if (!kIsEmptyString(self.apiErrorString)) {
        return self.apiErrorString;
    }
    return nil;
}

#pragma mark 处理错误
- (void)handlerError:(NSError *)error {
    if (error) {
        if (error.code == NSURLErrorNotConnectedToInternet) {
            self.apiErrorString = @"操作失败，请检查网络连接";
            self.apiErrorType = ERROR_NET;
        } else if (error.code == NSURLErrorTimedOut) {
            self.apiErrorString = @"网络错误，请检查网络后重试";
            self.apiErrorType = ERROR_NET;
        } else if (error.code == 401 || error.code == 403 || error.code == 404) {
            self.apiErrorString = @"404";
             self.apiErrorType = ERROR_NET;
        } else if (error.code == 500) {
            self.apiErrorType = ERROR_SERVER;
            self.apiErrorString = kServerErrorTips;
        } else if (error.code == 4011 ||
                 error.code == 4012 ||
                 error.code == 4013 ){
            self.apiErrorType = ERROR_Auth;
            self.apiErrorString = [error.userInfo safe_stringForKey:NSLocalizedDescriptionKey];
        } else {
            self.apiErrorType = ERROR_COMMON;
            self.apiErrorString = [error.userInfo safe_stringForKey:NSLocalizedDescriptionKey];
        }
    } else {
        self.apiErrorString = @"";
        self.apiErrorType = UNERROR;
    }
}


@end
