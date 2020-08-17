//
//  FMPhotoCollectionViewCell.m
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMPhotoCollectionViewCell.h"

@interface FMPhotoCollectionViewCell ()

@property (nonatomic, strong) UIImageView  *myimgView;
@property (nonatomic, strong) UIButton     *deleteBtn;

@property (nonatomic, copy ) NSString      *imgUrl;

@end

@implementation FMPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

#pragma mark -- Public methods
#pragma mark 标示符
+ (NSString *)identifier {
     return NSStringFromClass(self);
}

+ (CGSize)itemSize {
    return CGSizeMake(60, 60);
}

#pragma mark 填充数据
- (void)fillDataWithImage:(NSString *)imageUrl showAdd:(BOOL)showAdd{
    if (showAdd) {
        self.myimgView.image = [UIImage imageNamed:@"image_add"];
        self.deleteBtn.hidden = YES;
    } else {
        self.imgUrl = imageUrl;
        [self.myimgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage ctPlaceholderImage]];
        self.deleteBtn.hidden = NO;
    }
}

#pragma mark -- Event response
#pragma mark 删除图片
- (void)deleteImageAction:(UIButton *)sender {
    if (self.deleteSeletedImage && !kIsEmptyString(self.imgUrl)) {
        self.deleteSeletedImage(self.imgUrl);
    }
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.myimgView];
    [self.myimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
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
        _myimgView.image = [UIImage imageNamed:@"image_add"];
    }
    return _myimgView;
}

#pragma mark 删除
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:ImageNamed(@"image_delete") forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}



@end
