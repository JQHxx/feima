//
//  FMStatisticsView.h
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FMStatisticsViewTypeDaily,
    FMStatisticsViewTypeCustomer,
} FMStatisticsViewType;

@interface FMStatisticsView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(FMStatisticsViewType)type;

@end

NS_ASSUME_NONNULL_END
