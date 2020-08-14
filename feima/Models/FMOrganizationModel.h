//
//  FMOrganizationModel.h
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMOrganizationModel : BaseModel

@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic,  copy ) NSString  *name;
@property (nonatomic, assign) NSInteger orgSum;
@property (nonatomic, assign) NSInteger organizationId;
@property (nonatomic,  copy ) NSString  *path;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger sorted;
@property (nonatomic, assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
