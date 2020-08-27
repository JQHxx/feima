//
//  FMConfirmViewController.m
//  feima
//
//  Created by fei on 2020/8/25.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMConfirmViewController.h"
#import "FMInvoicingViewController.h"
#import "FMDistributionTableViewCell.h"
#import "FMOrderViewModel.h"

@interface FMConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView      *myTableView;
@property (nonatomic, strong) UIButton         *applyBtn; //申请配货
@property (nonatomic, strong) UIButton         *returnBtn; //退货
@property (nonatomic, strong) UIButton         *exchangeBtn; //换货

@property (nonatomic, strong) FMOrderViewModel *adapter;

@end

@implementation FMConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = self.type == 0 ? @"确认配货信息" : @"确认退换货信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    
    [self setupUI];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selGoodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMDistributionTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMGoodsModel  *model = self.selGoodsArr[indexPath.row];
    [cell fillContentWithData:model type:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

#pragma mark -- Event response
#pragma mark 申请配货
- (void)applyDistributionAction:(UIButton *)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (FMGoodsModel *model in self.selGoodsArr) {
        NSString *idKey = [NSString stringWithFormat:@"%ld",model.goodsId];
        dict[idKey] = @(model.quantity);
    }
    NSString *goodsInfo = [[FeimaManager sharedFeimaManager] objectToJSONString:dict];
    kSelfWeak;
    [self.adapter applyDistributionWithGoodsInfo:goodsInfo complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [FeimaManager sharedFeimaManager].distributionListReload = YES;
            [weakSelf.view makeToast:@"申请配货成功" duration:1.0 position:CSToastPositionCenter];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (BaseViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[FMInvoicingViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                        break;
                    }
                }
            });
        }
    }];
}

#pragma mark 退换货
- (void)returnAction:(UIButton *)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (FMGoodsModel *model in self.selGoodsArr) {
        NSString *idKey = [NSString stringWithFormat:@"%ld",model.goodsId];
        dict[idKey] = @(model.quantity);
    }
    NSString *goodsInfo = [[FeimaManager sharedFeimaManager] objectToJSONString:dict];
    NSString *orderType = sender.tag == 100 ? @"RETURN" : @"EXCHANGE";
    kSelfWeak;
    [self.adapter applyReturnWithGoodsInfo:goodsInfo orderTypes:orderType complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [FeimaManager sharedFeimaManager].distributionListReload = YES;
            [weakSelf.view makeToast:sender.tag == 100 ? @"申请退货成功" : @"申请换货成功" duration:1.0 position:CSToastPositionCenter];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (BaseViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[FMInvoicingViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                        break;
                    }
                }
            });
        } else {
            [weakSelf.view makeToast:weakSelf.adapter.errorString duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height-46-(kTabBar_Height-30));
    }];
    
    if (self.type == 0) {
        [self.view addSubview:self.applyBtn];
        [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.myTableView.mas_bottom).offset(10);
            make.left.mas_equalTo(18);
            make.right.mas_equalTo(-18);
            make.height.mas_equalTo(46);
        }];
    } else {
        [self.view addSubview:self.returnBtn];
        [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.myTableView.mas_bottom).offset(10);
            make.left.mas_equalTo(18);
            make.size.mas_equalTo(CGSizeMake(kScreen_Width/2.0-26, 46));
        }];
        
        [self.view addSubview:self.exchangeBtn];
        [self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.myTableView.mas_bottom).offset(10);
            make.left.mas_equalTo(self.returnBtn.mas_right).offset(16);
            make.size.mas_equalTo(CGSizeMake(kScreen_Width/2.0-26, 46));
        }];
    }
}

#pragma mark -- Gettets
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

#pragma mark 申请配货
- (UIButton *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [UIButton submitButtonWithFrame:CGRectZero title:@"申请配货" target:self selector:@selector(applyDistributionAction:)];
    }
    return _applyBtn;
}

#pragma mark 退货
- (UIButton *)returnBtn {
    if (!_returnBtn) {
        _returnBtn = [[UIButton alloc] init];
        [_returnBtn setTitle:@"退货" forState:UIControlStateNormal];
        [_returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _returnBtn.backgroundColor = [UIColor colorWithHexString:@"#FB767F"];
        _returnBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        _returnBtn.layer.cornerRadius = 5;
        _returnBtn.layer.maskedCorners = YES;
        _returnBtn.tag = 100;
        [_returnBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}

#pragma mark 换货
- (UIButton *)exchangeBtn {
    if (!_exchangeBtn) {
        _exchangeBtn = [[UIButton alloc] init];
        [_exchangeBtn setTitle:@"换货" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _exchangeBtn.backgroundColor = [UIColor colorWithHexString:@"#7AC1AA"];
        _exchangeBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        _exchangeBtn.layer.cornerRadius = 5;
        _exchangeBtn.layer.maskedCorners = YES;
        _exchangeBtn.tag = 101;
        [_exchangeBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeBtn;
}

- (FMOrderViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMOrderViewModel alloc] init];
    }
    return _adapter;
}

@end
