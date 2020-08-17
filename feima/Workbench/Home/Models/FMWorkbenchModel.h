//
//  FMWorkbenchModel.h
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMWorkbenchModel : BaseModel

@property (nonatomic,  copy ) NSString  *code;
@property (nonatomic, assign) NSInteger menuId;
@property (nonatomic,  copy ) NSString  *icon;
@property (nonatomic,  copy ) NSString  *name;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic,  copy ) NSString  *reorder;
@property (nonatomic,  copy ) NSString  *router;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic,  copy ) NSString  *url;

@end

NS_ASSUME_NONNULL_END
