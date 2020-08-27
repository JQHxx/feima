//
//  FMOwnGoodsModel.h
//  feima
//
//  Created by fei on 2020/8/26.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMOwnGoodsModel : BaseModel

@property (nonatomic, assign) NSInteger employeeGoodsId;
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, assign) NSInteger totalStock;

@end

NS_ASSUME_NONNULL_END
