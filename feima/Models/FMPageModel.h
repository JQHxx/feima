//
//  FMPageModel.h
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMPageModel : BaseModel

//接口返回的数据
@property (nonatomic, assign) NSInteger total; //是指整个查询结果的总条数

//请求用
@property (nonatomic, assign) NSInteger pageNum; //当前页码
@property (nonatomic, assign) NSInteger pageSize; //每页放回的数量

@end

NS_ASSUME_NONNULL_END
