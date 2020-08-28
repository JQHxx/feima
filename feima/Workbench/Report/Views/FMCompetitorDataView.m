//
//  FMCompetitorDataView.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCompetitorDataView.h"

@interface FMPieLayer : CAShapeLayer

@property (nonatomic,assign)CGFloat startAngle;
@property (nonatomic,assign)CGFloat endAngle;

@end

@implementation FMPieLayer


@end

#define kPieRandColor [UIColor colorWithRed:arc4random() % 255 / 255.0f green:arc4random() % 255 / 255.0f blue:arc4random() % 255 / 255.0f alpha:1.0f]

#define Hollow_Circle_Radius 30 //中间空心圆半径，默认为0实心
#define KMargin 0 //边缘间距

@interface FMCompetitorDataView (){
    CAShapeLayer *_maskLayer;
    CGFloat _radius;
    CGPoint _center;
}

@end

@implementation FMCompetitorDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //线的半径为扇形半径的一半，线宽是扇形半径->半径+线宽的一半=真实半径，这样就能画出圆形了
        _radius = (frame.size.width - KMargin*2)/4.f;
        _center = CGPointMake(_radius*2 + KMargin, _radius*2 + KMargin);
        //通过mask来控制显示区域
        _maskLayer = [CAShapeLayer layer];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithArcCenter:_center radius:self.bounds.size.width/4.f startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
        //设置边框颜色为不透明，则可以通过边框的绘制来显示整个view
        _maskLayer.strokeColor = [UIColor greenColor].CGColor;
        _maskLayer.lineWidth = self.bounds.size.width/2.f;
        //设置填充颜色为透明，可以通过设置半径来设置中心透明范围
        _maskLayer.fillColor = [UIColor clearColor].CGColor;
        _maskLayer.path = maskPath.CGPath;
        _maskLayer.strokeEnd = 0;
        self.layer.mask = _maskLayer;
    }
    return self;
}

#pragma mark -- Publish Methods
- (void)setDatas:(NSArray <NSNumber *>*)datas
          colors:(NSArray <UIColor *>*)colors{
    NSArray *newDatas = [self getPersentArraysWithDataArray:datas];
    UIBezierPath *piePath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius + Hollow_Circle_Radius startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    CGFloat start = 0.f;
    CGFloat end = 0.f;
    for (NSInteger i=0; i<newDatas.count; i++) {
        NSNumber *number = newDatas[i];
        UIColor *aColor = colors[i];
        end =  start + number.floatValue;
        CAShapeLayer *pieLayer = [CAShapeLayer layer];
        pieLayer.strokeStart = start;
        pieLayer.strokeEnd = end;
        pieLayer.lineWidth = _radius*2 - Hollow_Circle_Radius;
        pieLayer.strokeColor = aColor.CGColor;
        pieLayer.fillColor = [UIColor clearColor].CGColor;
        pieLayer.path = piePath.CGPath;
        [self.layer addSublayer:pieLayer];
        MyLog(@"start:%.2f,end:%.2f",start,end);
        
        start = end;
    }
}

- (void)stroke{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.f;
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat:1.f];
    //禁止还原
    animation.autoreverses = NO;
    //禁止完成即移除
    animation.removedOnCompletion = NO;
    //让动画保持在最后状态
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_maskLayer addAnimation:animation forKey:@"strokeEnd"];
}

#pragma mark -- Privite Methods
- (NSArray *)getPersentArraysWithDataArray:(NSArray *)datas {
    NSArray *newDatas = [datas sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return NSOrderedDescending;
        }else if ([obj1 floatValue] > [obj2 floatValue]){
            return NSOrderedAscending;
        }else{
            return NSOrderedSame;
        }
    }];
    
    NSMutableArray *persentArray = [NSMutableArray array];
    NSNumber *sum = [newDatas valueForKeyPath:@"@sum.floatValue"];
    for (NSNumber *number in newDatas) {
        [persentArray addObject:@(number.floatValue/sum.floatValue)];
    }
    return persentArray;
}

#pragma mark 添加文字
- (void)addTextLayerWithText:(NSString *)text frame:(CGRect)frame{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = text;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.fontSize = 10;
    textLayer.foregroundColor = [UIColor lightGrayColor].CGColor;
    textLayer.frame = frame;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.wrapped = NO;
    [self.layer addSublayer:textLayer];
}

@end
