//
//  FMCompetitorTableViewCell.m
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCompetitorTableViewCell.h"

@interface FMCompetitorTableViewCell ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titlesArr;
    NSArray *goodsArr;
}

@property (nonatomic,strong) UIView      *lineView;
@property (nonatomic,strong) UIView      *bottomView;
@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) UIView      *line1;
@property (nonatomic,strong) UILabel     *descTitleLabel;
@property (nonatomic,strong) UITextView  *descTextView; //说明
@property (nonatomic,strong) UIView      *line2;
@property (nonatomic,strong) UILabel     *photoTitleLabel;
@property (nonatomic,strong) UIButton    *photoBtn;  //图片

@end

@implementation FMCompetitorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        goodsArr = @[@"20张新发",@"15张新发"];
        titlesArr = @[@"陈列数量",@"进货数量"];
        
        [self setupUI];
        
    }
    return self;
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return goodsArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titlesArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 150, 30)];
    titleLab.font = [UIFont mediumFontWithSize:14];
    titleLab.textColor = [UIColor textBlackColor];
    titleLab.text = goodsArr[section];
    [headerView addSubview:titleLab];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 150, 30)];
    titleLab.font = [UIFont regularFontWithSize:14];
    titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLab.text = titlesArr[indexPath.row];
    [cell.contentView addSubview:titleLab];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 1));
    }];
    
    [self.bottomView addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-40, 1));
    }];
    
    [self.bottomView addSubview:self.descTitleLabel];
    [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.bottomView addSubview:self.descTextView];
    [self.descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.descTitleLabel.mas_left);
        make.top.mas_equalTo(self.descTitleLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-40, 40));
    }];
    
    [self.bottomView addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.descTitleLabel.mas_left);
        make.top.mas_equalTo(self.descTextView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-40, 1));
    }];
    
    [self.bottomView addSubview:self.photoTitleLabel];
    [self.photoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.descTitleLabel.mas_left);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.bottomView addSubview:self.photoBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.descTitleLabel.mas_left);
        make.top.mas_equalTo(self.photoTitleLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

#pragma mark -- Getters
- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor lineColor];
    }
    return _line1;
}

#pragma mark 标题
- (UILabel *)descTitleLabel {
    if (!_descTitleLabel) {
        _descTitleLabel = [[UILabel alloc] init];
        _descTitleLabel.font = [UIFont regularFontWithSize:14];
        _descTitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _descTitleLabel.text = @"说明";
    }
    return _descTitleLabel;
}

#pragma mark 说明
- (UITextView *)descTextView {
    if (!_descTextView) {
        _descTextView = [[UITextView alloc] init];
        _descTextView.font = [UIFont regularFontWithSize:14];
    }
    return _descTextView;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor lineColor];
    }
    return _line2;
}

#pragma mark 图片标题
- (UILabel *)photoTitleLabel {
    if (!_photoTitleLabel) {
        _photoTitleLabel = [[UILabel alloc] init];
        _photoTitleLabel.font = [UIFont regularFontWithSize:14];
        _photoTitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _photoTitleLabel.text = @"添加照片";
    }
    return _photoTitleLabel;
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

#pragma mark 说明
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 150)];
    }
    return _bottomView;
}

#pragma mark 竞品
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.tableFooterView = self.bottomView;
    }
    return _myTableView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lineColor];
    }
    return _lineView;
}



@end
