//
//  FMDistributionViewController.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMDistributionViewController : BaseViewController

@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger orderGoodsId;
@property (nonatomic, copy ) NSString  *orderType;

@end

NS_ASSUME_NONNULL_END
