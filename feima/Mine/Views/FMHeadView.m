//
//  FMHeadView.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMHeadView.h"

@interface FMHeadView ()

@property (nonatomic,strong) UIView      *bgView;
@property (nonatomic,strong) UIView      *rootView;
@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *departmentLabel;
@property (nonatomic,strong) UIImageView *arrowImgView;

@end

@implementation FMHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.rootView];
        [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(kNavBar_Height);
            make.size.mas_equalTo(CGSizeMake(kScreen_Width-20, 106));
        }];
        
        [self addSubview:self.headImgView];
        [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.rootView.mas_centerY);
            make.left.mas_equalTo(30);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.left.mas_equalTo(self.headImgView.mas_right).offset(6);
            make.height.mas_equalTo(28);
            make.width.mas_greaterThanOrEqualTo(65);
        }];
        
        [self addSubview:self.departmentLabel];
        [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.height.mas_equalTo(15);
            make.width.mas_greaterThanOrEqualTo(65);
        }];
        
        [self addSubview:self.arrowImgView];
        [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.rootView.mas_centerY);
            make.right.mas_equalTo(self.rootView.mas_right).offset(-25);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    return self;
}

#pragma mark -- Getters
#pragma mark 背景
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kNavBar_Height+90)];
        _bgView.backgroundColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake(kScreen_Width, kScreen_Width/2.0) direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHexString:@"#FFD562"] endColor:[UIColor colorWithHexString:@"#FC9611"]];
        [_bgView setCircleCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:36];
    }
    return _bgView;
}

- (UIView *)rootView {
    if (!_rootView) {
        _rootView = [[UIView alloc] init];
        _rootView.backgroundColor = [UIColor whiteColor];
        _rootView.layer.cornerRadius = 4;
//        _rootView.clipsToBounds = YES;
        [_rootView drawShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 5) opacity:0.2 radius:5];
    }
    return _rootView;
}

#pragma mark 头像
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.backgroundColor = [UIColor lightGrayColor];
    }
    return _headImgView;
}

#pragma mark 用户名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont mediumFontWithSize:20];
        _nameLabel.textColor = [UIColor textBlackColor];
        _nameLabel.text = @"测试客户";
    }
    return _nameLabel;
}

#pragma mark 部门
-(UILabel *)departmentLabel{
    if (!_departmentLabel) {
        _departmentLabel = [[UILabel alloc] init];
        _departmentLabel.backgroundColor = [UIColor colorWithHexString:@"#EFF4F9"];
        _departmentLabel.font = [UIFont regularFontWithSize:10];
        _departmentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _departmentLabel.text = @"部门:市场销售一部";
    }
    return _departmentLabel;
}

#pragma mark 箭头
-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.backgroundColor = [UIColor lightGrayColor];
    }
    return _arrowImgView;
}

@end
