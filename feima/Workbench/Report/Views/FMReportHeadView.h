//
//  FMReportHeadView.h
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMSalesDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMReportHeadView : UIView

- (void)displayViewWithData:(FMSalesDataModel *)model;

@end

NS_ASSUME_NONNULL_END
