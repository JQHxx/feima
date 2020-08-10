//
//  HttpRequest.m
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "HttpRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "FMLoginViewController.h"
#import "NSUserDefaultsInfos.h"

#define isTrueEnvironment 0

#if isTrueEnvironment
//正式环境
#define kHostTempURL      @"https://cloud.feimawaiqin.com/%@"


#else

//测试环境
#define kHostTempURL      @"http://192.168.0.187:8081/wqoms/%@"

///http://t.feimawaiqin.com:9000/

#endif

@implementation HttpRequest

static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

#pragma mark 初始化
- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                {
                    // 位置网络
                    MyLog(@"位置网络");
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    // 无法联网
                    MyLog(@"无法联网");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    // WIFI
                    MyLog(@"当前在WIFI网络下");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    // 手机自带网络
                    MyLog(@"当前使用的是2G/3G/4G网络");
                }
            }
        }];
    });
    return _instance;
}

#pragma mark -- POST请求 ---
- (void)postWithUrl:(NSString *)url
         parameters:(id)parameters
            success:(void (^)(id))success
            failure:(void (^)(NSString *))failure {
    NSString *urlStr = [NSString stringWithFormat:kHostTempURL,url];
    MyLog(@"url:%@,params:%@",urlStr,parameters);
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 响应
    manager.requestSerializer.timeoutInterval = 30;
    // 设置自动管理Cookies
    manager.requestSerializer.HTTPShouldHandleCookies = NO;
    // 如果已有Cookie, 则把你的cookie符
    
    NSString *cookie = [NSUserDefaultsInfos getValueforKey:@"Cookie"];
    NSDictionary *headers;
    if (cookie != nil) {
        headers = @{@"Cookie":cookie};
        MyLog(@"headers:%@",headers);
    }
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 请求
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];

    [manager POST:urlStr parameters:parameters headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        MyLog(@"html:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        id json=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        MyLog(@"json:%@",json);
        if ([[json objectForKey:@"code"] isKindOfClass:[NSNumber class]]) {
            NSInteger status=[[json objectForKey:@"code"] integerValue];
            NSString *message=[json objectForKey:@"msg"];
            if (status==200) {
                //获取 Cookie
                NSHTTPURLResponse* response = (NSHTTPURLResponse* )task.response;
                NSDictionary *allHeaderFieldsDic = response.allHeaderFields;
                MyLog(@"allHeaderFieldsDic:%@",allHeaderFieldsDic);
                NSString *setCookie = allHeaderFieldsDic[@"Set-Cookie"];
                if (setCookie != nil) {
                    NSString *cookie = [[setCookie componentsSeparatedByString:@";"] objectAtIndex:0];
                    MyLog(@"cookie : %@", cookie);
                    [NSUserDefaultsInfos putKey:@"Cookie" andValue:cookie];
                }
                success(json);
            }else{
                if (status == -1379) {
                    MyLog(@"%@",message);
                    [NSUserDefaultsInfos removeObjectForKey:kUserTypeKey];
                    [NSUserDefaultsInfos putKey:kLoginStateKey andValue:[NSNumber numberWithBool:NO]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        appDelegate.window.rootViewController = [[FMLoginViewController alloc] init];
                    });
                }else{
                    message=kIsEmptyString(message)?@"暂时无法访问，请稍后再试":message;
                    MyLog(@"postWithUrl:%@,error:%@",urlStr,message);
                    failure(message);
                }
            }
        }else{
            NSString *message = @"暂时无法访问，请稍后再试";
            failure(message);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"postWithUrl:%@,error:%@",urlStr,error);
        failure(error.localizedDescription);
    }];
}

#pragma mark -- GET请求 ---
- (void)getRequestWithUrl:(NSString *)url
                  success:(void (^)(id))success
                  failure:(void (^)(NSString *))failure {
    NSString *urlStr = [NSString stringWithFormat:kHostTempURL,url];
    MyLog(@"url:%@",urlStr);
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 响应
    manager.requestSerializer.timeoutInterval = 30;
    // 设置自动管理Cookies
    manager.requestSerializer.HTTPShouldHandleCookies = NO;
//    // 如果已有Cookie, 则把你的cookie符上
    NSString *cookie = [NSUserDefaultsInfos getValueforKey:@"Cookie"];
    NSDictionary *headers;
    if (cookie != nil) {
        headers = @{@"Cookie":cookie};
        MyLog(@"headers:%@",headers);
    }
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 请求
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager GET:urlStr parameters:nil headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"html:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        id json=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        MyLog(@"json:%@",json);
        if ([[json objectForKey:@"code"] isKindOfClass:[NSNumber class]]) {
            NSInteger status=[[json objectForKey:@"code"] integerValue];
            NSString *message=[json objectForKey:@"msg"];
            if (status==200) {
                success(json);
            }else{
                if (status == -1379) {
                    MyLog(@"%@",message);
                    [NSUserDefaultsInfos removeObjectForKey:kUserTypeKey];
                    [NSUserDefaultsInfos putKey:kLoginStateKey andValue:[NSNumber numberWithBool:NO]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        appDelegate.window.rootViewController = [[FMLoginViewController alloc] init];
                    });
                }else{
                    message=kIsEmptyString(message)?@"暂时无法访问，请稍后再试":message;
                    MyLog(@"error:%@",message);
                    failure(message);
                }
            }
        }else{
            NSString *message = @"暂时无法访问，请稍后再试";
            failure(message);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"postWithUrl:%@,error:%@",urlStr,error);
        failure(error.localizedDescription);
    }];
}

@end
