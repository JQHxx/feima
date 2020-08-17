//
//  FMClockInAlertView.h
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMClockInViewModel.h"

typedef void(^ConfirmBlock)(NSArray *images);

@interface FMClockInAlertView : UIView

/**
 * 显示
 *  @param frame  frame
 *  @param type  打卡类型
 *  @param startTime  开始时间
 *  @param endTime  结束时间
 *  @param addr  地址
 *  @param confrim  确定
 */
+ (void)showClockInAlertWithFrame:(CGRect)frame
                             type:(FMClockInType)type
                          address:(NSString *)addr
                        startTime:(NSString *)startTime
                          endTime:(NSString *)endTime
                    confirmAction:(ConfirmBlock)confrim;

@end
