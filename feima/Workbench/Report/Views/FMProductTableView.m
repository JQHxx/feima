//
//  FMProductTableView.m
//  feima
//
//  Created by fei on 2020/8/10.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMProductTableView.h"
#import "FMGoodsSalesModel.h"

@interface FMProductTableView ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation FMProductTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.separatorInset = UIEdgeInsetsZero;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FMGoodsSalesModel *goods = self.goodsArray[indexPath.row];
    NSArray *arr = @[goods.goodsName,[NSString stringWithFormat:@"%.f(%.f%%)",goods.lastSales,goods.lastSalesSumProgress],[NSString stringWithFormat:@"%.f(%.f%%)",goods.thisSales,goods.thisSalesSumProgress]];
    for (NSInteger i=0; i<arr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kReportWidth*i, 10, kReportWidth, 24)];
        lab.font = [UIFont mediumFontWithSize:14];
        lab.textColor = [UIColor colorWithHexString:@"#666666"];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = arr[i];
        [cell.contentView addSubview:lab];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)setGoodsArray:(NSArray *)goodsArray {
    _goodsArray = goodsArray;
    [self reloadData];
}

@end
