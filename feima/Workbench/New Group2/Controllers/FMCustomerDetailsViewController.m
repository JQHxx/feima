//
//  FMCustomerDetailsViewController.m
//  feima
//
//  Created by fei on 2020/8/12.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMCustomerDetailsViewController.h"
#import "FMAddCustomerViewController.h"
#import "FMCustomerHeadView.h"

@interface FMCustomerDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titlesArr;
}

@property (nonatomic, strong) UIButton           *rightBtn;
@property (nonatomic, strong) FMCustomerHeadView *headView;
@property (nonatomic, strong) UITableView        *myTableView;

@end

@implementation FMCustomerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"客户主页";
    
    titlesArr = @[@{@"title":@"基本信息",@"subtitles":@[@"名称",@"简称",@"联系人",@"手机号",@"位置",@"门头照"]},@{@"title":@"详细信息",@"subtitles":@[@"行业类型",@"客户等级",@"陈列面积",@"跟进进度",@"跟进人"]}];
    
    [self setupUI];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titlesArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = titlesArr[section];
    NSArray *titles = dict[@"subtitles"];
    return titles.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
    aView.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dict = titlesArr[section];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 120, 30)];
    lab.text = dict[@"title"];
    lab.font = [UIFont mediumFontWithSize:18];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    [aView addSubview:lab];
    
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } else {
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //标题
    NSDictionary *dict = titlesArr[indexPath.section];
    NSArray *titles = dict[@"subtitles"];
    NSString *titleStr = titles[indexPath.row];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 30)];
    lab.font = [UIFont mediumFontWithSize:14];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    lab.text = titleStr;
    [cell.contentView addSubview:lab];
    
    if (indexPath.section==0&&indexPath.row==5) { //门头照
        
    } else {
        UILabel *valueLab = [self fillDataForSection:indexPath.section row:indexPath.row];
        [cell.contentView addSubview:valueLab];
    }
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
        aView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
        return aView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 5) {
        return 120;
    } else {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else {
        return 0.01;
    }
}

#pragma mark -- event response
#pragma mark 编辑
- (void)editCostomerAction:(UIButton *)sender {
    FMAddCustomerViewController *addCustomerVC = [[FMAddCustomerViewController alloc] init];
    addCustomerVC.customerModel = self.customer;
    [self.navigationController pushViewController:addCustomerVC animated:YES];
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(kStatusBar_Height+6);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
    
    [self.headView displayViewWithData:self.customer];
}

#pragma mark 填充数据
- (UILabel *)fillDataForSection:(NSInteger)section row:(NSInteger)row {
    UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 10,kScreen_Width-115, 40)];
    valueLab.font = [UIFont regularFontWithSize:14];
    valueLab.textColor = [UIColor colorWithHexString:@"#666666"];
    valueLab.numberOfLines = 0;
    if (section == 0) {
        switch (row) {
            case 0:
                valueLab.text = self.customer.businessName;
                break;
            case 1:
                valueLab.text = self.customer.nickName;
                break;
            case 2:
                valueLab.text = self.customer.contactName;
                break;
            case 3:
                valueLab.text = [NSString stringWithFormat:@"%ld", self.customer.telephone];
                break;
            case 4:
                valueLab.text = self.customer.address;
                break;
            default:
                break;
        }
    } else {
        switch (row) {
            case 0:
                valueLab.text = self.customer.industryName;
                break;
            case 1:
                valueLab.text = self.customer.gradeName;
                break;
            case 2:
                valueLab.text =  [NSString stringWithFormat:@"%ld", self.customer.displayArea];
                break;
            case 3:
                valueLab.text = self.customer.progressName;;
                break;
            case 4:
                valueLab.text = self.customer.employeeName;
                break;
            default:
                break;
        }
    }
    return valueLab;
}

#pragma mark -- Getters
#pragma mark 编辑
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setImage:ImageNamed(@"edit") forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(editCostomerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;;
}

#pragma mark 头部视图
- (FMCustomerHeadView *)headView {
    if (!_headView) {
        _headView = [[FMCustomerHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 140)];
    }
    return _headView;
}

#pragma mark tableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.tableHeaderView = self.headView;
    }
    return _myTableView;
}


@end
