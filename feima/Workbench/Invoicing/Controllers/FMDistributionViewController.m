//
//  FMDistributionViewController.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDistributionViewController.h"
#import "FMDistributionTableViewCell.h"
#import "FMOrderViewModel.h"

@interface FMDistributionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView      *myTableView;
@property (nonatomic, strong) FMOrderViewModel *orderAdapter;

@property (nonatomic, strong) UIButton         *shipBtn; //发货
@property (nonatomic, strong) UIButton         *refuseBtn; //拒绝配货  拒绝退换货
@property (nonatomic, strong) UIButton         *agreeBtn; //同意配货 同意退换货

@property (nonatomic, assign) NSInteger        myType;

@end

@implementation FMDistributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = self.type == 0 ? @"申请配货" : @"申请退换货";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    
    if ([self.orderType isEqualToString:@"DISTRITUTION"]) {
        self.myType = 0;
    } else if ([self.orderType isEqualToString:@"RETURN"]) {
        self.myType = 1;
    } else {
        self.myType = 2;
    }
    
    [self setupUI];
    [self loadDistributionDetailsData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orderAdapter numberOfOrderGoodsList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMDistributionTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMOrderDetaiModel  *model = [self.orderAdapter getOrderGoodsModelWithIndex:indexPath.row];
    FMGoodsModel *goods = model.goods;
    goods.quantity = model.orderGoodsDetail.applyNum;
    [cell fillContentWithData:goods type:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

#pragma mark -- Event response
#pragma mark 发货 确认收货
- (void)shipAction:(UIButton *)sender {
    kSelfWeak;
    if (self.status == 4 || self.status == 24) { //确认收货
        [self.orderAdapter confirmReceiptWithType:self.myType orderGoodsId:self.orderGoodsId complete:^(BOOL isSuccess) {
            if (isSuccess) {
                [FeimaManager sharedFeimaManager].distributionListReload = YES;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf.view makeToast:weakSelf.orderAdapter.errorString duration:1.5 position:CSToastPositionCenter];
            }
        }];
    } else { //发货
        [self.orderAdapter deliveryWithType:self.myType orderGoodsId:self.orderGoodsId complete:^(BOOL isSuccess) {
            if (isSuccess) {
                [FeimaManager sharedFeimaManager].distributionListReload = YES;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf.view makeToast:weakSelf.orderAdapter.errorString duration:1.5 position:CSToastPositionCenter];
            }
        }];
    }
}

#pragma mark 同意拒绝操作
- (void)handleAction:(UIButton *)sender {
    kSelfWeak;
    if (sender.tag == 100) { // 拒绝
        [self.orderAdapter refuseOrderApplyWithType:self.myType orderGoodsId:self.orderGoodsId complete:^(BOOL isSuccess) {
            if (isSuccess) {
                [FeimaManager sharedFeimaManager].distributionListReload = YES;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf.view makeToast:weakSelf.orderAdapter.errorString duration:1.5 position:CSToastPositionCenter];
            }
        }];
    } else { //同意
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSInteger count = [self.orderAdapter numberOfOrderGoodsList];
        for (NSInteger i=0; i<count; i++) {
            FMOrderDetaiModel  *model = [self.orderAdapter getOrderGoodsModelWithIndex:i];
            NSString *idKey = [NSString stringWithFormat:@"%ld",model.goods.goodsId];
            dict[idKey] = @(model.orderGoodsDetail.applyNum);
        }
        NSString *goodsInfo = [[FeimaManager sharedFeimaManager] objectToJSONString:dict];
        [self.orderAdapter agreeOrderApplyWithType:self.myType orderGoodsId:self.orderGoodsId orderGoodsDetailInfo:goodsInfo complete:^(BOOL isSuccess) {
            if (isSuccess) {
                [FeimaManager sharedFeimaManager].distributionListReload = YES;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf.view makeToast:weakSelf.orderAdapter.errorString duration:1.5 position:CSToastPositionCenter];
            }
        }];
    }
}

