//
//  FMDailyHeadView.h
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDailyReportModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMDailyHeadView : UIView

- (void)fillDataWithFigure:(FMDailyFigureModel *)figureModel statusModel:(FMDailyStatusModel *)statusModel;

@end

NS_ASSUME_NONNULL_END
