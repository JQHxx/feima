//
//  FMSelectCompanyViewController.h
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"
#import "FMCompanyModel.h"

typedef void(^SelectedCompanyBlock)(FMCompanyModel *company);

@interface FMSelectCompanyViewController : BaseViewController

@property (nonatomic,assign) NSInteger selCompanyId;
@property (nonatomic, copy ) SelectedCompanyBlock selectedBlock;

@end

