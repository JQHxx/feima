//
//  FMMineTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMineTableViewCell.h"

@interface FMMineTableViewCell ()

@property (nonatomic,strong) UIView      *rootView;
@property (nonatomic,strong) UIImageView *arrowImgView;

@end

@implementation FMMineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor bgColor];
        
        [self.contentView addSubview:self.rootView];
        [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(kScreen_Width-15, 46));
        }];
        
        [self.rootView addSubview:self.iconImgView];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.rootView.mas_centerY);
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        
        [self.rootView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImgView.mas_top);
            make.left.mas_equalTo(self.iconImgView.mas_right).offset(10);
            make.height.mas_equalTo(24);
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
- (UIView *)rootView {
    if (!_rootView) {
        _rootView = [[UIView alloc] init];
        _rootView.backgroundColor = [UIColor whiteColor];
    }
    return _rootView;
}

#pragma mark 头像
-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont mediumFontWithSize:16];
        _titleLabel.textColor = [UIColor textBlackColor];
    }
    return _titleLabel;
}

#pragma mark 箭头
-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = ImageNamed(@"arrow_right");
    }
    return _arrowImgView;
}

@end
