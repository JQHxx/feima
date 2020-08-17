//
//  HttpRequest.m
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "HttpRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "NSUserDefaultsInfos.h"

#define isTrueEnvironment 0

#if isTrueEnvironment
//正式环境
#define kHostTempURL      @"https://cloud.feimawaiqin.com%@"


#else

//测试环境
#define kHostTempURL      @"http://t.feimawaiqin.com:9000%@"

#endif

@interface HttpRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic,  copy ) RequstCompleteBlock complteBlock;

@end

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
        
        self.manager =[AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 响应
        self.manager.requestSerializer.timeoutInterval = 30;
        // 设置自动管理Cookies
        self.manager.requestSerializer.HTTPShouldHandleCookies = NO;
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 请求
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        //无条件的信任服务器上的证书
        AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
        // 客户端是否信任非法证书
        securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        securityPolicy.validatesDomainName = NO;
        self.manager.securityPolicy = securityPolicy;
    
    });
    return _instance;
}

#pragma mark -- POST请求 ---
- (void)postWithUrl:(NSString *)url
         parameters:(id)parameters
           complete:(RequstCompleteBlock)complete {
    NSString *urlStr = [NSString stringWithFormat:kHostTempURL,url];
    MyLog(@"url:%@,params:%@",urlStr,parameters);
    // 如果已有Cookie, 则把你的cookie符
    NSString *cookie = [NSUserDefaultsInfos getValueforKey:@"Cookie"];
    NSDictionary *headers;
    if (cookie != nil) {
        headers = @{@"Cookie":cookie};
    }
    self.complteBlock = complete;
    [self.manager POST:urlStr parameters:parameters headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([url isEqualToString:api_login]) { //获取 Cookie
            NSHTTPURLResponse* response = (NSHTTPURLResponse* )task.response;
            NSDictionary *allHeaderFieldsDic = response.allHeaderFields;
            NSString *setCookie = allHeaderFieldsDic[@"Set-Cookie"];
            if (setCookie != nil) {
                NSString *cookie = [[setCookie componentsSeparatedByString:@";"] objectAtIndex:0];
                [NSUserDefaultsInfos putKey:@"Cookie" andValue:cookie];
            }
        }
        [self requestSuccessHandleWithResponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"postWithUrl:%@,error:%@",urlStr,error);
        complete(NO,nil,error);
    }];
}

#pragma mark -- GET请求 ---
- (void)getRequestWithUrl:(NSString *)url
               parameters:(id)parameters
                 complete:(RequstCompleteBlock)complete {
    NSString *urlStr = [NSString stringWithFormat:kHostTempURL,url];
    MyLog(@"url:%@,params:%@",urlStr,parameters);
    NSString *cookie = [NSUserDefaultsInfos getValueforKey:@"Cookie"];
    NSDictionary *headers;
    if (cookie != nil) {
        headers = @{@"Cookie":cookie};
    }
    self.complteBlock = complete;
    [self.manager GET:urlStr parameters:parameters headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessHandleWithResponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"postWithUrl:%@,error:%@",urlStr,error);
        complete(NO,nil,error);
    }];
}

#pragma mark 上传图片
- (void)uploadFileRequestWithUrl:(NSString *)url
                           image:(UIImage *)image
                      parameters:(id)parameters
                        complete:(RequstCompleteBlock)complete {
    NSString *urlStr = [NSString stringWithFormat:kHostTempURL,url];
    MyLog(@"url:%@,params:%@",urlStr,parameters);
    NSString *cookie = [NSUserDefaultsInfos getValueforKey:@"Cookie"];
    NSDictionary *headers;
    if (cookie != nil) {
        headers = @{@"Cookie":cookie};
    }
    self.complteBlock = complete;
    [self.manager POST:urlStr parameters:parameters headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:data name:@"file" fileName:@"1.png" mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self requestSuccessHandleWithResponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"postWithUrl:%@,error:%@",urlStr,error);
        complete(NO,nil,error);
    }];
}

#pragma mark -- Private methods
#pragma mark 请求成功处理
- (void)requestSuccessHandleWithResponseObject:(id)responseObject {
//  MyLog(@"html:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    id json=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    MyLog(@"json:%@",json);
    NSInteger status = [json safe_integerForKey:@"code"];
    BOOL isSuccess = status == 200;
    NSError *error;
    if (status==200) {
        self.complteBlock(isSuccess, json, error);
    } else {
        error = [NSError errorWithDomain:@"api_error_code" code:[json safe_integerForKey:@"code"] userInfo:@{ NSLocalizedDescriptionKey:[json safe_stringForKey:@"msg"]}];
        MyLog(@"error:%@",error);
        self.complteBlock(NO, nil, error);
        if (status == -1379 || status == -1378) { //帐号被挤退
            [[FeimaManager sharedFeimaManager] logout];
        }
    }
}

@end
