//
//  FMOrderGoodsModel.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMOrderGoodsModel : BaseModel

@property (nonatomic,  copy ) NSString  *amount;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) NSInteger fromEmployeeId; //申请人id
@property (nonatomic, assign) NSInteger orderGoodsId;
@property (nonatomic,  copy ) NSString  *orderType; //DISTRITUTION, RETURN, EXCHANGE （订单类型，分别对应配货，退货，换货）
@property (nonatomic,  copy ) NSString  *remark;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger toEmployeeId; //审批人id

@property (nonatomic, assign) NSInteger applyNum;
@property (nonatomic, assign) NSInteger approveNum;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger orderDetailId;

@end

NS_ASSUME_NONNULL_END
