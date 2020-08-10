//
//  BaseViewController.h
//  feima
//
//  Created by fei on 2020/7/29.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>


NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic ,assign) BOOL        isHiddenBackBtn;      //隐藏返回按钮
@property (nonatomic ,assign) BOOL        isHiddenNavBar;       //隐藏导航栏
@property (nonatomic , copy ) NSString    *baseTitle;           //标题

@end

NS_ASSUME_NONNULL_END
