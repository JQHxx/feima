//
//  FMMessageModel.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"
#import "FMEmployeeModel.h"

@interface FMMessageModel : BaseModel

@property (nonatomic,  copy ) NSString  *message;
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic, assign) NSInteger messageType;
@property (nonatomic,  copy ) NSString  *organizationName;
@property (nonatomic,  copy ) NSString  *statusName;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic,  copy ) NSString  *typeName;
@property (nonatomic, assign) NSInteger toEmployeeId;
@property (nonatomic, strong) FMEmployeeModel  *employee;


@end

