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

- (void)locationView:(FMLocationView *)view didClickBtnWithTag:(NSInteger)tag;

@end

@interface FMLocationView : UIView

@property (nonatomic, weak )id<FMLocationViewDelegate>delegate;

@property (nonatomic, copy ) NSString *addr;

@end

NS_ASSUME_NONNULL_END
