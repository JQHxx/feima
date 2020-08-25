//
//  FMCustomerTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "FMCustomerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMCustomerTableViewCell : BaseTableViewCell

- (void)fillContentWithData:(FMCustomerModel *)model showDistance:(BOOL)showDistance;

@end


NS_ASSUME_NONNULL_END
