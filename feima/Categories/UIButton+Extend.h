//
//  UIButton+Extend.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extend)

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
