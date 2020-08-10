//
//  FMInstructionViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInstructionViewController.h"
#import "FMInstrucationTableViewCell.h"
#import "FMInstrucationModel.h"

@interface FMInstructionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView        *myTableView;
@property (nonatomic, strong) NSMutableArray     *instrucationArray;

@end

@implementation FMInstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadData];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.instrucationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMInstrucationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FMInstrucationTableViewCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FMInstrucationModel *model = self.instrucationArray[indexPath.row];
    [cell fillContentWithData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}

#pragma mark -- Private methods
#pragma mark 加载数据
- (void)loadData {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<10; i++) {
        FMInstrucationModel *model = [[FMInstrucationModel alloc] init];
        model.employeeName = @"王经理";
        model.createTime = 1595924288;
        model.content = @"14:00机场接何总";
        model.endTime = 1595924486;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        FMEmployeeModel *eModel = [[FMEmployeeModel alloc] init];
        eModel.name = @"王口味";
        [arr addObject:eModel];
        model.employees = arr;
        [tempArr addObject:model];
    }
    self.instrucationArray = tempArr;
    [self.myTableView reloadData];
}


#pragma mark -- Private methods
#pragma mark 界面
- (void)setupUI {
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBar_Height+2);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
}

#pragma mark -- Getters
#pragma mark 菜单
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"正常",@"禁用"]];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor systemColor]} forState:UIControlStateSelected];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

#pragma mark 客户列表
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView = [[UIView alloc] init];
        [_myTableView registerClass:[FMInstrucationTableViewCell class] forCellReuseIdentifier:[FMInstrucationTableViewCell identifier]];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _myTableView;
}

- (NSMutableArray *)instrucationArray {
    if (!_instrucationArray) {
        _instrucationArray = [[NSMutableArray alloc] init];
    }
    return _instrucationArray;
}


@end
