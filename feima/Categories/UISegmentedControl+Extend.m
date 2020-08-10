//
//  UISegmentedControl+Extend.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "UISegmentedControl+Extend.h"
#import "UIColor+Extend.h"

@implementation UISegmentedControl (Extend)

- (void)segmentedIOS13Style {
    if (@available(iOS 13, *)) {
        UIColor *tintColor = [self tintColor];
        UIImage *tintColorImage = [UIColor imageForColor:tintColor];
        [self setBackgroundImage:[UIColor imageForColor:self.backgroundColor ? self.backgroundColor : [UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:tintColorImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[UIColor imageForColor:[tintColor colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:tintColorImage forState:UIControlStateSelected|UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:tintColor,NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
        [self setDividerImage:tintColorImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.layer.borderWidth = 1;
        self.layer.borderColor = tintColor.CGColor;
        self.selectedSegmentTintColor = tintColor;
    }
}


@end
