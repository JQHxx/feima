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

#define KMargin 20 //边缘间距

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
        _radius = (frame.size.height - KMargin*2)/4.f;
        _center = CGPointMake(_radius*2 + KMargin, _radius*2 + KMargin);
        //通过mask来控制显示区域
        _maskLayer = [CAShapeLayer layer];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithArcCenter:_center radius:self.height/4.f startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
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
    //每个layer对应一个path，通过数据比例来计算起始角点跟结束角点；可以通过path来找到对应的layer，方便做后期操作
    CGFloat start = -M_PI_2;
    CGFloat end = start;
    
    while (newDatas.count > self.layer.sublayers.count) {
        FMPieLayer *pieLayer = [FMPieLayer layer];
        pieLayer.strokeColor = NULL;
        [self.layer addSublayer:pieLayer];
    }

    for (int i = 0; i < self.layer.sublayers.count; i ++) {
        FMPieLayer *pieLayer = (FMPieLayer *)self.layer.sublayers[i];
        if (i < newDatas.count) {
            pieLayer.hidden = NO;
            end =  start + M_PI*2 *[newDatas[i] floatValue];
            
            UIBezierPath *piePath = [UIBezierPath bezierPath];
            [piePath moveToPoint:_center];
            [piePath addArcWithCenter:_center radius:_radius*2 startAngle:start endAngle:end clockwise:YES];
            pieLayer.fillColor = [colors.count > i?colors[i]:kPieRandColor CGColor];
            pieLayer.startAngle = start;
            pieLayer.endAngle = end;
            pieLayer.path = piePath.CGPath;
            
            start = end;
        }else{
            pieLayer.hidden = YES;
        }
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

@end
