//
//  FMQuantityView.h
//  feima
//
//  Created by fei on 2020/8/25.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SetQuantityBlock)(NSInteger quantity);

@interface FMQuantityView : UIView

@property (nonatomic, copy ) SetQuantityBlock myBlock;

@end
