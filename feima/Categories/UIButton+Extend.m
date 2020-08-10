//
//  UIButton+Extend.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "UIButton+Extend.h"

@implementation UIButton (Extend)

#pragma mark 创建提交按钮
+ (UIButton *)submitButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                             target:(id)target
                           selector:(SEL)selector {
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont mediumFontWithSize:16];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake(kScreen_Width-36, 46) direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHexString:@"#FC9611"] endColor:[UIColor colorWithHexString:@"#FFD562"]];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark 添加按钮
+ (UIButton *)addButtonWithTarget:(id)target selector:(SEL)selector {
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont mediumFontWithSize:36];
    addBtn.backgroundColor = [UIColor systemColor];
    addBtn.layer.cornerRadius = 30;
    addBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    [addBtn drawShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 10) opacity:0.5 radius:10];
    [addBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return addBtn;
}

@end
