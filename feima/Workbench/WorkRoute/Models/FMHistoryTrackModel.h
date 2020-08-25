//
//  FMHistoryTrackModel.h
//  feima
//
//  Created by fei on 2020/8/21.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"
#import <BaiduTraceSDK/BaiduTraceSDK.h>

@interface FMHistoryTrackModel : BaseModel

@property (nonatomic, copy) NSString *entityName;
@property (nonatomic, assign) NSUInteger startTime;
@property (nonatomic, assign) NSUInteger endTime;
@property (nonatomic, assign) BOOL isProcessed;
@property (nonatomic, strong) BTKQueryTrackProcessOption *processOption;
@property (nonatomic, assign) BTKTrackProcessOptionSupplementMode supplementMode;

@end

