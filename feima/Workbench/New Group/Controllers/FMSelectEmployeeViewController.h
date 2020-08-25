//
//  FMSelectEmployeeViewController.h
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"
#import "FMEmployeeModel.h"

typedef void(^SelectedEmployeeComplete)(FMEmployeeModel *employee);

@interface FMSelectEmployeeViewController : BaseViewController

@property (nonatomic,assign) NSInteger selEmployeeId;
@property (nonatomic, copy ) SelectedEmployeeComplete selectedComplete;

@end

