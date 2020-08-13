//
//  FMLocationView.h
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FMLocationView;
@protocol FMLocationViewDelegate <NSObject>

//返回
- (void)locationViewBackAction:(FMLocationView *)view;

//记录
- (void)locationViewPushToRecords:(FMLocationView *)view;

//刷新
- (void)locationViewDidRefreshLocation:(FMLocationView *)view;

@end

@interface FMLocationView : UIView

@property (nonatomic, weak )id<FMLocationViewDelegate>delegate;

@property (nonatomic, copy ) NSString *addr;

@end

NS_ASSUME_NONNULL_END
