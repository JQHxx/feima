//
//  FMRouteRecordsViewController.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMRouteRecordsViewController.h"

@interface FMRouteRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView   *recordTableView;

@property (nonatomic,strong) NSMutableArray *recordsArray;

@end

@implementation FMRouteRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"历史记录";
    
    [self.view addSubview:self.recordTableView];
    [self loadRecordsData];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FMRecordTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = ImageNamed(@"address_theme");
    cell.textLabel.text = self.recordsArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark -- Private methods
#pragma mark load data
- (void)loadRecordsData {
    NSArray *arr = @[@"08-11",@"08-04",@"07-20",@"07-15",@"07-13",@"06-17",@"06-16",@"06-15"];
    [self.recordsArray addObjectsFromArray:arr];
    [self.recordTableView reloadData];
}

#pragma mark -- Getters
#pragma mark 历史记录
- (UITableView *)recordTableView {
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBar_Height, kScreen_Width, kScreen_Height-kNavBar_Height) style:UITableViewStylePlain];
        _recordTableView.delegate = self;
        _recordTableView.dataSource = self;
        _recordTableView.showsVerticalScrollIndicator = NO;
        _recordTableView.tableFooterView = [[UIView alloc] init];
        [_recordTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FMRecordTableViewCell"];
    }
    return _recordTableView;
}

- (NSMutableArray *)recordsArray {
    if (!_recordsArray) {
        _recordsArray = [[NSMutableArray alloc] init];
    }
    return _recordsArray;
}

@end
