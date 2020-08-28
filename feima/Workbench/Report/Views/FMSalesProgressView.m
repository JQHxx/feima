//
//  FMSalesProgressView.m
//  feima
//
//  Created by fei on 2020/8/27.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSalesProgressView.h"

#define kCirleRadius 84

@interface FMSalesProgressView ()

@property (nonatomic, strong) CAShapeLayer  *bgLayer;
@property (nonatomic, strong) CAShapeLayer  *maskLayer;
@property (nonatomic, strong) UILabel       *progressLabel;
@property (nonatomic, strong) UILabel       *valueLabel;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *descLabel;

@end

@implementation FMSalesProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark -- Publish Methods
- (void)startRendering {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(kCirleRadius/2.f+10, kCirleRadius/2.f) radius:(kCirleRadius - 16)/2.f startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    self.bgLayer.path = [path CGPath];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath addArcWithCenter:CGPointMake(kCirleRadius/2.f+10,kCirleRadius/2.f) radius:(kCirleRadius - 16)/2.f startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    self.maskLayer.path = [path CGPath];
    self.maskLayer.strokeEnd = 0;
    [self.maskLayer addAnimation:[self basicAnimationWithKey:@"strokeEnd"  toValue:@(self.progress)] forKey:@"strokeEnd"];
}

#pragma mark -- Private Methods
- (void)setup{
    [self.layer addSublayer:self.bgLayer];
    [self.layer addSublayer:self.maskLayer];
    [self addSubview:self.valueLabel];
    [self addSubview:self.progressLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.descLabel];
}

#pragma mark -- Animation
- (CABasicAnimation *)basicAnimationWithKey:(NSString *)key toValue:(NSValue *)toValue{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 1.0;
    animation.repeatCount = 1;
    animation.toValue = toValue;
    //禁止还原
    animation.autoreverses = NO;
    //禁止完成即移除
    animation.removedOnCompletion = NO;
    //让动画保持在最后状态
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

#pragma mark -- Lazzy
- (CAShapeLayer *)bgLayer{
    if(!_bgLayer){
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.lineWidth = 16;
        _bgLayer.strokeColor = RGB(249, 243, 229).CGColor;
        _bgLayer.fillColor = [UIColor clearColor].CGColor;
        _bgLayer.lineCap = kCALineCapRound;
    }
    return _bgLayer;
}

- (CAShapeLayer *)maskLayer{
    if(!_maskLayer){
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillColor = [UIColor clearColor].CGColor;
        _maskLayer.lineWidth = 16;
        _maskLayer.strokeColor = [UIColor colorWithHexString:@"#FBD437"].CGColor;
        _maskLayer.lineCap = kCALineCapSquare;
    }
    return _maskLayer;
}

#pragma mark 百分比进度
- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCirleRadius+15, 10, 65, 20)];
        _progressLabel.textColor = [UIColor colorWithHexString:@"#FBD437"];
        _progressLabel.font = [UIFont regularFontWithSize:13];
    }
    return _progressLabel;
}

#pragma mark 数值
- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 20)];
        _valueLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _valueLabel.font = [UIFont regularFontWithSize:10];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.center = CGPointMake(kCirleRadius/2.0+10, kCirleRadius/2.0);
    }
    return _valueLabel;
}

#pragma mark 标题
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,kCirleRadius+5, kCirleRadius+20, 20)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont mediumFontWithSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"销售环比进度";
    }
    return _titleLabel;
}

#pragma mark 描述
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.titleLabel.bottom,kCirleRadius+20, 14)];
        _descLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _descLabel.font = [UIFont regularFontWithSize:10];
        _descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descLabel;
}

#pragma mark 进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    MyLog(@"progress:%.2f",progress);
    if(_progress > 1.0f) _progress = 1.f;
}

#pragma mark 进度百分比显示
- (void)setProgressStr:(NSString *)progressStr {
    _progressStr = progressStr;
    self.progressLabel.text = kIsEmptyString(progressStr) ? @"" : progressStr;
}

#pragma mark
- (void)setValueStr:(NSString *)valueStr {
    _valueStr = valueStr;
    if (!kIsEmptyString(valueStr)) {
        self.valueLabel.text = valueStr;
        self.descLabel.text = [NSString stringWithFormat:@"本月总销售:%@",valueStr];
    }
}

@end
