//
//  FMGoodsSalesDataModel.h
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMGoodsSalesModel : BaseModel

@property (nonatomic, assign) NSInteger  goodsId;
@property (nonatomic,  copy ) NSString   *goodsName;
@property (nonatomic, assign) NSInteger  sales;
@property (nonatomic, assign) double     progress;
@property (nonatomic, assign) NSInteger  salesSum;

@property (nonatomic, assign) double  lastSales;
@property (nonatomic, assign) double  lastSalesSum;
@property (nonatomic, assign) double  lastSalesSumProgress;
@property (nonatomic, assign) double  thisSales;
@property (nonatomic, assign) double  thisSalesSum;
@property (nonatomic, assign) double  thisSalesSumProgress;


@end

@interface FMEmployeeGoodsModel : BaseModel

@property (nonatomic, assign) NSInteger  employeeId;
@property (nonatomic,  copy ) NSString   *employeeName;
@property (nonatomic, strong) NSArray <FMGoodsSalesModel *>  *goods;

@end


NS_ASSUME_NONNULL_END
