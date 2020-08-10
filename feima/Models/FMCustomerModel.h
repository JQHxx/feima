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

@property (nonatomic,  copy ) NSString  *address;
@property (nonatomic, assign) NSInteger area;
@property (nonatomic,  copy ) NSString  *contactName;
@property (nonatomic,  copy ) NSString  *businessName;
@property (nonatomic,  copy ) NSString  *companyPhone;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic,  copy ) NSString  *customerSource;
@property (nonatomic,  copy ) NSString  *customerSourceName;
@property (nonatomic,  copy ) NSString  *customerStatus;
@property (nonatomic,  copy ) NSString  *customerStatusName;
@property (nonatomic, assign) NSInteger displayArea;
@property (nonatomic,  copy ) NSString  *displayFee;
@property (nonatomic,  copy ) NSString  *distance;
@property (nonatomic,  copy ) NSString  *doorPhoto;
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic,  copy ) NSString  *employeeName;
@property (nonatomic,  copy ) NSString  *fax;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic,  copy ) NSString  *gradeName;
@property (nonatomic,  copy ) NSString  *industryName;
@property (nonatomic, assign) NSInteger industryType;
@property (nonatomic,  copy ) NSString  *latitude;
@property (nonatomic,  copy ) NSString  *longitude;
@property (nonatomic,  copy ) NSString  *monthVisit;
@property (nonatomic,  copy ) NSString  *nickName;
@property (nonatomic,  copy ) NSString  *pathName;
@property (nonatomic,  copy ) NSString  *pathType;
@property (nonatomic, assign) NSInteger progress;
@property (nonatomic,  copy ) NSString  *progressName;
@property (nonatomic,  copy ) NSString  *statusName;
@property (nonatomic, assign) NSInteger telephone;
@property (nonatomic,  copy ) NSString  *threeDayVisit;
@property (nonatomic,  copy ) NSString  *visit;
@property (nonatomic,  copy ) NSString  *visitCode;
@property (nonatomic,  copy ) NSString  *website;
@property (nonatomic,  copy ) NSString  *weekVisit;


@end

NS_ASSUME_NONNULL_END
