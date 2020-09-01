//
//  FMHomepageViewController.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMHomepageViewController.h"
#import "FMCustomerHeadView.h"
#import "FMVisitTableViewCell.h"
#import "FMMainGoodsTableViewCell.h"
#import "FMCompetitorTableViewCell.h"
#import "FMVisitViewModel.h"
#import "FMLocationManager.h"
#import "FMGoodsModel.h"

@interface FMHomepageViewController ()<UITableViewDelegate,UITableViewDataSource,FMMainGoodsTableViewCellDelegate,FMCompetitorTableViewCellDelegate,FMVisitTableViewCellDelegate>{
    NSArray *titlesArr;
}

@property (nonatomic, strong) UIButton           *statisticsBtn;
@property (nonatomic, strong) FMCustomerHeadView *headerView;
@property (nonatomic, strong) UITableView        *mainTableView;
@property (nonatomic, strong) UIView             *leaveView; //离店

@property (nonatomic, strong) NSMutableArray  *expandArray;//记录section是否展开
@property (nonatomic, strong) FMVisitViewModel  *adapter;

@property (nonatomic, assign) NSInteger      enterTime;
@property (nonatomic, strong) FMAddressModel *myAddress;
@property (nonatomic, copy ) NSString  *visitImages; //拜访图片
@property (nonatomic, copy ) NSString  *visitSummary; //拜访总结
@property (nonatomic, copy ) NSString  *competitorDesc; //竞品上报说明
@property (nonatomic, copy ) NSString  *competitorImages; //竞品上报图片


@end

@implementation FMHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"客户主页";
    
    titlesArr = @[@"客户拜访",@"商品销售",@"库存上报",@"竞品上报"];
    for (NSInteger i=0; i<titlesArr.count; i++) {
        [self.expandArray addObject:@"0"];
    }
    
    NSString *currentDate = [NSDate currentDateTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.enterTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:currentDate format:@"yyyy-MM-dd HH:mm:ss"];
    
    [self setupUI];
    [self loadMainData];
    [self refreshLocation];
}


#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titlesArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.expandArray[section] isEqualToString:@"1"]) {
        if (section == 1) {
            return [self.adapter numberOfGoodsList];
        } else if (section == 2) {
            return [self.adapter numberOfStockGoodsList];
        } else {
            return 1;
        }
    } else {
        return 0;
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
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-35, 15, 20, 20)];
    if ([self.expandArray[section] isEqualToString:@"1"]) {
        imgView.image = ImageNamed(@"arrow_up");
    } else {
        imgView.image = ImageNamed(@"arrow_down");
    }
    [headerView addSubview:imgView];
    
    headerView.tag = section;
    [headerView addTapPressed:@selector(tapForfoldAction:) target:self];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FMVisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMVisitTableViewCell identifier] forIndexPath:indexPath];
        cell.cellDelegate = self;
        return cell;
    } else if (indexPath.section == 1 || indexPath.section == 2) {
        FMMainGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMMainGoodsTableViewCell identifier] forIndexPath:indexPath];
        cell.cellDelegate = self;
        FMGoodsModel *model;
        if (indexPath.section == 1) {
            model = [self.adapter getGoodsModelWithIndex:indexPath.row];
        } else {
            model = [self.adapter getStockGoodsModelWithIndex:indexPath.row];
        }
        [cell fillContentWithData:model];
        return cell;
    } else {
        FMCompetitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMCompetitorTableViewCell identifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellDelegate = self;
        cell.goodsArray = [self.adapter getAllCompeteGoodsList];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 300;
    } else if (indexPath.section == 3) {
        NSArray *arr = [self.adapter getAllCompeteGoodsList];
        return 200 + arr.count *140;
    } else {
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark -- Delegate
#pragma mark FMVisitTableViewCellDelegate
#pragma mark 添加拜访图片
- (void)visitTableViewCellDidUploadImages:(NSArray *)images {
    if (images.count > 0) {
        self.visitImages = [images componentsJoinedByString:@","];
    }
}

#pragma mark 拜访总结
- (void)visitTableViewCellDidEndEditWithText:(NSString *)text {
    self.visitSummary = text;
}

#pragma mark FMMainGoodsTableViewCellDelegate
#pragma mark 设置商品数量
- (void)mainGoodsTableViewCellDidUpdateQuantityWithGoods:(FMGoodsModel *)model {
    [self.adapter replaceGoodsModelWithNewGoods:model];
}

#pragma mark FMCompetitorTableViewCellDelegate
#pragma mark 设置竞品数量
- (void)competitorTableViewCellDidUpdateGoods:(FMGoodsModel *)model {
    [self.adapter replaceCompetitorGoodsModelWithNewGoods:model];
}

#pragma mark 竞品上报说明
- (void)competitorTableViewCellDidEndEditWithText:(NSString *)text {
    self.competitorDesc = text;
}

#pragma mark 竞品上报图片
- (void)competitorTableViewCellDidUploadImages:(NSArray *)images {
    if (images.count > 0) {
        self.competitorImages = [images componentsJoinedByString:@","];
    }
}


#pragma mark -- Events response
#pragma mark 展开折叠
- (void)tapForfoldAction:(UIGestureRecognizer *)sender {
    NSInteger tag = sender.view.tag;
    if ([self.expandArray[tag] isEqualToString:@"0"]) {
        [self.expandArray replaceObjectAtIndex:tag withObject:@"1"];
    } else {
        [self.expandArray replaceObjectAtIndex:tag withObject:@"0"];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:tag];
    [self.mainTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 离店
- (void)leaveAction:(UIButton *)sener {
    //拜访记录信息
    NSMutableDictionary *visitRecordInfo = [NSMutableDictionary dictionary];
    [visitRecordInfo safe_setValue:self.visitImages forKey:@"images"];
    [visitRecordInfo safe_setValue:self.visitSummary forKey:@"summary"];
    [visitRecordInfo safe_setValue:self.myAddress.detailAddress forKey:@"address"];
    [visitRecordInfo safe_setValue:@(self.myAddress.latitude) forKey:@"latitude"];
    [visitRecordInfo safe_setValue:@(self.myAddress.longitude) forKey:@"longitude"];
    [visitRecordInfo safe_setValue:@(self.customer.customerId) forKey:@"customerId"];
    [visitRecordInfo safe_setValue:@(self.enterTime) forKey:@"enterTime"];
    NSString *outTimeStr = [NSDate currentDateTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger outTime = [[FeimaManager sharedFeimaManager] timeSwitchTimestamp:outTimeStr format:@"yyyy-MM-dd HH:mm:ss"];
    [visitRecordInfo safe_setValue:@(outTime) forKey:@"outTime"];
    
    //商品信息
    NSMutableDictionary *goodSellInfo = [NSMutableDictionary dictionary];
    NSInteger goodsCount = [self.adapter numberOfGoodsList];
    for (NSInteger i=0; i<goodsCount; i++) {
        FMGoodsModel *model = [self.adapter getGoodsModelWithIndex:i];
        if (model.quantity > 0) {
            [goodSellInfo safe_setValue:@(model.quantity) forKey:[NSString stringWithFormat:@"%ld",model.goodsId]];
        }
    }
    MyLog(@"goodSellInfo:%@",goodSellInfo);
    
    //库存信息
    NSMutableArray *goodStockInfo = [[NSMutableArray alloc] init];
    
    
    
    //
    
    MyLog(@"visitRecordInfo:%@",visitRecordInfo);
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadMainData {
    kSelfWeak;
    [self.adapter loadEmployeeGoodsListWithComplete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.mainTableView reloadData];
        }
    }];
    
    [self.adapter loadSalesGoodsListWithComplete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.mainTableView reloadData];
        }
    }];
    
    [self.adapter loadCompeteGoodsListWithComplete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.mainTableView reloadData];
        }
    }];
}

