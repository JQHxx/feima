//
//  FMDateToolView.h
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FMDateToolViewTypeMonth,
    FMDateToolViewTypeDay,
} FMDateToolViewType;

@protocol FMDateToolViewDelegate <NSObject>

- (void)dateToolViewDidSelectedDate:(NSString *)date;

- (void)dateToolViewDidSelectedOrganizationWithOriganizationId:(NSInteger )organizationId;

@end

@interface FMDateToolView : UIView

@property (nonatomic, weak ) id<FMDateToolViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(FMDateToolViewType)type;

@end

