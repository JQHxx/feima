//
//  FMChangeViewController.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMChangeViewController.h"

@interface FMChangeViewController (){
    NSArray *titlesArr;
    NSArray *placeholdersArr;
}

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
    
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    for (NSInteger i=0; i<titlesArr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(18,kNavBar_Height+53*i+20, 65, 21)];
        lab.font = [UIFont regularFontWithSize:15];
        lab.textColor = [UIColor textBlackColor];
        lab.text = titlesArr[i];
        [self.view addSubview:lab];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(lab.right+10, lab.top-5, kScreen_Width - lab.right-20, 31)];
        textField.font = [UIFont mediumFontWithSize:14];
        textField.tag = i;
        textField.placeholder = placeholdersArr[i];
        [self.view addSubview:textField];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(18, lab.bottom+16, kScreen_Width-36, 1)];
        line.backgroundColor = [UIColor lineColor];
        [self.view addSubview:line];
    }
    
    UIButton *confirmBtn = [UIButton submitButtonWithFrame:CGRectMake(18,kNavBar_Height+titlesArr.count*53+50, kScreen_Width-36, 46) title:@"确认修改" target:self selector:@selector(confirmChangeAction:)];
    [self.view addSubview:confirmBtn];
    
}



@end
