//
//  FMSearchViewController.h
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"

@interface FMSearchViewController : BaseViewController

@property(nonatomic, copy) void (^ didClickSearch)(NSString *keyword);

@end
