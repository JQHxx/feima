//
//  FMClockInViewModel.m
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMClockInViewModel.h"

@interface FMClockInViewModel ()

@property (nonatomic, copy ) NSString *punchStartTime;
@property (nonatomic, copy ) NSString *punchEndTime;
@property (nonatomic, copy ) NSString *punchAfterStartTime;
@property (nonatomic, copy ) NSString *punchAfterEndTime;

@end

@implementation FMClockInViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark  获取打卡时间
- (void)loadPunchTimeDataComplete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] getRequestWithUrl:api_punchrecord_time parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSArray *data = [json safe_objectForKey:@"data"];
            NSArray *list = [NSArray yy_modelArrayWithClass:[FMPunchTimeModel class] json:data];
            for (FMPunchTimeModel *model in list) {
                if ([model.dictGroup isEqualToString:@"PunchStartTime"]) {
                    self.punchStartTime = model.dictValue;
                } else if ([model.dictGroup isEqualToString:@"PunchEndTime"]) {
                    self.punchEndTime = model.dictValue;
                } else if ([model.dictGroup isEqualToString:@"PunchAfterStartTime"]) {
                    self.punchAfterStartTime = model.dictValue;
                } else if ([model.dictGroup isEqualToString:@"PunchAfterEndTime"]) {
                    self.punchAfterEndTime = model.dictValue;
                }
            }
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 打卡重复验证
- (void)verifyRepeatedPunchWithType:(FMClockInType)type complete:(AdpaterComplete)complete {
    NSString *url = type == FMClockInTypeToWork ? api_punchrecord_check_punch : api_punchrecord_check_punchafter;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"account"] = @"administrator";
    [[HttpRequest sharedInstance] getRequestWithUrl:url parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 打卡
- (void)addPunchRequetWithType:(FMClockInType)type
                       address:(NSString *)address
                        images:(NSArray *)images
                      longtude:(double)longtude
                      latitude:(double)latitude
                      complete:(AdpaterComplete)complete {
    NSString *url = type == FMClockInTypeToWork ? api_punchrecord_add_punch : api_punchrecord_add_punchafter;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"address"] = address;
    parameters[@"images"] = [images componentsJoinedByString:@","];
    parameters[@"longtude"] = @(longtude);
    parameters[@"latitude"] = @(latitude);
    [[HttpRequest sharedInstance] postWithUrl:url parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark
- (NSString *)getOnWorkPunchStartTime {
    return self.punchStartTime;
}

#pragma mark
- (NSString *)getOnWorkPunchEndTime {
    return self.punchEndTime;
}

#pragma mark
- (NSString *)getOffWorkPunchStartTime {
    return self.punchAfterStartTime;
}

#pragma mark
- (NSString *)getOffWorkPunchEndTime {
    return self.punchAfterEndTime;
}


@end
