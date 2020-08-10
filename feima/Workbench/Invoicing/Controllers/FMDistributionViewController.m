//
//  FMDistributionViewController.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDistributionViewController.h"
#import "FMDistributionTableViewCell.h"
#import "FMGoodsModel.h"

@interface FMDistributionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView      *myTableView;
@property (nonatomic, strong) NSMutableArray   *goodsArray;

@end

@implementation FMDistributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"申请配货";
    
    [self.view addSubview:self.myTableView];
    [self loadGoodsData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMDistributionTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMGoodsModel *model = self.goodsArray[indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

#pragma mark -- Private methods
#pragma mark load data
- (void)loadGoodsData {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<15; i++) {
        FMGoodsModel *model = [[FMGoodsModel alloc] init];
        model.name = @"口味王20";
        model.categoryName = @"本品";
        model.stock = 1000000;
        [tempArr addObject:model];
    }
    self.goodsArray = tempArr;
    [self.myTableView reloadData];
}

#pragma mark -- Getters
#pragma mark 商品列表
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBar_Height, kScreen_Width, kScreen_Height-kNavBar_Height) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_myTableView registerClass:[FMDistributionTableViewCell class] forCellReuseIdentifier:[FMDistributionTableViewCell identifier]];
    }
    return _myTableView;
}

- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [[NSMutableArray alloc] init];
    }
    return _goodsArray;
}

@end
