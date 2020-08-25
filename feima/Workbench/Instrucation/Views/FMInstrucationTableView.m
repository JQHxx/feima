//
//  FMInstrucationTableView.m
//  feima
//
//  Created by fei on 2020/8/22.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInstrucationTableView.h"
#import "FMInstrucationTableViewCell.h"
#import "FMInstrucationViewModel.h"

@interface FMInstrucationTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FMPageModel       *pageModel;
@property (nonatomic, strong) FMInstrucationViewModel *adapter;

@property (nonatomic, assign) NSInteger type;

@end

@implementation FMInstrucationTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style type:(NSInteger)type{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        self.estimatedRowHeight = 100;
        self.rowHeight = UITableViewAutomaticDimension;
        self.tableFooterView = [[UIView alloc] init];
        [self registerClass:[FMInstrucationTableViewCell class] forCellReuseIdentifier:[FMInstrucationTableViewCell identifier]];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.type = type;
        
        [self loadInstrucationsData];
    }
    return self;
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.adapter numberOfInstrucationList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMInstrucationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMInstrucationTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMInstrucationModel *model = [self.adapter getInstrucationModelWithIndex:indexPath.row];
    [cell fillContentWithData:model type:self.type];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMInstrucationModel *model = [self.adapter getInstrucationModelWithIndex:indexPath.row];
    if ([self.viewDelegate respondsToSelector:@selector(instrucationTableView:didSelectedRowWithModel:)]) {
        [self.viewDelegate instrucationTableView:self didSelectedRowWithModel:model];
    }
}

#pragma mark load data
- (void)loadInstrucationsData {
    kSelfWeak;
    [self.adapter loadInstrucationListWithPage:self.pageModel type:self.type complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.mj_footer endRefreshing];
            [weakSelf reloadData];
            [weakSelf createLoadMoreView];
        }
    }];
}

#pragma mark 加载更多
- (void)loadMoreInstrucationsData {
    self.pageModel.pageNum ++ ;
    [self loadInstrucationsData];
}

#pragma mark 更多底部视图
- (void)createLoadMoreView {
    if ([self.adapter hasMoreData]) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreInstrucationsData)];
        footer.automaticallyRefresh = NO;
        self.mj_footer = footer;
    } else {
        self.mj_footer = nil;
    }
}

#pragma mark -- Getters
- (FMInstrucationViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMInstrucationViewModel alloc] init];
    }
    return _adapter;
}

- (FMPageModel *)pageModel {
    if (!_pageModel) {
        _pageModel = [[FMPageModel alloc] init];
        _pageModel.pageNum = 1;
        _pageModel.pageSize = 15;
    }
    return _pageModel;
}

@end
