//
//  HttpRequest.h
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequstCompleteBlock)(BOOL isSuccess,id data, NSError* error);

@interface HttpRequest : NSObject


+ (instancetype)sharedInstance;

/**
 *  发送post请求
 *
 *  @param url  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param complete    请求完成的回调
 *
*/
- (void)postWithUrl:(NSString *)url
         parameters:(id)parameters
           complete:(RequstCompleteBlock)complete;

/**
 *  发送get请求
 *
 *  @param url  请求的网址字符串
 *  @param complete    请求完成的回调
 *  
*/
- (void)getRequestWithUrl:(NSString *)url
            complete:(RequstCompleteBlock)complete;

//退出登录
- (void)logoutActionWithMessage:(NSString *)mssage;

@end
