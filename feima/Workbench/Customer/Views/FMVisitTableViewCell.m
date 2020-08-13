//
//  FMVisitTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMVisitTableViewCell.h"

@interface FMVisitTableViewCell ()

@property (nonatomic,strong) UILabel    *visitTitleLabel;
@property (nonatomic,strong) UIButton   *photoBtn;
@property (nonatomic,strong) UILabel    *summaryTitleLabel;
@property (nonatomic,strong) UITextView *summaryTextView;
@property (nonatomic,strong) UIView      *lineView;

@end

@implementation FMVisitTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
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
    
    [self.contentView addSubview:self.photoBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.visitTitleLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.contentView addSubview:self.summaryTitleLabel];
    [self.summaryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.photoBtn.mas_bottom).offset(15);
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
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 1));
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
- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [[UIButton alloc] init];
        [_photoBtn setTitle:@"+" forState:UIControlStateNormal];
        [_photoBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _photoBtn.titleLabel.font = [UIFont mediumFontWithSize:28];
        _photoBtn.layer.cornerRadius = 5;
        _photoBtn.layer.borderColor = [UIColor textBlackColor].CGColor;
        _photoBtn.layer.borderWidth = 1.0;
        _photoBtn.clipsToBounds = YES;
    }
    return _photoBtn;
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
    }
    return _summaryTextView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lineColor];
    }
    return _lineView;
}

@end
