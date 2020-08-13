//
//  FMClockInAlertView.h
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FMClockInAlertViewTypeToWork, //上班
    FMClockInAlertViewTypeOffWork, //下班
} FMClockInAlertViewType;

typedef void(^ConfirmBlock)(void);

@interface FMClockInAlertView : UIView

/* 显示
 *
 */
+ (void)showClockInAlertWithFrame:(CGRect)frame
                             type:(FMClockInAlertViewType)type
                    confirmAction:(ConfirmBlock)confrim;

@end

NS_ASSUME_NONNULL_END
