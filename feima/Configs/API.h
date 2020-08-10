//
//  API.h
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#ifndef API_h
#define API_h

//*****************登录相关***********/
//登录
static NSString * const api_login = @"login";
//退出登录
static NSString * const api_logout = @"logout";
//登录状态
static NSString * const api_login_state = @"user";

//用户相关

//*****************工作台相关***********/
//权限
static NSString * const api_menu_list = @"rest/menu/list";

//通讯录
static NSString * const api_customer_phone = @"rest/customer/phone";
static NSString * const api_employee_phone = @"rest/employee/phone";

//客户管理
static NSString * const api_customer_list = @"rest/customer/list";


#endif /* API_h */
