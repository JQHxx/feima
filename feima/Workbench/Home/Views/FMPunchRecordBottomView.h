//
//  FMPunchRecordBottomView.h
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FMPunchRecordBottomView;
@protocol FMPunchRecordBottomViewDelegate <NSObject>

//选择月份
- (void)bottomViewDidSelectedMonth;

- (void)bottomViewDidClickActionWithIndex:(NSInteger)index;

@end

@interface FMPunchRecordBottomView : UIView

@property (nonatomic, weak ) id<FMPunchRecordBottomViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
