//
//  FMChangeViewController.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMChangeViewController.h"
#import "FMUserViewModel.h"

@interface FMChangeViewController (){
    NSArray *titlesArr;
    NSArray *placeholdersArr;
}

@property (nonatomic,strong) UITextField *phoneText;
@property (nonatomic,strong) UITextField *oldPwdText;
@property (nonatomic,strong) UITextField *pwdText;
@property (nonatomic,strong) UITextField *confirmPwdText;

@property (nonatomic,strong) FMUserViewModel *adapter;


@end

@implementation FMChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = self.isChangingPwd ? @"修改密码" : @"更改手机号";
    titlesArr = self.isChangingPwd ? @[@"旧密码",@"新密码",@"再输一次",]: @[@"新手机号"];
    placeholdersArr = self.isChangingPwd ? @[@"请输入旧密码",@"请输入新密码",@"请再次输入新密码",]: @[@"请输入新手机号"];
    
    [self setupUI];
}

#pragma mark -- Events
#pragma mark 确认修改
- (void)confirmChangeAction:(UIButton *)sender {
    NSString *account = [FeimaManager sharedFeimaManager].userBean.account;
    if (self.isChangingPwd) {
        if (kIsEmptyString(self.oldPwdText.text)||kIsEmptyString(self.pwdText.text)||kIsEmptyString(self.confirmPwdText.text)) {
            [self.view makeToast:@"请完成输入后再点击修改密码" duration:1.5 position:CSToastPositionCenter];
            return;
        }
        if (![self.pwdText.text isEqualToString:self.confirmPwdText.text]) {
            [self.view makeToast:@"两次输入的密码不同，请仔细核对后重试" duration:1.5 position:CSToastPositionCenter];
            return;
        }
        kSelfWeak;
        [self.adapter updateUserPasswordWithOldPassword:self.oldPwdText.text password:self.pwdText.text account:account complete:^(BOOL isSuccess) {
            if (isSuccess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatePasswordSuccessNotification object:nil];
                [[FeimaManager sharedFeimaManager] logout];
            } else {
                [weakSelf.view makeToast:weakSelf.adapter.errorString duration:1.5 position:CSToastPositionCenter];
            }
        }];
    } else {
        if (kIsEmptyString(self.phoneText.text)) {
            [self.view makeToast:@"手机号不能为空" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        kSelfWeak;
        [self.adapter updateUserTelephoneWithTelephone:self.phoneText.text account:account complete:^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf.view makeToast:weakSelf.adapter.errorString duration:1.5 position:CSToastPositionCenter];
            }
        }];
    }
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    for (NSInteger i=0; i<titlesArr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(18,kNavBar_Height+53*i+20, 65, 21)];
        lab.font = [UIFont regularFontWithSize:16];
        lab.textColor = [UIColor textBlackColor];
        lab.text = titlesArr[i];
        [self.view addSubview:lab];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(lab.right+10, lab.top-5, kScreen_Width - lab.right-20, 31)];
        textField.font = [UIFont mediumFontWithSize:16];
        textField.tag = i;
        textField.placeholder = placeholdersArr[i];
        [self.view addSubview:textField];
        
        if (self.isChangingPwd) {
            if (i == 0) {
                self.oldPwdText = textField;
            } else if (i == 1) {
                self.pwdText = textField;
            } else {
                self.confirmPwdText = textField;
            }
        } else {
            self.phoneText = textField;
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(18, lab.bottom+16, kScreen_Width-36, 1)];
        line.backgroundColor = [UIColor lineColor];
        [self.view addSubview:line];
    }
    
    UIButton *confirmBtn = [UIButton submitButtonWithFrame:CGRectMake(18,kNavBar_Height+titlesArr.count*53+50, kScreen_Width-36, 46) title:@"确认修改" target:self selector:@selector(confirmChangeAction:)];
    [self.view addSubview:confirmBtn];
    
}

- (FMUserViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMUserViewModel alloc] init];
    }
    return _adapter;
}

@end
