//
//  FMCustomerViewController.h
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMCustomerViewController : BaseViewController

@property (nonatomic,assign) BOOL  isShowList;
@property (nonatomic,strong) NSMutableArray *customersArray;

@end

NS_ASSUME_NONNULL_END
