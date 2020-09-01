//
//  FMVisitRecordHeadView.h
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCustomerModel.h"
#import "FMOrderSellModel.h"
#import "FMVisitRateModel.h"

@interface FMVisitRecordHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame customer:(FMCustomerModel *)model;

- (void)fillContentDataWithOrderSellInfo:(NSArray <FMOrderSellModel *> *)sellInfo rate:(FMVisitRateModel *)rateModel;

@end
