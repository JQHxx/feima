//
//  FMSelectGoodsModel.h
//  feima
//
//  Created by fei on 2020/8/26.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"
#import "FMEmployeeModel.h"
#import "FMOwnGoodsModel.h"
#import "FMGoodsModel.h"


@interface FMSelectGoodsModel : BaseModel

@property (nonatomic, strong) FMEmployeeModel *employee;
@property (nonatomic, strong) FMOwnGoodsModel *employeeGoods;
@property (nonatomic, strong) FMGoodsModel *goods;

@end

