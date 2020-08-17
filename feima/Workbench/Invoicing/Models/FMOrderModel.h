//
//  FMOrderModel.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"
#import "FMEmployeeModel.h"
#import "FMOrderGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMOrderModel : BaseModel

@property (nonatomic, strong) FMEmployeeModel   *employee;
@property (nonatomic, strong) FMOrderGoodsModel *orderGoods;
@property (nonatomic,  copy ) NSString          *toEmployeeName; //审批人


@end

NS_ASSUME_NONNULL_END
