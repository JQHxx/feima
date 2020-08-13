//
//  BaseViewModel.h
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMPageModel.h"
#import "NSArray+Safety.h"
#import "NSDictionary+Safety.h"

typedef NS_ENUM(NSInteger, FMErrorType) {
    UNERROR = 0x00,         //没有报错
    ERROR_SERVER = 0x01,    //500  正常提示用户
    ERROR_NET = 0x10,       //网络测试404 超时  400/401  正常提示用户 toast
    ERROR_PARAM = 0x11,     //接口参数验证报错  正常提示用户 toast
    ERROR_Auth = 0x100,     //用户使用权限错误，需要重新登录
    ERROR_COMMON = 0x110,   //普通错误，正常提示用户 toast
    ERROR_LOGOUT = 0x111,   //帐号被挤退
};


typedef void (^AdpaterComplete)(BOOL isSuccess);

#define kNetErrorTips @"网络错误，稍后重试"
#define kServerErrorTips @"服务器偷懒啦，稍后重试"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewModel : NSObject

@property(nonatomic,strong) NSString    *apiErrorString;
@property(nonatomic,assign) FMErrorType apiErrorType;

/**
 * pageSize
 */
+ (NSInteger)pageSize;

/**
 * 是否还有更多数据
 */
- (BOOL)hasMoreData;

/**
 * 是否为空数据
 */
- (BOOL)isEmpty;

/**
 * 错误码
 */
- (FMErrorType)errorType;

/**
 * 错误提示
 */
- (NSString*)errorString;

/**
 * 处理错误
 */
-(void)handlerError:(NSError*)error;

@end

NS_ASSUME_NONNULL_END
