//
//  FMGroupModel.h
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMGroupModel : BaseModel

@property(nonatomic, copy ) NSString  *dictDesc;
@property(nonatomic, copy ) NSString  *dictGroup;
@property(nonatomic,assign) NSInteger dictId;
@property(nonatomic, copy ) NSString  *dictKey;
@property(nonatomic,assign) NSInteger dictSort;
@property(nonatomic,assign) NSInteger dictStatus;
@property(nonatomic, copy ) NSString  *dictValue;
@property(nonatomic, copy ) NSString  *key;

@end

NS_ASSUME_NONNULL_END
