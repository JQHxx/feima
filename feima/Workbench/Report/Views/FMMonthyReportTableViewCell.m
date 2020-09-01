//
//  FMMonthyReportTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/28.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMonthyReportTableViewCell.h"
#import "FMMonthyReportModel.h"

#define kMyWidth (kScreen_Width-16)/3.0

@interface FMMonthyReportTableViewCell ()

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *toWorkLabel;
@property (nonatomic,strong) UILabel *offWorkLabel;

@end

@implementation FMMonthyReportTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.toWorkLabel];
        [self.contentView addSubview:self.offWorkLabel];
    }
    return self;
}

#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    FMMonthyReportModel *model = (FMMonthyReportModel *)obj;
    self.nameLabel.text = model.employeeName;
    self.toWorkLabel.text = [NSString stringWithFormat:@"%ld/%ld",model.punchInNumber,model.punchInAbnormalNumber];
    self.offWorkLabel.text = [NSString stringWithFormat:@"%ld/%ld",model.punchOutNumber,model.punchOutAbnormalNumber];
}

#pragma mark -- Private methods
#pragma mark setup label
- (UILabel *)setupLabelWithOriginX:(CGFloat)originX {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(originX, 15, kMyWidth, 24)];
    lab.font = [UIFont regularFontWithSize:14];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

#pragma mark -- Getters
#pragma mark 姓名
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [self setupLabelWithOriginX:0];
    }
    return _nameLabel;
}

#pragma mark 上班
- (UILabel *)toWorkLabel {
    if (!_toWorkLabel) {
        _toWorkLabel = [self setupLabelWithOriginX:kMyWidth];
    }
    return _toWorkLabel;
}

#pragma mark 下班
- (UILabel *)offWorkLabel {
    if (!_offWorkLabel) {
        _offWorkLabel = [self setupLabelWithOriginX:kMyWidth*2];
    }
    return _offWorkLabel;
}

@end
