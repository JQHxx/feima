//
//  FMInstrucationViewModel.m
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInstrucationViewModel.h"

@interface FMInstrucationViewModel ()

@property (nonatomic,strong) FMPageModel    *myPage;
@property (nonatomic,strong) NSMutableArray *instrucactionsArray;


@end

@implementation FMInstrucationViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.myPage = [[FMPageModel alloc] init];
        self.instrucactionsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark 接收指令列表
- (void)loadInstrucationListWithPage:(FMPageModel *)pageModel
                                type:(NSInteger)type
                            complete:(AdpaterComplete)complete {
    NSString *url = type == 0 ? api_instruction_accept_list : api_instruction_release_list;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    parameters[@"pageSize"] = @(pageModel.pageSize);
    [[HttpRequest sharedInstance] getRequestWithUrl:url parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            self.myPage.total = [json safe_integerForKey:@"total"];
            NSDictionary *data = [json safe_objectForKey:@"data"];
            NSArray *beans = [data safe_objectForKey:@"instructionBeans"];
            if (beans.count > 0) {
                NSArray *arr = [NSArray yy_modelArrayWithClass:[FMInstrucationModel class] json:beans];
                if (pageModel.pageNum == 1) {
                    [self.instrucactionsArray removeAllObjects];
                }
                [self.instrucactionsArray addObjectsFromArray:arr];
            }
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 指令完成
- (void)instrucationCompleteWithInstructionRecordId:(NSInteger)instructionRecordId
                                            summary:(NSString *)summary
                                             images:(NSString *)images
                                           complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"instructionRecordId"] = @(instructionRecordId);
    parameters[@"summary"] = summary;
    parameters[@"images"] = images;
    [[HttpRequest sharedInstance] postWithUrl:api_instruction_complete parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 指令总数
- (NSInteger)numberOfInstrucationList {
    return self.instrucactionsArray.count;
}

#pragma mark 返回指令对象
- (FMInstrucationModel *)getInstrucationModelWithIndex:(NSInteger)index {
    FMInstrucationModel *model = [self.instrucactionsArray safe_objectAtIndex:index];
    return model;
}

#pragma mark 是否还有更多
- (BOOL)hasMoreData {
    if(self.myPage && self.instrucactionsArray.count > 0) {
        return self.myPage.total > self.instrucactionsArray.count;
    }
    return NO;
}


@end
