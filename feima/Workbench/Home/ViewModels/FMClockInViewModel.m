//
//  FMClockInViewModel.m
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMClockInViewModel.h"
#import "FMPunchStatusModel.h"

@interface FMClockInViewModel ()

@property (nonatomic,strong) NSArray  *recordsArray;

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
    NSString *account = [FeimaManager sharedFeimaManager].userBean.account;
    if (!kIsEmptyString(account)) {
        parameters[@"account"] = account;
    }
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

#pragma mark 获取打卡记录
- (void)loadPunchRecordsDataWithMonth:(NSString *)month
                               status:(NSString *)status
                             complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"yyyyMM"] = month;
    if (!kIsEmptyString(status)) {
        parameters[@"status"] = status;
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_punchrecord_list parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSDictionary *data = [json safe_objectForKey:@"data"];
            NSDictionary *punchRecordDict = [data safe_objectForKey:@"punchRecordListReq"];
            //打卡状态
            NSArray *statusList = [punchRecordDict safe_objectForKey:@"punchRecordStatusReqs"];
            self.statusArray = [NSArray yy_modelArrayWithClass:[FMPunchStatusModel class] json:statusList];
            //打卡记录
            NSArray *recordList = [punchRecordDict safe_objectForKey:@"punchRecordTypeReqs"];
            self.recordsArray = [NSArray yy_modelArrayWithClass:[FMPunchRecordModel class] json:recordList];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 返回打卡记录数量
- (NSInteger)numberOfPunchRecordsData {
    return self.recordsArray.count;
}

#pragma mark 返回打卡记录
- (FMPunchRecordModel *)getRecordModelWithIndex:(NSInteger)index {
    FMPunchRecordModel *model = [self.recordsArray safe_objectAtIndex:index];
    return model;
}


@end
