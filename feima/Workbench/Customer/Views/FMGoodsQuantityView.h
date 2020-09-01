//
//  FMGoodsQuantityView.h
//  feima
//
//  Created by fei on 2020/8/31.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoodsQuantityUpdateBlock)(NSInteger quantity);

@interface FMGoodsQuantityView : UIView

@property (nonatomic,assign) NSInteger quatity;
@property (nonatomic, copy ) GoodsQuantityUpdateBlock myBlock;

@end

