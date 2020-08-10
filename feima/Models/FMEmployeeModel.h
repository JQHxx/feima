//
//  FMEmployeeModel.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMEmployeeModel : BaseModel

@property (nonatomic,  copy ) NSString  *companyName;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic,  copy ) NSString  *email;
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic,  copy ) NSString  *logo;
@property (nonatomic,  copy ) NSString  *name;
@property (nonatomic, assign) NSInteger organizationId;
@property (nonatomic,  copy ) NSString  *organizationName;
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic,  copy ) NSString  *postName;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic,  copy ) NSString  *telephone;

@end

NS_ASSUME_NONNULL_END
