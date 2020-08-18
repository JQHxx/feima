//
//  UIButton+Extend.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CTFButtonEdgeInsetsType){
    CTFButtonEdgeInsetsType_ImageTop,       // image在上，label在下
    CTFButtonEdgeInsetsType_ImageLeft,      // image在左，label在右
    CTFButtonEdgeInsetsType_ImageBottom,    // image在下，label在上
    CTFButtonEdgeInsetsType_ImageRight      // image在右，label在左
};

@interface UIButton (Extend)

/**
 * 根据按钮中的现有内容，设置button的titleLabel和imageView的布局样式，及间距
 * @param style titleLabel和imageView的布局样式
 * @param space titleLabel和imageView的间距
 * ⚠️如果对图片或者文字进行更换后，必须再次调用此方法。
 */
- (void)ctfLayoutButtonWithEdgeInsetsStyle:(CTFButtonEdgeInsetsType)style imageTitleSpace:(CGFloat)space;

/*
 * 创建提交按钮
 * @param frame 所在位置及大小
 * @param title 标题
 * @param target 事件对应目标
 * @param selector 按钮事件
 */
+ (UIButton *)submitButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                             target:(id)target
                           selector:(SEL)selector;

/*
 * 创建添加按钮
 * @param target 事件对应目标
 * @param selector 按钮事件
*/
+ (UIButton *)addButtonWithTarget:(id)target
                         selector:(SEL)selector;;

@end

NS_ASSUME_NONNULL_END