#pragma mark -- Private methods
#pragma mark 查询配货详情
- (void)loadDistributionDetailsData {
    [self.orderAdapter loadOrderDetailListWithOrderGoodsId:self.orderGoodsId complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [self.myTableView reloadData];
        }
    }];
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
    
    NSInteger postId = [FeimaManager sharedFeimaManager].userBean.users.postId;
    if (postId == 5) { //业务员
        // 业务员
        //1.配货 已发货：确认收货
        //2.退换货 同意退货：发货
        if ((self.type == 0 && self.status == 4) || (self.type == 1 && self.status == 22)) { //发货 同意退货
            [self.myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kScreen_Height-kNavBar_Height-46-(kTabBar_Height-30));
            }];
            
            [self.view addSubview:self.shipBtn];
            [self.shipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.myTableView.mas_bottom).offset(10);
                make.left.mas_equalTo(18);
                make.right.mas_equalTo(-18);
                make.height.mas_equalTo(46);
            }];
        }
    } else if (postId == 2 || postId == 6) {
        //经销商 或 仓库管理员
        //1.配货 申请配货：同意配货 拒绝配货
        //2.退换货 申请退换货：同意退换货 拒绝退换货
        if ((self.type == 0 &&  self.status == 1) || (self.type == 1 && self.status == 21)) { //申请配货 或申请退货
            [self.myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kScreen_Height-kNavBar_Height-46-(kTabBar_Height-30));
            }];
            
            [self.view addSubview:self.refuseBtn];
            [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.myTableView.mas_bottom).offset(10);
                make.left.mas_equalTo(18);
                make.size.mas_equalTo(CGSizeMake(kScreen_Width/2.0-26, 46));
            }];
            
            [self.view addSubview:self.agreeBtn];
            [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.myTableView.mas_bottom).offset(10);
                make.left.mas_equalTo(self.refuseBtn.mas_right).offset(16);
                make.size.mas_equalTo(CGSizeMake(kScreen_Width/2.0-26, 46));
            }];
        } else if ((self.type == 0 && self.status == 2) || (self.type == 1 && self.status == 24)) { // 配货同意
            //配货 配货同意：发货
            //退换货 退换货已发货：确认收货
            [self.myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kScreen_Height-kNavBar_Height-46-(kTabBar_Height-30));
            }];
            
            [self.view addSubview:self.shipBtn];
            [self.shipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.myTableView.mas_bottom).offset(10);
                make.left.mas_equalTo(18);
                make.right.mas_equalTo(-18);
                make.height.mas_equalTo(46);
            }];
        }
    }
}

#pragma mark -- Getters
#pragma mark 商品列表
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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

#pragma mark 发货
- (UIButton *)shipBtn {
    if (!_shipBtn) {
        _shipBtn = [UIButton submitButtonWithFrame:CGRectZero title:(self.status == 4 || self.status == 24) ? @"确认收货" : @"发货" target:self selector:@selector(shipAction:)];
    }
    return _shipBtn;
}

#pragma mark 退货
- (UIButton *)refuseBtn {
    if (!_refuseBtn) {
        _refuseBtn = [[UIButton alloc] init];
        NSString *titleStr = nil;
        if ([self.orderType isEqualToString:@"DISTRITUTION"]) {
            titleStr = @"拒绝配货";
        } else if ([self.orderType isEqualToString:@"RETURN"]) {
            titleStr = @"拒绝退货";
        } else {
            titleStr = @"拒绝换货";
        }
        [_refuseBtn setTitle:titleStr forState:UIControlStateNormal];
        [_refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _refuseBtn.backgroundColor = [UIColor colorWithHexString:@"#FB767F"];
        _refuseBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        _refuseBtn.layer.cornerRadius = 5;
        _refuseBtn.layer.maskedCorners = YES;
        _refuseBtn.tag = 100;
        [_refuseBtn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refuseBtn;
}

#pragma mark 换货
- (UIButton *)agreeBtn {
    if (!_agreeBtn) {
        _agreeBtn = [[UIButton alloc] init];
        NSString *titleStr = nil;
        if ([self.orderType isEqualToString:@"DISTRITUTION"]) {
            titleStr = @"同意配货";
        } else if ([self.orderType isEqualToString:@"RETURN"]) {
            titleStr = @"同意退货";
        } else {
            titleStr = @"同意换货";
        }
        [_agreeBtn setTitle:titleStr forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _agreeBtn.backgroundColor = [UIColor colorWithHexString:@"#7AC1AA"];
        _agreeBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        _agreeBtn.layer.cornerRadius = 5;
        _agreeBtn.layer.maskedCorners = YES;
        _agreeBtn.tag = 101;
        [_agreeBtn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}

- (FMOrderViewModel *)orderAdapter {
    if (!_orderAdapter) {
        _orderAdapter = [[FMOrderViewModel alloc] init];
    }
    return _orderAdapter;
}

@end
