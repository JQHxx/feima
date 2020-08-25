//
//  FMEmployeeInfoViewController.h
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"
#import "FMEmployeeModel.h"

typedef void(^UpdateEmployeeBlock)(FMEmployeeModel *employee);

@interface FMEmployeeInfoViewController : BaseViewController

@property (nonatomic,strong) FMEmployeeModel *employeeModel;
@property (nonatomic, copy ) UpdateEmployeeBlock updateBlock;

@end


