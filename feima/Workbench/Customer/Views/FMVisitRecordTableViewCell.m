//
//  FMVisitRecordTableViewCell.m
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMVisitRecordTableViewCell.h"
#import "FMVisitGoodsTableViewCell.h"
#import "FMVisitCompeteTableViewCell.h"
#import "FMVisitSummaryTableViewCell.h"
#import "FMImageCollectionView.h"
#import "FMCustomerVisitModel.h"

@interface FMVisitRecordTableViewCell ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *titlesArr;
    NSArray *subTitlesArr;
}

@property (nonatomic, strong) UILabel        *timeLabel;
@property (nonatomic, strong) UILabel        *nameLabel;
@property (nonatomic, strong) UILabel        *addressLabel;
@property (nonatomic, strong) UITableView    *recordTableView;

@property (nonatomic, strong) FMCustomerVisitModel *visitModel;

@end

@implementation FMVisitRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titlesArr = @[@"商品销售",@"库存上报",@"竞品上报",@"客户拜访"];
        subTitlesArr = @[@"(本次销售量)",@"(客户现存数量)",@"(竞品陈列数量、进货数量)"];
        [self setupUI];
    }
    return self;
}

#pragma mark -- Public methods
#pragma mark 填充数据
- (void)fillContentWithData:(id)obj {
    self.visitModel = (FMCustomerVisitModel *)obj;
    FMCustomerModel *model = self.visitModel.customerInfo;
    self.timeLabel.text = [[FeimaManager sharedFeimaManager] timeWithTimeInterval:model.createTime format:@"yyyy年MM月dd日"];
    self.nameLabel.text = model.contactName;
    self.addressLabel.text = model.address;
    [self.recordTableView reloadData];
    
    CGFloat tableHeight = titlesArr.count * 50;
    tableHeight += self.visitModel.goodSellInfos.count * 80;
    tableHeight += self.visitModel.customerStockInfos.count *80;
    tableHeight += self.visitModel.competeGoodsInfos.count * 80;
    FMCompeteGoodsModel *competeModel = [self.visitModel.competeGoodsInfos safe_objectAtIndex:0];
    if (!kIsEmptyString(competeModel.desc)) {
        NSString *descStr = [NSString stringWithFormat:@"说明：%@",competeModel.desc];
        CGFloat descH = [descStr boundingRectWithSize:CGSizeMake(kScreen_Width-30, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:14]].height;
        tableHeight += descH;
    }
    if (!kIsEmptyString(competeModel.images)) {
        tableHeight += 90;
    }
    
    FMVisitRecordInfoModel *visitInfoModel = self.visitModel.visitRecordInfo;
    if (!kIsEmptyString(visitInfoModel.images)) {
        tableHeight += 80;
    }
    if (!kIsEmptyString(visitInfoModel.summary)) {
        CGFloat summaryH = [visitInfoModel.summary boundingRectWithSize:CGSizeMake(kScreen_Width-30, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:14]].height;
        tableHeight += summaryH + 40;
    }
    [self.recordTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableHeight);
    }];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titlesArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.visitModel.goodSellInfos.count;
    } else if (section == 1) {
        return self.visitModel.customerStockInfos.count;
    } else if (section == 2) {
        return self.visitModel.competeGoodsInfos.count;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 30)];
    titleLab.font = [UIFont mediumFontWithSize:16];
    titleLab.textColor = [UIColor textBlackColor];
    titleLab.text = titlesArr[section];
    [headerView addSubview:titleLab];
    
    if (section < 3) {
        UILabel *subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 30)];
        subTitleLab.font = [UIFont regularFontWithSize:12];
        subTitleLab.textColor = [UIColor colorWithHexString:@"#999999"];
        subTitleLab.text = subTitlesArr[section];
        [headerView addSubview:titleLab];
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        FMVisitCompeteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMVisitCompeteTableViewCell identifier]];
        FMCompeteGoodsModel *model = [self.visitModel.competeGoodsInfos safe_objectAtIndex:indexPath.row];
        [cell fillContentWithData:model];
        return cell;
    } else if (indexPath.section == 3) {
        FMVisitSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMVisitSummaryTableViewCell identifier]];
        [cell fillContentWithData:self.visitModel.visitRecordInfo];
        return cell;
    } else {
        FMVisitGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMVisitGoodsTableViewCell identifier]];
        if (indexPath.section == 0) {
            FMOrderSellModel *model = [self.visitModel.goodSellInfos safe_objectAtIndex:indexPath.row];
            [cell fillContentWithData:model];
        } else {
            FMCustomerStockModel *model = [self.visitModel.customerStockInfos safe_objectAtIndex:indexPath.row];
            [cell fillContentWithData:model];
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        FMCompeteGoodsModel *model = [self.visitModel.competeGoodsInfos safe_objectAtIndex:0];
        if (kIsEmptyString(model.images)&&kIsEmptyString(model.desc)) {
            return nil;
        } else {
            UIView *aView = [[UIView alloc] init];
            aView.backgroundColor = [UIColor whiteColor];
            
            CGFloat viewH = 5.0;
            if (!kIsEmptyString(model.desc)) {
                UILabel *descLab = [[UILabel alloc] init];
                descLab.textColor = [UIColor colorWithHexString:@"#666666"];
                descLab.font = [UIFont regularFontWithSize:14];
                descLab.numberOfLines = 0;
                descLab.text = [NSString stringWithFormat:@"说明：%@",model.desc];
                [aView addSubview:descLab];
                
                CGFloat descH = [descLab.text boundingRectWithSize:CGSizeMake(kScreen_Width-30, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:14]].height;
                descLab.frame = CGRectMake(20, 5, kScreen_Width-30, descH);
            
                viewH += descH+5.0;
            }
            if (!kIsEmptyString(model.images)) {
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                FMImageCollectionView *photoView = [[FMImageCollectionView alloc] initWithFrame:CGRectMake(20, viewH, kScreen_Width - 30, 70) collectionViewLayout:layout];
                photoView.images = [model.images componentsSeparatedByString:@","];
                [aView addSubview:photoView];
                
                viewH += 80;
            }
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, viewH-1, kScreen_Width, 1)];
            line.backgroundColor = [UIColor lineColor];
            [aView addSubview:line];
            
            aView.frame = CGRectMake(0, 0, kScreen_Width, viewH);
            return aView;
        }
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 3) {
        return 80;
    } else {
        return [FMVisitSummaryTableViewCell getCellHeightWithModel:self.visitModel.visitRecordInfo];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        FMCompeteGoodsModel *model = [self.visitModel.competeGoodsInfos safe_objectAtIndex:0];
        if (kIsEmptyString(model.images)&&kIsEmptyString(model.desc)) {
            return 0.01;
        } else {
            CGFloat viewHeight = 0.0;
            if (!kIsEmptyString(model.desc)) {
                NSString *descStr = [NSString stringWithFormat:@"说明：%@",model.desc];
                CGFloat descH = [descStr boundingRectWithSize:CGSizeMake(kScreen_Width-30, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:14]].height;
                viewHeight += descH;
            }
            if (!kIsEmptyString(model.images)) {
                viewHeight += 90;
            }
            return viewHeight;
        }
    } else {
        return 0.01;
    }
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(180, 20));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.timeLabel.mas_bottom);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.right.mas_equalTo(-20);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    
    [self.contentView addSubview:self.recordTableView];
    [self.recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-140);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark -- Getters
#pragma mark 时间
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont mediumFontWithSize:14];
        _timeLabel.textColor = [UIColor textBlackColor];
    }
    return _timeLabel;
}

#pragma mark 拜访人
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont regularFontWithSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _nameLabel;
}

#pragma mark 地址
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont regularFontWithSize:14];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

#pragma mark 上报信息
- (UITableView *)recordTableView {
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _recordTableView.showsVerticalScrollIndicator = NO;
        _recordTableView.dataSource = self;
        _recordTableView.delegate = self;
        _recordTableView.scrollEnabled = NO;
        NSArray* _tableCardsClsName = @[@"FMVisitGoodsTableViewCell",
                                        @"FMVisitCompeteTableViewCell",
                                        @"FMVisitSummaryTableViewCell",
                                    ];
        for (NSString *cls in _tableCardsClsName) {
            Class card = NSClassFromString(cls);
            [_recordTableView registerClass:[card class] forCellReuseIdentifier:cls];
        }
    }
    return _recordTableView;
}

@end
