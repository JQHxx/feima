//
//  FMPublicViewModel.m
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMPublicViewModel.h"

@implementation FMPublicViewModel

#pragma mark  字典下拉框
- (void)loadGroupDataWithGroupStr:(NSString *)groupStr
                         complete:(AdpaterComplete)complete {
    //获取缓存数据
    NSString * key = nil;
    if ([groupStr isEqualToString:kIndustryTypeKey]) {
        key = kIndustryGroupDataKey;
    } else if ([groupStr isEqualToString:kCustomerLevelKey]) {
        key = kLevelGroupDataKey;
    } else if ([groupStr isEqualToString:kFollowUpProgressKey]) {
        key = kProgressGroupDataKey;
    }
    NSArray *cacheData = [NSUserDefaultsInfos getValueforKey:key];
    if (cacheData.count > 0) {
        NSArray *tempArr = [NSArray yy_modelArrayWithClass:[FMGroupModel class] json:cacheData];
        if ([groupStr isEqualToString:kIndustryTypeKey]) {
            self.industryTypesArray = tempArr;
        } else if ([groupStr isEqualToString:kCustomerLevelKey]) {
            self.levelArray = tempArr;
        } else if ([groupStr isEqualToString:kFollowUpProgressKey]) {
            self.progressArray = tempArr;
        }
        if (complete) complete(YES);
    }
    
    NSDictionary *parameters = @{@"groupStr":groupStr};
    [[HttpRequest sharedInstance] getRequestWithUrl:api_dict_selectgroup parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSArray *data = [json safe_objectForKey:@"data"];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FMGroupModel class] json:data];
            if ([groupStr isEqualToString:kIndustryTypeKey]) {
                self.industryTypesArray = arr;
                [NSUserDefaultsInfos putKey:kIndustryGroupDataKey andValue:data];
            } else if ([groupStr isEqualToString:kCustomerLevelKey]) {
                self.levelArray = arr;
                [NSUserDefaultsInfos putKey:kLevelGroupDataKey andValue:data];
            } else if ([groupStr isEqualToString:kFollowUpProgressKey]) {
                self.progressArray = arr;
                [NSUserDefaultsInfos putKey:kProgressGroupDataKey andValue:data];
            }
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

@end
