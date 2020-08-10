//
//  FMWorkCollectionViewCell.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMWorkCollectionViewCell.h"

@interface FMWorkCollectionViewCell ()


@end

@implementation FMWorkCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImgView];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.mas_equalTo(self.iconImgView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
    }
    return self;
}

#pragma mark -- Getters
#pragma mark 图标
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

#pragma mark 标题
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont mediumFontWithSize:12];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor textBlackColor];
    }
    return _titleLab;
}

@end
