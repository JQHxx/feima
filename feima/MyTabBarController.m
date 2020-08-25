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
#import "FMClockInViewModel.h"
#import "FMYYServiceManager.h"

@interface MyTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) FMClockInViewModel *adapter;

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#B8B8B8"],NSFontAttributeName:[UIFont mediumFontWithSize:10]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor systemColor],NSFontAttributeName:[UIFont mediumFontWithSize:10]} forState:UIControlStateSelected];
    
    [UITabBar appearance].translucent = NO;
    
    self.tabBar.tintColor = [UIColor systemColor];
    self.tabBar.barStyle = UIBarStyleDefault;
    self.delegate = self;
    
    [self setupMyTabBar];
    [self verifyClockIn];
}


#pragma mark -- UITabBarControllerDelegate
#pragma mark 点击响应
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //添加点击动画
    UIImageView *imageView;
    for (UIView *view in tabBar.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"]) {
            for (UIView *sv in view.subviews) {
                if ([sv isKindOfClass:[UIImageView class]] && ((UIImageView *)sv).image == item.selectedImage) {
                    imageView = (UIImageView *)sv;
                }
            }
        }
    }
    
    if (imageView == nil) {
        return;
    }
    
    imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
}

#pragma mark -- Private Methods
#pragma mark 验证打卡
- (void)verifyClockIn {
    //上班打卡验证
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *account = [FeimaManager sharedFeimaManager].userBean.account;
    if (!kIsEmptyString(account)) {
        parameters[@"account"] = account;
    }
    dispatch_async(GLOBAL_QUEUE, ^{
        [[HttpRequest sharedInstance] getRequestWithUrl:api_punchrecord_check_punch parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
            NSInteger code = [json safe_integerForKey:@"code"];
            if (code == -1601) { //已打上班卡
                //下班打卡验证
                [[HttpRequest sharedInstance] getRequestWithUrl:api_punchrecord_check_punchafter parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
                    NSInteger errorCode = [json safe_integerForKey:@"code"];
                    if (errorCode == -1601) { //已打下班卡
                        if ([FMYYServiceManager defaultManager].isServiceStarted) {
                            [[FMYYServiceManager defaultManager] stopGather];
                        }
                    } else {
                        if (![FMYYServiceManager defaultManager].isServiceStarted) {
                            // 开启服务之间先配置轨迹服务的基础信息
                            BTKServiceOption *basicInfoOption = [[BTKServiceOption alloc] initWithAK:key_baidu_ak mcode:key_budle_identifier serviceID:key_baidu_service_id keepAlive:YES];
                            [[BTKAction sharedInstance] initInfo:basicInfoOption];
                            
                            // 开启服务
                            BTKStartServiceOption *startServiceOption = [[BTKStartServiceOption alloc] initWithEntityName:account];
                            [[FMYYServiceManager defaultManager] startServiceWithOption:startServiceOption];
                        }
                    }
                }];
            }
        }];
    });
}


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

- (FMClockInViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMClockInViewModel alloc] init];
    }
    return _adapter;
}

@end
