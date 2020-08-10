//
//  FMTimeDataModel.h
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMTimeDataModel : BaseModel

@property (nonatomic, assign) NSInteger  day;
@property (nonatomic, assign) double     progress;
@property (nonatomic, assign) NSInteger  daySum;

@end

NS_ASSUME_NONNULL_END
