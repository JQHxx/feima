//
//  FMSaleModel.h
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMSalesModel : BaseModel

@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic,  copy ) NSString  *employeeName;
@property (nonatomic, assign) double    lastSales;
@property (nonatomic, assign) NSInteger progress;
@property (nonatomic, assign) double    thisSales;
@property (nonatomic, assign) NSInteger organizationId;
@property (nonatomic,  copy ) NSString  *organizationName;

@end

NS_ASSUME_NONNULL_END
