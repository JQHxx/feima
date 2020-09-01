//
//  Libkey.h
//  feima
//
//  Created by fei on 2020/7/29.
//  Copyright © 2020 hegui. All rights reserved.
//

#ifndef Libkey_h
#define Libkey_h

/**
 *第三方key或secret
 */
static NSString * const key_baidu_ak = @"bUUtr1Oberp1DULkTlt5xvoAXABwLVIO";
static NSUInteger const key_baidu_service_id = 223007;
//填写你在API控制台申请iOS类型AK时指定的Bundle Identifier
static NSString * const key_budle_identifier = @"com.vision.feima";

/*
 * 自定义key
 */
static NSString * const kLoginStateKey = @"com.hegui.feima.login.state.key";
static NSString * const kUserBeanKey = @"com.hegui.feima.user.bean.key";
static NSString * const kLoginAccountKey = @"com.hegui.feima.login.account.key";

//数据
static NSString * const kMenuListDataKey = @"com.hegui.feima.menu.list.key";
static NSString * const kIndustryGroupDataKey = @"com.hegui.feima.group.industry.key";
static NSString * const kLevelGroupDataKey = @"com.hegui.feima.group.level.key";
static NSString * const kProgressGroupDataKey = @"com.hegui.feima.group.progress.key";
//部门
static NSString * const kOrganizationGroupDataKey = @"com.hegui.feima.group.organization.key";

//通知中心
static NSString * const kUpdatePasswordSuccessNotification = @"com.hegui.feima.notication.update.password";

#endif /* Libkey_h */
