//
//  UIView+Extend.h
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Extend)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

/*设置阴影
*  @param shadowColor 阴影颜色
*  @param offset 阴影偏移量
*  @param opacity 透明度
*  @param radius 阴影半径
 */
- (void)drawShadowColor: (UIColor *)shadowColor
                 offset: (CGSize)offset
                opacity: (CGFloat)opacity
                 radius: (CGFloat)radius;

/*
 *绘制圆角
 * @param corners 角度方向
 * @param radius 角度
 */
- (void)setCircleCorner:(UIRectCorner)corners
                 radius: (CGFloat)radius;

/*
* 添加点击事件
* @param tapViewPressed 点击事件
* @param target 事件对象
*/
- (void)addTapPressed:(SEL)tapViewPressed target:(id)target;

@end

