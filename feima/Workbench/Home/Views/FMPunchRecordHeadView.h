//
//  FMPunchRecordHeadView.h
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMPunchStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FMPunchRecordHeadViewDelegate <NSObject>

- (void)headViewDidSelectedStatus:(NSString *)status;

@end

@interface FMPunchRecordHeadView : UIView

@property (nonatomic, weak ) id<FMPunchRecordHeadViewDelegate>delegate;

- (void)dispalyViewWithStatusData:(NSArray<FMPunchStatusModel*>*)data;

@end

NS_ASSUME_NONNULL_END
