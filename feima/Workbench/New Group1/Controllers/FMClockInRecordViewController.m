//
//  FMClockInRecordViewController.m
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMClockInRecordViewController.h"
#import "FMPunchRecordTableViewCell.h"

@interface FMClockInRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *recordsTableView;

@end

@implementation FMClockInRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMPunchRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMPunchRecordTableViewCell identifier] forIndexPath:indexPath];
    
    return cell;
}

#pragma mark -- Getters
#pragma mark 打卡记录
- (UITableView *)recordsTableView {
    if (!_recordsTableView) {
        _recordsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _recordsTableView.delegate = self;
        _recordsTableView.dataSource = self;
        _recordsTableView.showsVerticalScrollIndicator = NO;
        [_recordsTableView registerClass:[FMPunchRecordTableViewCell class] forCellReuseIdentifier:[FMPunchRecordTableViewCell identifier]];
    }
    return _recordsTableView;
}


@end
