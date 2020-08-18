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
    NSDictionary *parameters = @{@"groupStr":groupStr};
    [[HttpRequest sharedInstance] getRequestWithUrl:api_dict_selectgroup parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSArray *data = [json safe_objectForKey:@"data"];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FMGroupModel class] json:data];
            if ([groupStr isEqualToString:@"IndustryType"]) {
                self.industryTypesArray = arr;
            } else if ([groupStr isEqualToString:@"CustomerLevel"]) {
                self.levelArray = arr;
            } else if ([groupStr isEqualToString:@"FollowUpProgress"]) {
                self.progressArray = arr;
            }
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

@end
