//
//  FMUserModel.h
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMUserModel : BaseModel

@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic,  copy ) NSString  *companyName;
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic,  copy ) NSString  *logo;
@property (nonatomic,  copy ) NSString  *name;
@property (nonatomic, assign) NSInteger organizationId;
@property (nonatomic,  copy ) NSString  *organizationName;
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic,  copy ) NSString  *postName;
@property (nonatomic,  copy ) NSString  *sexName;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic,  copy ) NSString  *telephone;

@end

@interface FMUserBeanModel : BaseModel

@property (nonatomic,  copy ) NSString    *account;
@property (nonatomic,  copy ) NSString    *terminalId;
@property (nonatomic, assign) NSInteger   type;
@property (nonatomic, strong) FMUserModel *users;

@end

NS_ASSUME_NONNULL_END
