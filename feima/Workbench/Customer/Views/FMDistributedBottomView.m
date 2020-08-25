//
//  FMDistributedBottomView.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDistributedBottomView.h"

@interface FMDistributedBottomView ()

@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UIImageView *arrowImgView;

@end

@implementation FMDistributedBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self drawShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 0) opacity:0.2 radius:4];
        self.layer.cornerRadius = 4;
        self.userInteractionEnabled = YES;
        
        [self addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_greaterThanOrEqualTo(125);
        }];
        
        [self addSubview:self.arrowImgView];
        [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.numLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return self;
}

#pragma mark
- (void)setType:(FMDistributedBottomViewType)type {
    _type = type;
    if (type == FMDistributedBottomViewTypeCustomer) {
        self.numLabel.text = @"当前区域客户共0个";
    } else {
        self.numLabel.text = @"总人数0个 当前在线 0 当天在线 0 离线 0";
    }
}

#pragma mark 客户数
- (void)setCustomerCount:(long)customerCount {
    _customerCount = customerCount;
    MyLog(@"customerCount:%ld",customerCount);
    self.numLabel.text = [NSString stringWithFormat:@"当前区域客户共%ld个",customerCount];
}

#pragma mark -- Getters
#pragma mark 名称
- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont mediumFontWithSize:16];
        _numLabel.textColor = [UIColor colorWithHexString:@"#5B370D"];
        _numLabel.userInteractionEnabled = YES;
    }
    return _numLabel;
}

#pragma mark 箭头
- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = ImageNamed(@"arrow_up");
        _arrowImgView.userInteractionEnabled = YES;
    }
    return _arrowImgView;
}

@end
