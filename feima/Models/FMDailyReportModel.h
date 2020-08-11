//
//  FMDailyReportModel.h
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMDailyReportModel : BaseModel

@property (nonatomic,  copy ) NSString   *address;
@property (nonatomic, assign) NSInteger  employeeId;
@property (nonatomic,  copy ) NSString   *employeeName;
@property (nonatomic,  copy ) NSString   *images;
@property (nonatomic, assign) NSInteger  organizationId;
@property (nonatomic,  copy ) NSString   *organizationName;
@property (nonatomic, assign) NSInteger  punchSecondTime;
@property (nonatomic,  copy ) NSString   *punchSecondTimeStr;
@property (nonatomic, assign) NSInteger  punchStatus;
@property (nonatomic,  copy ) NSString   *punchStatusName;
@property (nonatomic, assign) NSInteger  punchType;
@property (nonatomic,  copy ) NSString   *punchTypeName;

@end

@interface FMDailyFigureModel : BaseModel

@property (nonatomic, assign) NSInteger  punchNumber;
@property (nonatomic, assign) NSInteger  shouldBeToNumber;

@end

@interface FMDailyStatusModel : BaseModel

@property (nonatomic, assign) NSInteger  abnormalNumber;
@property (nonatomic, assign) NSInteger  notPunchNumber;
@property (nonatomic, assign) NSInteger  punchNumber;

@end

NS_ASSUME_NONNULL_END
