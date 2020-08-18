//
//  FeimaManager.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FeimaManager.h"
#import "AppDelegate.h"
#import "FMLoginViewController.h"

@implementation FeimaManager

singleton_implementation(FeimaManager)

#pragma mark 时间戳转化为时间
- (NSString *)timeWithTimeInterval:(NSInteger)timeSp format:(NSString *)format {
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeSp];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark 将某个时间转化成 时间戳
- (NSInteger)timeSwitchTimestamp:(NSString *)formatTime format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime];    //将字符串按formatter转成nsdate
    return [date timeIntervalSince1970];
}

#pragma mark 获取某个月的天数
- (NSInteger)getSumOfDaysInMonth:(NSInteger)year month:(NSInteger)month {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"]; // 年-月
    NSString * dateStr = [NSString stringWithFormat:@"%ld-%ld",year,month];
    NSDate * date = [formatter dateFromString:dateStr];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
}

#pragma mark 获取某月第一天和最后一天
- (NSArray *)getMonthFirstAndLastDayWithDate:(NSString *)dateStr format:(NSString *)format{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *newDate=[formatter dateFromString:dateStr];
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];

    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:newDate];
    
    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    }else {
        return @[@"",@""];
    }

    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:format];
    NSString *firstString = [myDateFormatter stringFromDate: firstDate];
    NSString *lastString = [myDateFormatter stringFromDate: lastDate];
    return @[firstString, lastString];
}

#pragma mark 获取年月数据
- (NSMutableArray *)getYearMonthDataWithMinDate:(NSString *)minDate {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    //当前日期时间
    NSDate *currentDate = [NSDate date];
    //设定数据格式为xxxx-mm
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    //通过日历可以直接获取前几个月的日期，所以这里直接用该类的方法进行循环获取数据
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    NSString *dateStr = [formatter stringFromDate:currentDate];
    NSInteger lastIndex = 0;
    NSDate *newdate;
    //循环获取可选月份，从当前月份到最小月份，直接用字符串的比较来判断是否大于设定的最小日期
    while (!([dateStr compare:minDate] == NSOrderedAscending)) {
        [data addObject:dateStr];
        lastIndex--;
        //获取之前n个月, setMonth的参数为正则向后，为负则表示之前
        [lastMonthComps setMonth:lastIndex];
        newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
        dateStr = [formatter stringFromDate:newdate];
    }
    return data;
}

#pragma mark 退出登录
- (void)logout {
    [NSUserDefaultsInfos putKey:kLoginStateKey andValue:[NSNumber numberWithBool:NO]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [kKeyWindow makeToast:@"帐号已在他处登录" duration:1.0 position:CSToastPositionCenter];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [[FMLoginViewController alloc] init];
    });
}

#pragma mark 打电话
- (void)callPhoneWithNumber:(NSString *)telephone {
    if (kIsEmptyString(telephone)) {
        return;
    }
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
}

@end
