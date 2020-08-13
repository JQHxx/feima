//
//  MyTabBarController.m
//  feima
//
//  Created by fei on 2020/7/29.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "MyTabBarController.h"
#import "BaseNavigationController.h"
#import "FMAddressViewController.h"
#import "FMWorkViewController.h"
#import "FMMineViewController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#B8B8B8"],NSFontAttributeName:[UIFont mediumFontWithSize:10]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor systemColor],NSFontAttributeName:[UIFont mediumFontWithSize:10]} forState:UIControlStateSelected];
    
    [UITabBar appearance].translucent = NO;
    
    self.tabBar.tintColor = [UIColor systemColor];
    self.tabBar.barStyle = UIBarStyleDefault;
    
    [self setupMyTabBar];
}


#pragma mark -- Private Methods
#pragma mark 初始化
- (void)setupMyTabBar {
    FMAddressViewController *addressVC = [[FMAddressViewController alloc] init];
    addressVC.backBtnHidden = YES;
    BaseNavigationController *nav1 = [self setupNavWithViewController:addressVC itemTitle:@"通讯录" image:@"phone" selImage:@"phone_hl"];
    
    FMWorkViewController *workVC = [[FMWorkViewController alloc] init];
    BaseNavigationController *nav2 = [self setupNavWithViewController:workVC itemTitle:@"工作台" image:@"workspace" selImage:@"workspace_hl"];
    
    FMMineViewController *mineVC = [[FMMineViewController alloc] init];
    BaseNavigationController *nav3 = [self setupNavWithViewController:mineVC itemTitle:@"我的" image:@"user" selImage:@"user_hl"];
    
    self.viewControllers = @[nav1,nav2,nav3];
    self.selectedIndex = 1;
}


- (BaseNavigationController *)setupNavWithViewController:(UIViewController *)vc
                                               itemTitle:(NSString *)title
                                                   image:(NSString *)image
                                                selImage:(NSString *)selImage {
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nav setTabBarItem:item];
    return nav;
}

@end
