//
//  FMCustomerVisitModel.h
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"
#import "FMOrderSellModel.h"
#import "FMCustomerModel.h"


@interface FMVisitRecordInfoModel : BaseModel

@property (nonatomic,  copy ) NSString  *address; //位置
@property (nonatomic,  copy ) NSString  *customerAddress;
@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic, assign) double    customerLatitude;
@property (nonatomic, assign) double    customerLongitude;
@property (nonatomic,  copy ) NSString  *customerName;
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic,  copy ) NSString  *employeeName;
@property (nonatomic, assign) NSInteger enterTime;
@property (nonatomic,  copy ) NSString  *gradeName;
@property (nonatomic,  copy ) NSString  *images;
@property (nonatomic, assign) double    latitude;
@property (nonatomic, assign) double    longitude;
@property (nonatomic,  copy ) NSString  *markName;
@property (nonatomic, assign) NSInteger nextVisitPlanId;
@property (nonatomic, assign) NSInteger outTime;
@property (nonatomic,  copy ) NSString  *summary;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic,  copy ) NSString  *typeName;

@end

@interface FMCompeteGoodsModel : BaseModel

@property (nonatomic, assign) NSInteger competeGoodsId;
@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic,  copy ) NSString  *desc;
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic,  copy ) NSString  *goodsName;
@property (nonatomic,  copy ) NSString  *images;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, assign) NSInteger visitRecordId;

@end


@interface FMCustomerStockModel : BaseModel

@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic, assign) NSInteger customerStockId;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic,  copy ) NSString  *goodsName;
@property (nonatomic,  copy ) NSString  *images;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger visitRecordId;

@end

@interface FMCustomerVisitModel : BaseModel


@property (nonatomic, strong) FMCustomerModel                 *customerInfo;
@property (nonatomic, strong) FMVisitRecordInfoModel          *visitRecordInfo;
@property (nonatomic, strong) NSArray <FMOrderSellModel *>    *goodSellInfos;
@property (nonatomic, strong) NSArray <FMCompeteGoodsModel *> *competeGoodsInfos;
@property (nonatomic, strong) NSArray <FMCustomerStockModel *> *customerStockInfos;



@end
