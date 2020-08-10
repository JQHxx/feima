//
//  FMReportHeadView.h
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMTimeDataModel.h"
#import "FMSalesDataModel.h"
#import "FMGoodsSalesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMReportHeadView : UIView

- (void)displayViewWithTimeData:(FMTimeDataModel *)timeData salesData:(FMSalesDataModel *)salesData;

- (void)displayViewWithGoodsData:(NSArray *)goodsData salesData:(FMSalesDataModel *)salesData;

- (void)displayViewWithCustomerData;

@end

NS_ASSUME_NONNULL_END
