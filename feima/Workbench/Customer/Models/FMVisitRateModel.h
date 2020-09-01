//
//  FMVisitRateModel.h
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

@interface FMRateModel : BaseModel

@property (nonatomic,  copy ) NSString *timeStr;
@property (nonatomic, assign) NSInteger visitNum;

@end

@interface FMVisitRateModel : BaseModel


@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger effectiveTotalNumber;
@property (nonatomic, assign) NSInteger totalNumber;
@property (nonatomic, strong) NSArray <FMRateModel *> *visitRates;


@end

