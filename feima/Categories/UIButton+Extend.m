//
//  UIButton+Extend.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "UIButton+Extend.h"

@implementation UIButton (Extend)

#pragma mark 设置button的titleLabel和imageView的布局样式
- (void)ctfLayoutButtonWithEdgeInsetsStyle:(CTFButtonEdgeInsetsType)style
                           imageTitleSpace:(CGFloat)space {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = self.imageView.frame.size.width;
        CGFloat imageHeight = self.imageView.frame.size.height;
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
        
        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
        UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
        
        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch (style) {
            case CTFButtonEdgeInsetsType_ImageTop: {
                imageWith = self.imageView.intrinsicContentSize.width;
                imageHeight = self.imageView.intrinsicContentSize.height;
                
                imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, -labelHeight, 0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
            }
                break;
                
            case CTFButtonEdgeInsetsType_ImageLeft: {
                imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
            }
                break;
                
            case CTFButtonEdgeInsetsType_ImageBottom: {
                imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
            }
                break;
                
            case CTFButtonEdgeInsetsType_ImageRight: {
                imageWith = self.imageView.intrinsicContentSize.width;
                imageHeight = self.imageView.intrinsicContentSize.height;
                
                imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
            }
                break;
                
            default:
                break;
                
        }
        
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
}

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
