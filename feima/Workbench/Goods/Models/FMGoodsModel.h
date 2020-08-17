//
//  FMGoodsModel.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMGoodsModel : BaseModel

@property (nonatomic,  copy ) NSString  *categoryName;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic,  copy ) NSString  *description;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic,  copy ) NSString  *images;
@property (nonatomic,  copy ) NSString  *name;
@property (nonatomic, assign) double    originalPrice;
@property (nonatomic, assign) NSInteger originalStock;
@property (nonatomic, assign) double    price;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic,  copy ) NSString  *unit;



@end

NS_ASSUME_NONNULL_END
