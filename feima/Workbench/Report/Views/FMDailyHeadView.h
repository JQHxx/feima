//
//  FMDailyHeadView.h
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDailyReportModel.h"

typedef void(^SelectedDateBlock)(NSInteger time);
typedef void(^SelectedOrganizationBlock)(NSInteger organizationId);

@interface FMDailyHeadView : UIView

@property (nonatomic, copy ) SelectedDateBlock selDateBlock;
@property (nonatomic, copy ) SelectedOrganizationBlock selOrganiztionBlock;

- (void)fillDataWithFigure:(FMDailyFigureModel *)figureModel statusModel:(FMDailyStatusModel *)statusModel;

@end

