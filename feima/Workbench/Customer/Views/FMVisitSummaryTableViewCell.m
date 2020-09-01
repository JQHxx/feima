//
//  FMVisitSummaryTableViewCell.m
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMVisitSummaryTableViewCell.h"
#import "FMImageCollectionView.h"

@interface FMVisitSummaryTableViewCell ()

@property (nonatomic,strong) FMImageCollectionView *photoView;
@property (nonatomic,strong) UILabel                *summayTitleLab;
@property (nonatomic,strong) UILabel                *summayLab;



@end

@implementation FMVisitSummaryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.photoView];
        [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(70);
        }];
        
        [self.contentView addSubview:self.summayTitleLab];
        [self.summayTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.photoView.mas_left);
            make.top.mas_equalTo(self.photoView.mas_bottom).offset(5);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.summayLab];
        [self.summayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.summayTitleLab.mas_left);
            make.top.mas_equalTo(self.summayTitleLab.mas_bottom).offset(5);
            make.right.mas_equalTo(-10);
            make.height.mas_greaterThanOrEqualTo(20);
        }];
        
        self.summayTitleLab.hidden = self.summayLab.hidden = YES;
    }
    return self;
}

#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMVisitRecordInfoModel *model = (FMVisitRecordInfoModel *)obj;
    self.photoView.images = [model.images componentsSeparatedByString:@","];
    if (kIsEmptyString(model.summary)) {
        self.summayTitleLab.hidden = self.summayLab.hidden = YES;
    } else {
        self.summayTitleLab.hidden = self.summayLab.hidden = NO;
        self.summayLab.text = model.summary;
    }
}

+ (CGFloat)getCellHeightWithModel:(FMVisitRecordInfoModel *)model {
    CGFloat cellHeight = 0.0;
    if (!kIsEmptyString(model.images)) {
        cellHeight += 80;
    }
    if (!kIsEmptyString(model.summary)) {
        CGFloat summaryH = [model.summary boundingRectWithSize:CGSizeMake(kScreen_Width-30, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:14]].height;
        cellHeight += summaryH + 40;
    }
    return cellHeight;
}

#pragma mark -- Getters
#pragma mark 图片
- (FMImageCollectionView *)photoView {
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _photoView = [[FMImageCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    return _photoView;
}

#pragma mark 拜访总结标题
- (UILabel *)summayTitleLab {
    if (!_summayTitleLab) {
        _summayTitleLab = [[UILabel alloc] init];
        _summayTitleLab.font = [UIFont regularFontWithSize:14];
        _summayTitleLab.textColor = [UIColor textBlackColor];
        _summayTitleLab.text = @"拜访总结:";
    }
    return _summayTitleLab;
}

#pragma mark 拜访总结
- (UILabel *)summayLab {
    if (!_summayLab) {
        _summayLab = [[UILabel alloc] init];
        _summayLab.font = [UIFont regularFontWithSize:14];
        _summayLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _summayLab.numberOfLines = 0;
    }
    return _summayLab;
}


@end
