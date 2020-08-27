//
//  FMInvoicingTableView.m
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInvoicingTableView.h"
#import "FMInvoicingTableViewCell.h"
#import "FMOrderViewModel.h"

@interface FMInvoicingTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger          type;
@property (nonatomic, strong) FMOrderViewModel   *adapter;


@end

@implementation FMInvoicingTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style type:(NSInteger)type {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self registerClass:[FMInvoicingTableViewCell class] forCellReuseIdentifier:[FMInvoicingTableViewCell identifier]];
        
        self.type = type;
        [self loadInvoicingData];
    }
    return self;
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfOrderList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMInvoicingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMInvoicingTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMOrderModel *model = [self.adapter getOrderModelWithIndex:indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMOrderModel *model = [self.adapter getOrderModelWithIndex:indexPath.row];
    if ([self.viewDelegate respondsToSelector:@selector(invoicingTableView:didSelectedRowWithModel:)]) {
        [self.viewDelegate invoicingTableView:self didSelectedRowWithModel:model];
    }
    
}

#pragma mark -- Private emthods
#pragma mark load data
- (void)loadInvoicingData {
    NSString *typeStr = self.type == 0 ? @"DISTRITUTION" : @"RETURN,EXCHANGE";
    [self.adapter loadOrderListWithOrderTypes:typeStr name:nil complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [self reloadData];
        }
    }];
}

- (FMOrderViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMOrderViewModel alloc] init];
    }
    return _adapter;
}

@end
