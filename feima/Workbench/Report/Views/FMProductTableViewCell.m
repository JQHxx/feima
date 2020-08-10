//
//  FMProductTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/7.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMProductTableViewCell.h"

@interface FMProductTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;        //业务员或部门
@property (nonatomic, strong) UILabel *lastMonthLabel;   //上月销量
@property (nonatomic, strong) UILabel *monthLabel;       //本月销量
@property (nonatomic, strong) UILabel *progressLabel;    //完成进度

@end

@implementation FMProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
