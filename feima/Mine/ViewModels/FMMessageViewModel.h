//
//  FMMessageViewModel.h
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMMessageModel.h"

@interface FMMessageViewModel : BaseViewModel

@property (nonatomic,assign) NSInteger messagesCount;

/**
 *  消息列表
 *
 *  @param pageModel 分页
 *  @param complete  请求成功
*/
- (void)loadMessagesListDataWithPage:(FMPageModel *)pageModel
                            complete:(AdpaterComplete)complete;

/**
 *  未读消息数
 *
 *  @param complete  请求成功
*/
- (void)loadMessagesUnreadCountComplete:(AdpaterComplete)complete;

/**
 *  全部标记为已读
 *
 *  @param complete  请求成功
*/
- (void)setMessagesReadedComplete:(AdpaterComplete)complete;

/**
 *  返回消息数
*/
- (NSInteger)numberOfMessagesList;

/**
 *  返回消息对象
*/
- (FMMessageModel *)getMessageModelWithIndex:(NSInteger)index;

@end

