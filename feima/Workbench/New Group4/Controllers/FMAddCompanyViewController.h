//
//  FMAddCompanyViewController.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"
#import "FMCompanyModel.h"


typedef void(^UpdateCompanySuccess)(FMCompanyModel *company);
typedef void(^AddCompanySuccess)(FMCompanyModel *company);

@interface FMAddCompanyViewController : BaseViewController

@property (nonatomic, strong) FMCompanyModel *company;
@property (nonatomic,  copy ) UpdateCompanySuccess updateSuccess;
@property (nonatomic,  copy ) AddCompanySuccess addSuccess;

@end

