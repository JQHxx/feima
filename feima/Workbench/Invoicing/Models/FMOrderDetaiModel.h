//
//  FMOrderDetaiModel.h
//  feima
//
//  Created by fei on 2020/8/25.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"
#import "FMGoodsModel.h"
#import "FMOrderGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMOrderDetaiModel : BaseModel

@property (nonatomic, strong) FMGoodsModel *goods;
@property (nonatomic, strong) FMOrderGoodsModel *orderGoodsDetail;

@end

NS_ASSUME_NONNULL_END
