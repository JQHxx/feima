//
//  HttpRequest.h
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject


+ (instancetype)sharedInstance;

/**
 *  发送post请求
 *
 *  @param url  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
*/
- (void)postWithUrl:(NSString *)url
         parameters:(id)parameters
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSString *errorStr))failure;

/**
 *  发送get请求
 *
 *  @param url  请求的网址字符串
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
*/
- (void)getRequestWithUrl:(NSString *)url
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSString *errorStr))failure;

@end
