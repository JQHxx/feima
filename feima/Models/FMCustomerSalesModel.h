//
//  FMCustomerSalesModel.h
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMCustomerSalesModel : BaseModel

@property (nonatomic, assign) NSInteger  customerId;
@property (nonatomic,  copy ) NSString   *customerName;
@property (nonatomic, assign) NSInteger  followUpPeopleId;
@property (nonatomic,  copy ) NSString   *followUpPeopleName;
@property (nonatomic, assign) NSInteger  lastSales;
@property (nonatomic, assign) double     progress;
@property (nonatomic, assign) NSInteger  thisSales;

@end

NS_ASSUME_NONNULL_END
