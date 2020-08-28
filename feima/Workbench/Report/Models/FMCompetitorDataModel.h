//
//  FMCompetitorDataModel.h
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

@interface FMCompetitorDataModel : BaseModel

@property (nonatomic, assign) NSInteger  competeGoodsId;
@property (nonatomic,  copy ) NSString   *competeGoodsName;
@property (nonatomic, assign) NSInteger  customerId;
@property (nonatomic,  copy ) NSString   *customerName;
@property (nonatomic, assign) NSInteger  followUpPeopleId;
@property (nonatomic,  copy ) NSString   *followUpPeopleName;
@property (nonatomic, assign) double     lastMarketShare;
@property (nonatomic, assign) double     thisMarketShare;

@end

@interface FMCompetitorAnalysisModel : BaseModel

@property (nonatomic, assign) NSInteger  competeGoodsId;
@property (nonatomic,  copy ) NSString   *competeGoodsName;
@property (nonatomic, assign) NSInteger  marketShare;
@property (nonatomic, assign) NSInteger  sales;
@property (nonatomic, assign) NSInteger  salesSum;

@end

