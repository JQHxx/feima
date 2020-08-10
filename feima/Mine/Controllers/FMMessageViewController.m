//
//  FMMessageViewController.m
//  feima
//
//  Created by fei on 2020/8/5.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMMessageViewController.h"
#import "FMMessageTableViewCell.h"
#import "FMMessageModel.h"

@interface FMMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    *messageTableView;
@property (nonatomic,strong) NSMutableArray *messageArray;

@end

@implementation FMMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"消息列表";
    
    [self.view addSubview:self.messageTableView];
    [self loadData];
    
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMMessageTableViewCell identifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMMessageModel *model = self.messageArray[indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadData {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<10; i++) {
        FMMessageModel *model = [[FMMessageModel alloc] init];
        model.message = @"下班打开";
        model.updateTime = 1595468583;
        model.organizationName = @"财务部";
        FMEmployeeModel *eModel = [[FMEmployeeModel alloc] init];
        eModel.name = @"以于涛";
        model.employee = eModel;
        [tempArr addObject:model];
    }
    self.messageArray = tempArr;
    [self.messageTableView reloadData];
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

- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        _messageArray = [[NSMutableArray alloc] init];
    }
    return _messageArray;
}

@end
