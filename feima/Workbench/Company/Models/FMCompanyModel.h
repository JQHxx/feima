//
//  FMCompanyModel.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMCompanyModel : BaseModel

@property (nonatomic, assign) NSInteger accountsNumber;
@property (nonatomic,  copy ) NSString  *address;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) NSInteger contractEffectiveTime;
@property (nonatomic, assign) NSInteger contractTerminationTime;
@property (nonatomic,  copy ) NSString  *contractor;
@property (nonatomic,  copy ) NSString  *name;
@property (nonatomic,  copy ) NSString  *phone;
@property (nonatomic, assign) NSInteger signingTime;

@property (nonatomic, assign) NSInteger isSelected;

@end

NS_ASSUME_NONNULL_END
