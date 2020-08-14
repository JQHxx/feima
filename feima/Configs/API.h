//
//  API.h
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#ifndef API_h
#define API_h

//*********************用户相关**********************/

static NSString * const api_login = @"/rest/login";  //登录
static NSString * const api_logout = @"/rest/logout";  //退出登录
static NSString * const api_menu_list = @"/rest/menu/list"; //菜单权限

//********************员工相关*************************/
static NSString * const api_employee_phone = @"/rest/employee/phone";  //员工通讯录
static NSString * const api_employee_list = @"/rest/employee/list";  //员工列表


//********************客户相关*************************/
static NSString * const api_customer_phone = @"/rest/customer/phone";  //客户通讯录
static NSString * const api_customer_list = @"/rest/customer/list";  //客户列表



//********************组织结构相关*************************/
static NSString * const api_organization_list = @"/rest/organization/list"; //组织结构列表

//********************工作路线相关*************************/
static NSString * const api_workRoute_history_list = @"/rest/workroute/history/list"; //历史路线
static NSString * const api_workRoute_employee_list = @"/rest/workroute/employee/list"; //员工分布


//********************指令相关*************************/
static NSString * const api_instruction_release_list = @"/rest/instruction/instructionlist"; //下达指令列表
static NSString * const api_instruction_accept_list = @"/rest/instruction/instructionrecordlist"; //接受指令列表
static NSString * const api_instruction_add = @"/rest/instruction/add"; //下达指令
static NSString * const api_instruction_update = @"/rest/instruction/update"; //修改指令

//********************进销存相关*************************/
static NSString * const api_orderGoods_distribution_list = @"/rest/ordergoods/distribution/list"; //查询配货列表


//********************商品相关*************************/
static NSString * const api_goods_list = @"/rest/goods/list"; //商品列表

//********************公司相关*************************/
static NSString * const api_company_list = @"/rest/company/list"; //公司列表

//********************报表相关*************************/
static NSString * const api_report_employee_sales = @"/rest/report/employee/sales"; //员工销售报表

#endif /* API_h */
