//
//  FMCustomerPopView.h
//  feima
//
//  Created by fei on 2020/8/19.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCustomerModel.h"


typedef void(^ClickBlock)(FMCustomerModel *model);

@interface FMCustomerPopView : UIView

@property (nonatomic, copy ) ClickBlock clickAction;

- (void)displayViewWithModel:(FMCustomerModel *)model;

@end

