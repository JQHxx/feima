//
//  FMMonthyReportModel.h
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMMonthyReportModel : BaseModel

@property (nonatomic, assign) NSInteger  employeeId;
@property (nonatomic,  copy ) NSString   *employeeName;
@property (nonatomic, assign) NSInteger  punchInAbnormalNumber;
@property (nonatomic, assign) NSInteger  punchInNumber;
@property (nonatomic, assign) NSInteger  punchOutAbnormalNumber;
@property (nonatomic, assign) NSInteger  punchOutNumber;

@end

NS_ASSUME_NONNULL_END
