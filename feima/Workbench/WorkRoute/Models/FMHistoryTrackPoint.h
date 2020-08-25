//
//  FMHistoryTrackPoint.h
//  feima
//
//  Created by fei on 2020/8/21.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"
#import <BaiduTraceSDK/BaiduTraceSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMHistoryTrackPoint : BaseModel

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSUInteger loctime;
@property (nonatomic, assign) NSUInteger direction;

@end

NS_ASSUME_NONNULL_END
