//
//  FMSalesDataModel.h
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMSalesDataModel : BaseModel

@property (nonatomic, assign) double    lastSalesSum;
@property (nonatomic, assign) double    progress;
@property (nonatomic, assign) double    thisSalesSum;

@end

NS_ASSUME_NONNULL_END
