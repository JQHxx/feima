//
//  FMImageCollectionViewCell.m
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMImageCollectionViewCell.h"

@interface FMImageCollectionViewCell ()

@property (nonatomic, strong) UIImageView  *myimgView;

@end

@implementation FMImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- Public methods
#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    NSString *imageUrl = (NSString *)obj;
    [self.myimgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage ctPlaceholderImage]];
}

+ (CGSize)itemSize {
    return CGSizeMake(68, 68);
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.myimgView];
    [self.myimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark -- Getters
#pragma mark 图片
- (UIImageView *)myimgView {
    if (!_myimgView) {
        _myimgView = [[UIImageView alloc] init];
        _myimgView.clipsToBounds = YES;
        _myimgView.layer.cornerRadius = 4;
        _myimgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _myimgView;
}

@end
