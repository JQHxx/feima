//
//  FMAddCompanyViewController.m
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAddCompanyViewController.h"

@interface FMAddCompanyViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray  *titlesArr;
}

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) UIButton       *submitBtn;

@end

@implementation FMAddCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = self.company ? @"修改公司":@"添加公司";
    
    titlesArr = @[@"公司名称",@"公司电话",@"公司地址"];
    [self setupUI];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 30)];
    lab.text = titlesArr[indexPath.row];
    lab.font = [UIFont mediumFontWithSize:16];
    [cell.contentView addSubview:lab];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 15, kScreen_Width-120, 30)];
    textField.font = [UIFont regularFontWithSize:16];
    textField.placeholder = [NSString stringWithFormat:@"请输入%@",titlesArr[indexPath.row]];
    [cell.contentView addSubview:textField];
    
    if (self.company) {
        if (indexPath.row == 0) {
            textField.text = kIsEmptyString(self.company.name) ? @"" : self.company.name;
        } else if (indexPath.row == 1) {
            textField.text = self.company.phone>0 ? [NSString stringWithFormat:@"%ld",self.company.phone] : @"";
        } else {
            textField.text = kIsEmptyString(self.company.address) ? @"" : self.company.address;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark -- Events
#pragma mark 提交
- (void)submitCompanyAction:(UIButton *)sender {
    MyLog(@"submitCompanyAction");
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height+15);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(180);
    }];
    
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myTableView.mas_bottom).offset(30);
        make.left.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-36, 46));
    }];
}

#pragma mark -- Getters
#pragma mark tableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.scrollEnabled = NO;
    }
    return _myTableView;
}

#pragma mark 提交
- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton submitButtonWithFrame:CGRectZero title:@"提交" target:self selector:@selector(submitCompanyAction:)];
    }
    return _submitBtn;
}

@end
