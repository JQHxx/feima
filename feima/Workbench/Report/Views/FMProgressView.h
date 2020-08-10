//
//  FMProgressView.h
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FMProgressTypeTime,
    FMProgressTypeSale,
} FMProgressType;

@interface FMProgressView : UIView

@property (nonatomic,assign) CGFloat progress;
@property (nonatomic, copy ) NSString *valueStr;
@property (nonatomic, copy ) NSString *titleStr;

- (instancetype)initWithFrame:(CGRect)frame type:(FMProgressType)type;
 
- (void)startRendering;

@end

NS_ASSUME_NONNULL_END
