//
//  Defines.h
//  feima
//
//  Created by fei on 2020/7/29.
//  Copyright © 2020 hegui. All rights reserved.
//

#ifndef Defines_h
#define Defines_h


#endif /* Defines_h */

#define IOS13_OR_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13.0)

/*************屏幕尺寸相关*********************/
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define KScreen_Scale    ([UIScreen mainScreen].scale)

//状态栏高度
#ifdef IOS13_OR_LATER
#define kStatusBar_Height ([UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height)
#else
#define kStatusBar_Height ([[UIApplication sharedApplication] statusBarFrame].size.height)
#endif

#define kNavBar_Height (kStatusBar_Height > 20 ? 88 : 64)
#define kTabBar_Height (kStatusBar_Height > 20 ? 83 : 49)
#define kSafeAreaInsetBottom (kStatusBar_Height > 20 ? 34 : 0)


/*****************数据类型判断*******************/
//字符串为空判断
#define kIsEmptyString(s)       (s == nil || [s isKindOfClass:[NSNull class]] || ([s isKindOfClass:[NSString class]] && s.length == 0))
//对象为空判断
#define kIsEmptyObject(obj)     (obj == nil || [obj isKindOfClass:[NSNull class]])
//字典类型判断
#define kIsDictionary(objDict)  (objDict != nil && [objDict isKindOfClass:[NSDictionary class]])
//数组类型判断
#define kIsArray(objArray)      (objArray != nil && [objArray isKindOfClass:[NSArray class]])


// keyWindow
#define kKeyWindow [[UIApplication sharedApplication] delegate].window

//block weakself
#define kSelfWeak     __weak typeof(self) weakSelf = self
//block strongself
#define kSelfStrong  __strong typeof(self) strongSelf = self
//调试
#ifdef DEBUG
#define MyLog(...) NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif


#define ImageNamed(fp) [UIImage imageNamed:fp]

#define RGB(r,g,b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.0]

#define kReportWidth (kScreen_Width-16)/4.0

///自定义数据
#define kMinMonth @"2019-08"
#define kIndustryTypeKey       @"IndustryType"   //行业类型
#define kCustomerLevelKey      @"CustomerLevel"     //客户等级
#define kFollowUpProgressKey   @"FollowUpProgress"   //跟进进度
