//
//  FMDistributedBottomView.h
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    FMDistributedBottomViewTypeCustomer,
    FMDistributedBottomViewTypeEmployee,
} FMDistributedBottomViewType;

@interface FMDistributedBottomView : UIView

@property (nonatomic,assign) FMDistributedBottomViewType type;
@property (nonatomic,assign) NSInteger customerCount;  //客户数

@end

NS_ASSUME_NONNULL_END
