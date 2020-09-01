//
//  FMMessageViewController.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMessageViewController.h"
#import "FMMessageTableViewCell.h"
#import "FMMessageViewModel.h"
#import "FMMessageModel.h"

@interface FMMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView        *messageTableView;
@property (nonatomic,strong) FMMessageViewModel *adapter;
@property (nonatomic,strong) FMPageModel        *pageModel;

@end

@implementation FMMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"消息列表";
    
    [self.view addSubview:self.messageTableView];
    [self loadMessagesData];
    
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.adapter numberOfMessagesList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMMessageTableViewCell identifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMMessageModel *model = [self.adapter getMessageModelWithIndex:indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadMessagesData {
    kSelfWeak;
    [self.adapter loadMessagesListDataWithPage:self.pageModel complete:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.messageTableView.mj_footer endRefreshing];
            [weakSelf.messageTableView reloadData];
            [weakSelf createLoadMoreView];
            //标为已读
            [weakSelf.adapter setMessagesReadedComplete:^(BOOL isSuccess) {
                
            }];
        } else {
            [weakSelf.view makeToast:weakSelf.adapter.errorString duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark 加载更多
- (void)loadMoreMessagesData {
    self.pageModel.pageNum ++ ;
    [self loadMessagesData];
}

#pragma mark 更多底部视图
- (void)createLoadMoreView {
    if ([self.adapter hasMoreData]) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessagesData)];
        footer.automaticallyRefresh = NO;
        self.messageTableView.mj_footer = footer;
    } else {
        self.messageTableView.mj_footer = nil;
    }
}

#pragma mark -- Getters
#pragma mark 消息列表
- (UITableView *)messageTableView {
    if (!_messageTableView) {
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBar_Height, kScreen_Width, kScreen_Height-kNavBar_Height) style:UITableViewStylePlain];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.showsVerticalScrollIndicator = NO;
        _messageTableView.tableFooterView = [[UIView alloc] init];
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_messageTableView registerClass:[FMMessageTableViewCell class] forCellReuseIdentifier:[FMMessageTableViewCell identifier]];
    }
    return _messageTableView;
}

- (FMMessageViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMMessageViewModel alloc] init];
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
