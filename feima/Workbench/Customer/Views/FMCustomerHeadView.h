//
//  FMCustomerHeadView.h
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCustomerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMCustomerHeadView : UIView

- (void)displayViewWithData:(FMCustomerModel *)model;

@end

NS_ASSUME_NONNULL_END
