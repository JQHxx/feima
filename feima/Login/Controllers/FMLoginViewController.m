//
//  FMLoginViewController.m
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMLoginViewController.h"
#import "UIView+Extend.h"
#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "FMUserModel.h"
#import "FMLoginViewModel.h"

@interface FMLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIView      *contentView;
@property (nonatomic, strong) UILabel     *titleLab;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIImageView *phoneIconView;
@property (nonatomic, strong) UITextField *passworTextField;
@property (nonatomic, strong) UIImageView *passwordIconView;
@property (nonatomic, strong) UIButton    *loginButton;

@property (nonatomic, strong) FMLoginViewModel *adapter;

@end

@implementation FMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -- Events
#pragma mark 登录
- (void)loginAction:(UIButton *)sender {
    [SVProgressHUD show];
    [self.adapter loginWithAccount:self.phoneTextField.text password:self.passworTextField.text complete:^(BOOL isSuccess) {
        if (isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.window.rootViewController = [[MyTabBarController alloc] init];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self.view makeToast:self.adapter.errorString duration:2.0 position:CSToastPositionCenter];
            });
        }
    }];
}

#pragma mark -- Notification
#pragma mark 监听键盘收起
- (void)keyboardWillHide:(NSNotification *)notifiction {
    self.phoneTextField.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    self.passworTextField.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
}

#pragma mark -- Delegate
#pragma mark UITextFieldDelegate
#pragma mark 开始输入
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        self.phoneTextField.layer.borderColor = [UIColor systemColor].CGColor;
        self.passworTextField.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    } else {
        self.phoneTextField.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
        self.passworTextField.layer.borderColor = [UIColor systemColor].CGColor;
    }
}

#pragma mark 监听输入变化
- (void)changedTextField:(UITextField *)textField {
    if (!kIsEmptyString(self.phoneTextField.text)&&!kIsEmptyString(self.passworTextField.text)) {
        self.loginButton.enabled = YES;
        self.loginButton.backgroundColor  = [UIColor bm_colorGradientChangeWithSize:CGSizeMake(120, 46) direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHexString:@"#FFCC6A"] endColor:[UIColor colorWithHexString:@"#F9A406"]];
    } else {
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = [UIColor colorWithHexString:@"#E8E1D4"];
    }
}

#pragma mark -- Private Methods
#pragma mark 界面初始化
- (void)setupView {
    [self.view addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(190);
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(340);
    }];
    
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(21);
        make.top.mas_equalTo(self.contentView.mas_top).offset(60);
        make.height.mas_equalTo(24);
    }];
    
    [self.contentView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(26);
        make.height.mas_equalTo(46);
    }];
    
    [self.phoneTextField addSubview:self.phoneIconView];
    [self.phoneIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.centerY.equalTo(self.phoneTextField);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [self.contentView addSubview:self.passworTextField];
    [self.passworTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.top.mas_equalTo(self.phoneTextField.mas_bottom).offset(26);
        make.height.mas_equalTo(46);
    }];
    
    [self.passworTextField addSubview:self.passwordIconView];
    [self.passwordIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.centerY.equalTo(self.passworTextField);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.contentView addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.mas_equalTo(self.passworTextField.mas_bottom).offset(34);
        make.size.mas_equalTo(CGSizeMake(120, 46));
    }];
}


#pragma mark -- getters
#pragma mark 背景
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = ImageNamed(@"h_brg");
    }
    return _bgImgView;
}

#pragma mark contentView
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.layer.cornerRadius  = 10;
        [_contentView drawShadowColor:UIColor.blackColor offset:CGSizeMake(0, 0) opacity:0.1 radius:10];
    }
    return _contentView;
}

#pragma mark 标题
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont mediumFontWithSize:18];
        _titleLab.text = @"欢迎使用飞马外勤";
    }
    return _titleLab;
}

#pragma mark 手机号输入
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
        _phoneTextField.placeholder  = @"请输入手机号";
        _phoneTextField.textColor = UIColor.blackColor;
        _phoneTextField.font = [UIFont regularFontWithSize:16];
        _phoneTextField.layer.borderWidth = 1.0;
        _phoneTextField.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
        _phoneTextField.layer.cornerRadius = 23;
        _phoneTextField.delegate = self;
        _phoneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        [_phoneTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneTextField;
}

#pragma mark phone icon
- (UIImageView *)phoneIconView {
    if (!_phoneIconView) {
        _phoneIconView = [[UIImageView alloc] init];
        _phoneIconView.image = ImageNamed(@"login_phone");
    }
    return _phoneIconView;
}

#pragma mark 密码输入
- (UITextField *)passworTextField {
    if (!_passworTextField) {
        _passworTextField = [[UITextField alloc] init];
        _passworTextField.placeholder  = @"请输入密码";
        _passworTextField.textColor = UIColor.blackColor;
        _passworTextField.font = [UIFont regularFontWithSize:16];
        _passworTextField.layer.borderWidth = 1.0;
        _passworTextField.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
        _passworTextField.layer.cornerRadius = 23;
        _passworTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
        _passworTextField.secureTextEntry = YES;
        _passworTextField.delegate = self;
        _passworTextField.leftViewMode = UITextFieldViewModeAlways;
        [_passworTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passworTextField;
}

#pragma mark password icon
- (UIImageView *)passwordIconView {
    if (!_passwordIconView) {
        _passwordIconView = [[UIImageView alloc] init];
        _passwordIconView.image = ImageNamed(@"login_pwd");
    }
    return _passwordIconView;
}

#pragma mark 登录
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        _loginButton.backgroundColor  = [UIColor colorWithHexString:@"#E8E1D4"];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont regularFontWithSize:16];
        _loginButton.layer.cornerRadius = 23;
        _loginButton.clipsToBounds = YES;
        _loginButton.enabled = NO;
        [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (FMLoginViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMLoginViewModel alloc] init];
    }
    return _adapter;
}

@end
