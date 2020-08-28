//
//  FMCustomerSalesHeadView.h
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedDateBlock)(NSInteger time);
typedef void(^SelectedOrganizationBlock)(NSInteger organizationId);

@interface FMCustomerSalesHeadView : UIView

@property (nonatomic, copy ) NSString *valueStr;
@property (nonatomic, copy ) SelectedDateBlock selDateBlock;
@property (nonatomic, copy ) SelectedOrganizationBlock selOrganiztionBlock;

@end

