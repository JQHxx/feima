//
//  FMEmployeeRouteModel.h
//  feima
//
//  Created by fei on 2020/8/31.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"
#import "FMEmployeeModel.h"

@interface FMWorkRouteModel : BaseModel

@property (nonatomic, copy)   NSString   *address;
@property (nonatomic, assign) NSUInteger createDay;
@property (nonatomic, assign) NSInteger  employeeId;
@property (nonatomic, assign) NSInteger  isMock;
@property (nonatomic, assign) double     latitude;
@property (nonatomic, assign) double     longitude;
@property (nonatomic, assign) NSInteger  stayTime;
@property (nonatomic, assign) NSInteger  workRouteId;

@end

@interface FMEmployeeRouteModel : BaseModel

@property (nonatomic,strong) FMEmployeeModel  *employee;
@property (nonatomic, copy ) NSString         *employeeVisit;
@property (nonatomic,assign) BOOL             online;
@property (nonatomic,strong) FMWorkRouteModel *workRoute;

@end

