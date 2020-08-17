//
//  FMInstrucationModel.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"
#import "FMEmployeeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMInstrucationModel : BaseModel


@property (nonatomic,  copy ) NSString  *content;
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic,  copy ) NSString  *employeeName;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger instructionId;
@property (nonatomic,  copy ) NSString  *logo;
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, strong) NSArray <FMEmployeeModel *>  *employees;

@end

NS_ASSUME_NONNULL_END
