//
//  AppDelegate.m
//  feima
//
//  Created by fei on 2020/7/29.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "FMLoginViewController.h"
#import <IQKeyboardManager.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>

@interface AppDelegate ()<BMKLocationAuthDelegate,BMKGeneralDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setAppSystemConfig];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    BOOL isLogin = [[NSUserDefaultsInfos getValueforKey:kLoginStateKey] boolValue];
    if (isLogin) {
        self.window.rootViewController = [[MyTabBarController alloc] init];
    } else {
        self.window.rootViewController = [[FMLoginViewController alloc] init];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -- Private Methods
#pragma mark app config
- (void)setAppSystemConfig {
    MyLog(@"setAppSystemConfig");
    //IQKeyboardManager
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES; //键盘弹出时，点击背景，键盘收回
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    keyboardManager.enableAutoToolbar = NO; //隐藏键盘上面的toolBar
    
    //百度地图
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:key_baidu_ak authDelegate:self];
    BOOL ret = [mapManager start:key_baidu_ak generalDelegate:self];
    if (!ret) {
        MyLog(@"Baidu manager start failed!");
    }
}

#pragma mark -- Delegate
#pragma mark BMKGeneralDelegate
#pragma mark 返回网络错误
- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        MyLog(@"联网成功");
    } else {
        MyLog(@"onGetNetworkState %d",iError);
    }
}

#pragma mark 返回授权验证错误
- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        MyLog(@"授权成功");
    } else {
        MyLog(@"onGetPermissionState %d",iError);
    }
}

#pragma mark BMKLocationAuthDelegate
#pragma mark 返回授权验证错误
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    MyLog(@"location auth onGetPermissionState %ld",(long)iError);
}

@end
