//
//  FMCompetitorDataView.h
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMCompetitorDataView : UIView

//数据源
- (void)setDatas:(NSArray <NSNumber *>*)datas
          colors:(NSArray <UIColor *>*)colors;

- (void)stroke;

@end

NS_ASSUME_NONNULL_END
