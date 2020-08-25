//
//  FMAddCustomerViewController.h
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"
#import "FMCustomerModel.h"

typedef void(^UpdateCustomerSuccess)(FMCustomerModel *model);

@interface FMAddCustomerViewController : BaseViewController

@property (nonatomic, strong) FMCustomerModel *customerModel;
@property (nonatomic,  copy ) UpdateCustomerSuccess updateSuccess;

@end

