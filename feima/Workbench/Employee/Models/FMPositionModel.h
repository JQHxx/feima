//
//  FMPositionModel.h
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"


@interface FMPositionModel : BaseModel

@property (nonatomic,  copy ) NSString  *name;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, assign) NSInteger postId;

@end

