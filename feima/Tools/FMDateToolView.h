//
//  FMDateToolView.h
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FMDateToolViewTypeMonth,
    FMDateToolViewTypeDay,
} FMDateToolViewType;

typedef void(^SelectedBlock)(NSString *value);

@interface FMDateToolView : UIView

@property (nonatomic, copy ) SelectedBlock selectedBlock;

- (instancetype)initWithFrame:(CGRect)frame type:(FMDateToolViewType)type;

@end

NS_ASSUME_NONNULL_END
