//
//  FMVisitTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMVisitTableViewCell.h"
#import "FMPhotoCollectionView.h"

@interface FMVisitTableViewCell ()<UITextViewDelegate>

@property (nonatomic,strong) UILabel    *visitTitleLabel;
@property (nonatomic,strong) FMPhotoCollectionView   *photoView;
@property (nonatomic,strong) UILabel    *summaryTitleLabel;
@property (nonatomic,strong) UITextView *summaryTextView;

@end

@implementation FMVisitTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    MyLog(@"text:%@",textView.text);
    if ([self.cellDelegate respondsToSelector:@selector(visitTableViewCellDidEndEditWithText:)]) {
        [self.cellDelegate visitTableViewCellDidEndEditWithText:textView.text];
    }
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.visitTitleLabel];
    [self.visitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [self.contentView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.visitTitleLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-40, 68));
    }];
    
    [self.contentView addSubview:self.summaryTitleLabel];
    [self.summaryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.photoView.mas_bottom).offset(15);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [self.contentView addSubview:self.summaryTextView];
    [self.summaryTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.summaryTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(150);
    }];
}

#pragma mark -- Getters
#pragma mark 拜访客户
- (UILabel *)visitTitleLabel {
    if (!_visitTitleLabel) {
        _visitTitleLabel = [[UILabel alloc] init];
        _visitTitleLabel.font = [UIFont regularFontWithSize:14];
        _visitTitleLabel.textColor = [UIColor textBlackColor];
        _visitTitleLabel.text = @"拜访的客户";
    }
    return _visitTitleLabel;
}

#pragma mark 客户图片
- (FMPhotoCollectionView *)photoView {
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _photoView = [[FMPhotoCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _photoView.maxImagesCount = 3;
        kSelfWeak;
        _photoView.handleComplete = ^{
            NSArray *images = [weakSelf.photoView getAllImages];
            if ([weakSelf.cellDelegate respondsToSelector:@selector(visitTableViewCellDidUploadImages:) ]) {
                [weakSelf.cellDelegate visitTableViewCellDidUploadImages:images];
            }
        };
    }
    return _photoView;
}


#pragma mark 拜访总结
- (UILabel *)summaryTitleLabel {
    if (!_summaryTitleLabel) {
        _summaryTitleLabel = [[UILabel alloc] init];
        _summaryTitleLabel.font = [UIFont regularFontWithSize:14];
        _summaryTitleLabel.textColor = [UIColor textBlackColor];
        _summaryTitleLabel.text = @"拜访总结";
    }
    return _summaryTitleLabel;
}

#pragma mark 总结描述
- (UITextView *)summaryTextView {
    if (!_summaryTextView) {
        _summaryTextView = [[UITextView alloc] init];
        _summaryTextView.layer.borderWidth = 1.0;
        _summaryTextView.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        _summaryTextView.layer.cornerRadius = 4.0;
        _summaryTextView.font = [UIFont regularFontWithSize:16];
        _summaryTextView.delegate = self;
    }
    return _summaryTextView;
}

@end
