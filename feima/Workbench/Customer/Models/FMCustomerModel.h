//
//  FMCustomerModel.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMCustomerModel : BaseModel

@property (nonatomic,  copy ) NSString  *address; //位置
@property (nonatomic, assign) NSInteger area;  //区域
@property (nonatomic,  copy ) NSString  *contactName;  //联系人
@property (nonatomic,  copy ) NSString  *businessName; //商户名称，为店铺名称
@property (nonatomic,  copy ) NSString  *companyPhone;  //公司电话
@property (nonatomic, assign) NSInteger companyId;  //跟进人
@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic,  copy ) NSString  *customerSource;  //客户来源
@property (nonatomic,  copy ) NSString  *customerSourceName;
@property (nonatomic, assign) NSInteger customerStatus;  //客户状态，0：禁用，1:启用
@property (nonatomic,  copy ) NSString  *customerStatusName;
@property (nonatomic, assign) NSInteger displayArea; //陈列面积
@property (nonatomic,  copy ) NSString  *displayFee;  //陈列费
@property (nonatomic,  copy ) NSString  *distance;
@property (nonatomic,  copy ) NSString  *doorPhoto; //门头照
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic,  copy ) NSString  *employeeName;
@property (nonatomic,  copy ) NSString  *fax;  //传真
@property (nonatomic, assign) NSInteger grade;  //客户等级
@property (nonatomic,  copy ) NSString  *gradeName;
@property (nonatomic,  copy ) NSString  *industryName;
@property (nonatomic, assign) NSInteger industryType; //行业类型
@property (nonatomic,  copy ) NSString  *latitude;   //纬度
@property (nonatomic,  copy ) NSString  *longitude;  //经度
@property (nonatomic,  copy ) NSString  *monthVisit;
@property (nonatomic,  copy ) NSString  *nickName; //客户简称
@property (nonatomic,  copy ) NSString  *pathName;
@property (nonatomic,  copy ) NSString  *pathType;  //通路类型
@property (nonatomic, assign) NSInteger progress;   //进度
@property (nonatomic,  copy ) NSString  *progressName;
@property (nonatomic,  copy ) NSString  *statusName;
@property (nonatomic,  copy ) NSString  *telephone;  //手机号码
@property (nonatomic,  copy ) NSString  *threeDayVisit;
@property (nonatomic, assign) NSInteger visit;
@property (nonatomic, assign) NSInteger visitCode;
@property (nonatomic,  copy ) NSString  *website;  //网址
@property (nonatomic,  copy ) NSString  *weekVisit;


@end

NS_ASSUME_NONNULL_END
