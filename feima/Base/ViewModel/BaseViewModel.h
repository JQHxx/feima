//
//  BaseViewModel.h
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^AdpaterComplete)(BOOL isSuccess);

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewModel : NSObject

/*
 * pageSize
 */
+ (NSInteger)pageSize;

/*
* 是否还有更多数据
*/
- (BOOL)hasMoreData;

/*
* 是否为空数据
*/
- (BOOL)isEmpty;

/*
* 处理错误结果 
*/
- (void)handlerError:(NSError*)error;

@end

NS_ASSUME_NONNULL_END
