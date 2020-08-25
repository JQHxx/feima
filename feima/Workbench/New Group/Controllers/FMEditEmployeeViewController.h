//
//  FMEditEmployeeViewController.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"
#import "FMEmployeeModel.h"

typedef void(^UpdateEmployeeSuccess)(FMEmployeeModel *employee);
typedef void(^AddEmployeeSuccess)(FMEmployeeModel *employee);

@interface FMEditEmployeeViewController : BaseViewController

@property (nonatomic,strong) FMEmployeeModel *employee;
@property (nonatomic,  copy ) UpdateEmployeeSuccess updateSuccess;
@property (nonatomic,  copy ) AddEmployeeSuccess addSuccess;

@end
