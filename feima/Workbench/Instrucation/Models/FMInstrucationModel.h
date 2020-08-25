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


@property (nonatomic,  copy ) NSString  *comment;
@property (nonatomic,  copy ) NSString  *content;
@property (nonatomic, assign) NSInteger fromEmployeeId;
@property (nonatomic,  copy ) NSString  *fromEmployeeName;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger instructionId;
@property (nonatomic, assign) NSInteger instructionRecordId;
@property (nonatomic,  copy ) NSString  *logo;
@property (nonatomic,  copy ) NSString  *score;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic,  copy ) NSString  *statusName;
@property (nonatomic,  copy ) NSString  *images;
@property (nonatomic,  copy ) NSString  *summary;
@property (nonatomic, assign) NSInteger toEmployeeId;
@property (nonatomic, strong) NSArray <FMEmployeeModel *>  *employees;

@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic,  copy ) NSString  *employeeName;
@property (nonatomic, assign) NSInteger startTime;

@end

NS_ASSUME_NONNULL_END
