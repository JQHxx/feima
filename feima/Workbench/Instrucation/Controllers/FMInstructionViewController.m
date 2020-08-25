//
//  FMInstructionViewController.m
//  feima
//
//  Created by fei on 2020/8/4.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMInstructionViewController.h"
#import "FMAddInstucationViewController.h"
#import "FMReceiveInfoViewController.h"
#import "FMSendInfoViewController.h"
#import "FMInstrucationTableView.h"

@interface FMInstructionViewController ()<FMInstrucationTableViewDelegate>

@property (nonatomic, strong) UISegmentedControl   *segmentedControl;
@property (nonatomic, strong) UIScrollView         *rootScrollView;
@property (nonatomic, strong) FMInstrucationTableView *receiveTableView;
@property (nonatomic, strong) FMInstrucationTableView *sendTableView;
@property (nonatomic, strong) UIButton       *addBtn;

@end

@implementation FMInstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

#pragma mark -- Delegate
#pragma mark FMInstrucationTableViewDelegate
- (void)instrucationTableView:(FMInstrucationTableView *)tableView didSelectedRowWithModel:(FMInstrucationModel *)model {
    if (tableView == self.receiveTableView) {
        FMReceiveInfoViewController *receiveVC = [[FMReceiveInfoViewController alloc] init];
        receiveVC.instrucation = model;
        [self.navigationController pushViewController:receiveVC animated:YES];
    } else {
        FMSendInfoViewController *sendVC = [[FMSendInfoViewController alloc] init];
        sendVC.instrucation = model;
        [self.navigationController pushViewController:sendVC animated:YES];
    }
}

#pragma mark -- Event response
#pragma mark 选择菜单
- (void)selectedMenuAction:(UISegmentedControl *)sender {
    [self.rootScrollView setContentOffset:CGPointMake(kScreen_Width*sender.selectedSegmentIndex, 0)];
    self.addBtn.hidden = sender.selectedSegmentIndex == 0;
}

#pragma mark 添加指令
- (void)addInstrucationAction:(UIButton *)sender {
    FMAddInstucationViewController *addVC = [[FMAddInstucationViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
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
    
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
    
    [self.rootScrollView addSubview:self.receiveTableView];
    [self.receiveTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, kScreen_Height-kNavBar_Height));
    }];
    
    [self.rootScrollView addSubview:self.sendTableView];
    [self.sendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receiveTableView.mas_right);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, kScreen_Height-kNavBar_Height));
    }];
    
    [self.view addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-(kTabBar_Height-30));
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    self.addBtn.hidden = YES;
}

#pragma mark -- Getters
#pragma mark 菜单
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"接收",@"发送"]];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor systemColor]} forState:UIControlStateSelected];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(selectedMenuAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

#pragma mark
- (UIScrollView *)rootScrollView {
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] init];
        _rootScrollView.showsHorizontalScrollIndicator = NO;
        _rootScrollView.scrollEnabled = NO;
        [_rootScrollView setContentSize:CGSizeMake(kScreen_Width*2, kScreen_Height-kNavBar_Height)];
    }
    return _rootScrollView;
}

#pragma mark
- (FMInstrucationTableView *)receiveTableView {
    if (!_receiveTableView) {
        _receiveTableView = [[FMInstrucationTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain type:0];
        _receiveTableView.viewDelegate = self;
    }
    return _receiveTableView;
}

#pragma mark
- (FMInstrucationTableView *)sendTableView {
    if (!_sendTableView) {
        _sendTableView = [[FMInstrucationTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain type:1];
        _sendTableView.viewDelegate = self;
    }
    return _sendTableView;
}


#pragma mark 添加指令
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton addButtonWithTarget:self selector:@selector(addInstrucationAction:)];
    }
    return _addBtn;
}

@end
