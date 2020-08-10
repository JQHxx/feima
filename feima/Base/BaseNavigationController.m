//
//  BaseNavigationController.m
//  feima
//
//  Created by fei on 2020/7/29.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        UIViewController *root = self.childViewControllers[0];
        if (viewController != root) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
    }
    [super pushViewController:viewController animated:animated];
}


@end
