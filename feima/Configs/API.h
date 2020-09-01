//
//  API.h
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#ifndef API_h
#define API_h


//*********************上传相关**********************/
static NSString * const api_file_upload = @"/rest/file/upload";  //上传图片

//*********************其他**********************/
static NSString * const api_dict_selectgroup = @"/rest/dict/selectgroup";  //字典下拉框
static NSString * const api_select_organization = @"/rest/select/organization";  //组织机构下拉框
static NSString * const api_select_position = @"/rest/select/position";  //职位下拉框

//*********************用户相关**********************/
static NSString * const api_login = @"/rest/login";  //登录
static NSString * const api_logout = @"/rest/logout";  //退出登录
static NSString * const api_menu_list = @"/rest/menu/list"; //菜单权限
static NSString * const api_user_update_password = @"/rest/user/updatepass"; //修改密码
static NSString * const api_user_update_telephone = @"/rest/user/updatetelephone"; //修改手机号

//********************员工相关*************************/
static NSString * const api_employee_phone = @"/rest/employee/phone";  //员工通讯录
static NSString * const api_employee_list = @"/rest/employee/list";  //员工列表
static NSString * const api_employee_add = @"/rest/employee/add";  //添加员工
static NSString * const api_employee_update = @"/rest/employee/update";  //修改员工
static NSString * const api_employee_enable = @"/rest/employee/enable";  //启用员工
static NSString * const api_employee_disable = @"/rest/employee/disable";  //禁用员工

//*********************打卡相关**********************/
static NSString * const api_punchrecord_time = @"/rest/punchrecord/time";  //打卡时间
static NSString * const api_punchrecord_check_punch = @"/rest/punchrecord/check/punch";  //上班重复打卡验证
static NSString * const api_punchrecord_add_punch = @"/rest/punchrecord/add/punch";  //上班打卡
static NSString * const api_punchrecord_check_punchafter = @"/rest/punchrecord/check/punchafter";  //下班重复打卡验证
static NSString * const api_punchrecord_add_punchafter = @"/rest/punchrecord/add/punchafter";  //下班打卡
static NSString * const api_punchrecord_list = @"/rest/punchrecord/list";   //打卡记录

//********************客户相关*************************/
static NSString * const api_customer_phone = @"/rest/customer/phone";  //客户通讯录
static NSString * const api_customer_list = @"/rest/customer/list";  //客户列表
static NSString * const api_customer_add = @"/rest/customer/add";  //添加客户
static NSString * const api_customer_update = @"/rest/customer/update";  //修改客户
static NSString * const api_customer_transfer = @"/rest/customer/transfer";  //客户移动


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
static NSString * const api_instruction_complete = @"/rest/instruction/summary"; //指令完成 （去总结）

//********************进销存相关*************************/
static NSString * const api_orderGoods_distribution_list = @"/rest/ordergoods/distribution/list"; //查询配货列表
static NSString * const api_orderGoods_detail_list = @"/rest/ordergoodsdetail/list";  // 查询配货详情
static NSString * const api_orderGoods_distribution_apply = @"/rest/ordergoods/distribution/apply"; //申请配货
static NSString * const api_orderGoods_return_apply = @"/rest/ordergoods/return/apply"; //申请退货
static NSString * const api_orderGoods_exchange_apply = @"/rest/ordergoods/exchange/apply"; //申请换货
static NSString * const api_orderGoods_distribution_agree = @"/rest/ordergoods/distribution/agree"; //同意配货
static NSString * const api_orderGoods_distribution_refuse = @"/rest/ordergoods/distribution/refuse"; //拒绝配货
static NSString * const api_orderGoods_distribution_delivery = @"/rest/ordergoods/distribution/delivery"; //发货
static NSString * const api_orderGoods_distribution_confirm = @"/rest/ordergoods/distribution/delivery/confirm"; //配货完成
static NSString * const api_orderGoods_return_agree = @"/rest/ordergoods/return/agree"; //同意退货
static NSString * const api_orderGoods_return_refuse = @"/rest/ordergoods/return/refuse"; //拒绝退货
static NSString * const api_orderGoods_return_delivery = @"/rest/ordergoods/return/delivery"; //退货发货
static NSString * const api_orderGoods_return_confirm = @"/rest/ordergoods/return/delivery/confirm"; //退货完成
static NSString * const api_orderGoods_exchange_agree = @"/rest/ordergoods/exchange/agree"; //同意换货
static NSString * const api_orderGoods_exchange_refuse = @"/rest/ordergoods/exchange/refuse"; //拒绝换货
static NSString * const api_orderGoods_exchange_delivery = @"/rest/ordergoods/exchange/delivery"; //换货发货
static NSString * const api_orderGoods_exchange_confirm = @"/rest/ordergoods/exchange/delivery/confirm"; //换货完成


//********************商品相关*************************/
static NSString * const api_goods_list = @"/rest/goods/list"; //商品列表
static NSString * const api_goods_add = @"/rest/goods/add"; //商品注册
static NSString * const api_goods_update = @"/rest/goods/update"; //修改商品
static NSString * const api_goods_remove = @"/rest/goods/remove"; //删除商品
static NSString * const api_goods_enable = @"/rest/goods/enable"; //商品上架
static NSString * const api_goods_disable = @"/rest/goods/disable"; //商品下架
static NSString * const api_goods_own_list = @"/rest/goods/own/list"; //本品在售商品列表
static NSString * const api_goods_employee_list = @"/rest/goods/employee/list"; //商品列表(权限控制)
static NSString * const api_goods_compete_list = @"/rest/goods/compete/list"; //竞品在售商品列表

//********************公司相关*************************/
static NSString * const api_company_list = @"/rest/company/list"; //公司列表
static NSString * const api_company_add = @"/rest/company/add"; //公司注册
static NSString * const api_company_update = @"/rest/company/update"; //修改公司
static NSString * const api_company_delete = @"/rest/company/delete"; //删除公司

//********************报表相关*************************/
static NSString * const api_report_employee_sales = @"/rest/report/employee/sales"; //员工销售报表
static NSString * const api_report_organization_sales = @"/rest/report/organization/sales"; //部门销售报表
static NSString * const api_report_employee_goods_sales = @"/rest/report/employee/goods/sales"; //员工产品销售报表
static NSString * const api_report_organization_goods_sales = @"/rest/report/organization/goods/sales"; //员工产品销售报表
static NSString * const api_report_daily_attendance = @"/rest/report/daily/attendance"; //考勤日报表
static NSString * const api_report_monthly_attendance = @"/rest/report/monthly/attendance"; //考勤日报表
static NSString * const api_report_customer_sales = @"/rest/report/customer/sales"; //客户销售报表
static NSString * const api_report_compete_analysis = @"/rest/report/compete/analysis"; //竞品分析报表

//********************拜访计划相关*************************/
static NSString * const api_visit_add = @"/rest/visitrecord/add"; //离店，添加拜访记录
static NSString * const api_visit_list = @"/rest/visitrecord/managementlist"; //获取拜访记录
static NSString * const api_visit_get = @"/rest/visitrecord/get";


//********************消息相关*************************/
static NSString * const api_messages_list = @"/rest/messagelist/list"; //消息列表
static NSString * const api_messages_unread_count = @"/rest/messagelist/count"; //未读消息数
static NSString * const api_messages_accepted = @"/rest/messagelist/accepted"; //全部标为已读

#endif /* API_h */
