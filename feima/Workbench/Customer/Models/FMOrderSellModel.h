//
//  FMOrderSellModel.h
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"
#import "FMGoodsModel.h"

@interface FMOrderSellDetailModel : BaseModel

@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger orderSellDetailId;
@property (nonatomic, assign) NSInteger orderSellId;
@property (nonatomic, assign) NSInteger visitRecordId;


@end

@interface FMOrderSellModel : BaseModel

@property (nonatomic,strong) FMOrderSellDetailModel *orderSellDetail;
@property (nonatomic,strong) FMGoodsModel           *goods;

@end

