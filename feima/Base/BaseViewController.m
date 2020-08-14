//
//  BaseViewController.m
//  feima
//
//  Created by fei on 2020/7/29.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController (){
    UIButton  *backBtn;
    UILabel   *titleLabel;
}

@property(nonatomic ,strong) UIView    *navBarView;


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self customNavBar];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark 状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- Event response
#pragma mark 左侧返回方法
-(void)leftNavigationItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 导航栏右侧按钮事件
-(void)rightNavigationItemAction{
    
}

#pragma mark --Private Methods
#pragma mark 自定义导航栏
-(void)customNavBar{
    UIView *navView=[[UIView alloc] init];
    navView.backgroundColor = [UIColor colorWithHexString:@"#FCB411"];
    [self.view addSubview:navView];
    self.navBarView = navView;
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavBar_Height);
    }];
    
    backBtn=[[UIButton alloc] init];
    [backBtn setImage:ImageNamed(@"return_white") forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
    [backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(kStatusBar_Height+2);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    titleLabel =[[UILabel alloc] init];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont mediumFontWithSize:18];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.navBarView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.top.mas_equalTo(kStatusBar_Height+10);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(24);
    }];
}

#pragma mark -- Setters
#pragma mark 设置是否隐藏导航栏
-(void)setIsHiddenNavBar:(BOOL)isHiddenNavBar{
    _isHiddenNavBar = isHiddenNavBar;
    self.navBarView.hidden = isHiddenNavBar;
}

#pragma mark 设置是否隐藏返回按钮
-(void)setIsHiddenBackBtn:(BOOL)isHiddenBackBtn{
    _isHiddenBackBtn = isHiddenBackBtn;
    backBtn.hidden = isHiddenBackBtn;
}

#pragma mark 设置标题
-(void)setBaseTitle:(NSString *)baseTitle{
    _baseTitle=baseTitle;
    titleLabel.text=baseTitle;
}


@end
