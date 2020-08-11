//
//  FMDailyDetailsViewController.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDailyDetailsViewController.h"

@interface FMDailyDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView  *myTableView;

@end

@implementation FMDailyDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"打卡详情";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
    [self.view addSubview:self.myTableView];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-18, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    [aView setCircleCorner:UIRectCornerTopLeft|UIRectCornerTopRight radius:4.0];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 10, 120, 30)];
    nameLabel.text = self.reportModel.employeeName;
    nameLabel.font = [UIFont mediumFontWithSize:18];
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [aView addSubview:nameLabel];
    return aView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 4) {
        cell.textLabel.text = @"照片：";
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 15, 72, 84)];
        imgView.backgroundColor = [UIColor lineColor];
        [cell.contentView addSubview:imgView];
    } else {
        NSArray *texts = @[[NSString stringWithFormat:@"部门：%@",self.reportModel.organizationName],[NSString stringWithFormat:@"类型：%@",self.reportModel.punchTypeName],[NSString stringWithFormat:@"时间：%@",self.reportModel.punchSecondTimeStr],[NSString stringWithFormat:@"地点：%@",self.reportModel.address]];
        cell.textLabel.text = texts[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return 114;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark -- Getter
#pragma mark 打卡详情
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(8,kNavBar_Height+8, kScreen_Width-16, 364) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.layer.cornerRadius = 4;
        _myTableView.clipsToBounds = YES;
        _myTableView.separatorInset = UIEdgeInsetsZero;
        _myTableView.scrollEnabled = NO;
    }
    return _myTableView;
}




@end
