//
//  FMPunchRecordModel.h
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMRecordTypeModel : BaseModel

@property (nonatomic,  copy ) NSString  *address;
@property (nonatomic,  copy ) NSString  *employeeName;
@property (nonatomic, assign) NSInteger employeeId;
@property (nonatomic,  copy ) NSString  *images;
@property (nonatomic, assign) double    latitude;
@property (nonatomic, assign) double    longitude;
@property (nonatomic, assign) NSInteger punchRecordId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic,  copy ) NSString  *statusName;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic,  copy ) NSString  *typeName;

@end

@interface FMPunchRecordModel : BaseModel

@property (nonatomic,  copy ) NSString  *employeeName;
@property (nonatomic,  copy ) NSString  *time;
@property (nonatomic, strong ) FMRecordTypeModel  *recordAfterType;
@property (nonatomic, strong ) FMRecordTypeModel  *recordType;


@end

NS_ASSUME_NONNULL_END
