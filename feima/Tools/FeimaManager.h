//
//  FeimaManager.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeimaManager : NSObject

singleton_interface(FeimaManager)

/**
 *   时间戳转化为时间
 *  @param timeSp  时间戳
 *  @param format    时间格式
*/
- (NSString *)timeWithTimeInterval:(NSInteger )timeSp format:(NSString *)format;

/**
 *   将某个时间转化成 时间戳
 *  @param formatTime  时间
 *  @param format    时间格式
*/
- (NSInteger)timeSwitchTimestamp:(NSString *)formatTime format:(NSString *)format;

/**
 *   获取某个月的天数
 *  @param year  年
 *  @param month    月
*/
- (NSInteger)getSumOfDaysInMonth:(NSInteger)year month:(NSInteger)month;

/**
 * 获取某月第一天和最后一天
 * @param dateStr  某月
 * @param format    时间格式
 */
- (NSArray *)getMonthFirstAndLastDayWithDate:(NSString *)dateStr format:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