#pragma mark 定位
- (void)refreshLocation {
    kSelfWeak;
    [[FMLocationManager sharedInstance] getAddressDetail:^(FMAddressModel *addressModel) {
        weakSelf.myAddress = addressModel;
    }];
}

#pragma mark 界面初始化
- (void)setupUI {
    [self.view addSubview:self.statisticsBtn];
    [self.statisticsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(kStatusBar_Height+6);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
}

#pragma mark -- Getters
#pragma mark 筛选
- (UIButton *)statisticsBtn {
    if (!_statisticsBtn) {
        _statisticsBtn = [[UIButton alloc] init];
        [_statisticsBtn setTitle:@"统计" forState:UIControlStateNormal];
        [_statisticsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _statisticsBtn.titleLabel.font = [UIFont mediumFontWithSize:14];
    }
    return _statisticsBtn;
}
 
#pragma mark 客户信息
- (FMCustomerHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[FMCustomerHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 140)];
        [_headerView displayViewWithData:self.customer];
    }
    return _headerView;
}

#pragma mark 离店
- (UIView *)leaveView {
    if (!_leaveView) {
        _leaveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 120)];
        UIButton *btn = [UIButton submitButtonWithFrame:CGRectMake(18, 40, kScreen_Width-36, 46) title:@"离店" target:self selector:@selector(leaveAction:)];
        [_leaveView addSubview:btn];
    }
    return _leaveView;
}

#pragma mark 客户列表
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableHeaderView = self.headerView;
        _mainTableView.tableFooterView = self.leaveView;
       NSArray* _tableCardsClsName = @[@"FMVisitTableViewCell",
                                       @"FMMainGoodsTableViewCell",
                                       @"FMCompetitorTableViewCell",
                                   ];
       for (NSString *cls in _tableCardsClsName) {
           Class card = NSClassFromString(cls);
           [_mainTableView registerClass:[card class] forCellReuseIdentifier:cls];
       }
    }
    return _mainTableView;
}

- (NSMutableArray *)expandArray {
    if (!_expandArray) {
        _expandArray = [[NSMutableArray alloc] init];
    }
    return _expandArray;
}

- (FMVisitViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMVisitViewModel alloc] init];
    }
    return _adapter;
}

@end
