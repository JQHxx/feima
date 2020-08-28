//
//  FMSalesProgressView.h
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FMSalesProgressView : UIView

@property (nonatomic,assign) CGFloat progress;
@property (nonatomic, copy ) NSString *progressStr;
@property (nonatomic, copy ) NSString *valueStr;

- (void)startRendering;


@end

