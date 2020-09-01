//
//  FMMessageViewModel.m
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMessageViewModel.h"

@interface FMMessageViewModel ()

@property (nonatomic,strong) FMPageModel    *myPage;
@property (nonatomic,strong) NSMutableArray *messagesList;


@end

@implementation FMMessageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.myPage = [[FMPageModel alloc] init];
        self.messagesList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark 消息列表
- (void)loadMessagesListDataWithPage:(FMPageModel *)pageModel complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    parameters[@"pageSize"] = @(pageModel.pageSize);
    [[HttpRequest sharedInstance] getRequestWithUrl:api_messages_list parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            self.myPage.total = [json safe_integerForKey:@"total"];
            NSDictionary *data = [json safe_objectForKey:@"data"];
            NSArray *list = [data safe_objectForKey:@"messageListBeans"];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FMMessageModel class] json:list];
            if (pageModel.pageNum == 1) {
                [self.messagesList removeAllObjects];
            }
            [self.messagesList addObjectsFromArray:arr];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 获取未读消息数
- (void)loadMessagesUnreadCountComplete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] getRequestWithUrl:api_messages_unread_count parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            self.messagesCount = [json safe_integerForKey:@"data"];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 标记已读
- (void)setMessagesReadedComplete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] postWithUrl:api_messages_accepted parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 消息数
- (NSInteger)numberOfMessagesList {
    return self.messagesList.count;
}

#pragma mark 消息对象
- (FMMessageModel *)getMessageModelWithIndex:(NSInteger)index {
    FMMessageModel *model = [self.messagesList safe_objectAtIndex:index];
    return model;
}

#pragma mark 是否更多消息
- (BOOL)hasMoreData {
    if(self.myPage && self.messagesList.count > 0) {
        return self.myPage.total > self.messagesList.count;
    }
    return NO;
}

@end
