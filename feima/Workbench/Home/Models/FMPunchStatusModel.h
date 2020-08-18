//
//  FMPunchStatusModel.h
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMPunchStatusModel : BaseModel

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic,  copy ) NSString  *statusName;

@end

NS_ASSUME_NONNULL_END
