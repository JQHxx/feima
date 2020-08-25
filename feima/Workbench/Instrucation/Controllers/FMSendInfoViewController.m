//
//  FMSendInfoViewController.m
//  feima
//
//  Created by fei on 2020/8/22.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMSendInfoViewController.h"
#import "BRDatePickerView.h"

@interface FMSendInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titles;
}

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic, copy ) NSString    *selDate;


@end

@implementation FMSendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"指令详情";
    
    titles = @[@"指令内容",@"截止时间",@"执行人"];
    self.selDate = [[FeimaManager sharedFeimaManager] timeWithTimeInterval:self.instrucation.endTime format:@"yyyy.MM.dd"];
    
    [self.view addSubview:self.myTableView];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    UILabel *lab = [self setupLabelWithFrame:CGRectMake(15, 20, 80, 28) title:titles[indexPath.row]];
    [cell.contentView addSubview:lab];
    
    if (indexPath.row == 0) {
        UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 20, kScreen_Width-115, 28)];
        valueLab.font = [UIFont regularFontWithSize:16];
        valueLab.textColor = [UIColor colorWithHexString:@"#666666"];
        valueLab.text = self.instrucation.content;
        [cell.contentView addSubview:valueLab];
    } else if (indexPath.row == 1) {
        cell.detailTextLabel.text = self.selDate;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        for (NSInteger i=0; i<self.instrucation.employees.count; i++) {
            FMEmployeeModel * model = self.instrucation.employees[i];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(lab.right+10, 10+68*i, 48, 48)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage ctPlaceholderImage]];
            [cell.contentView addSubview:imgView];
                       
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10,imgView.top+10, 100, 28)];
            lab.textColor = [UIColor colorWithHexString:@"#666666"];
            lab.font = [UIFont regularFontWithSize:16];
            lab.text = model.name;
            [cell.contentView addSubview:lab];
            
            UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-85, imgView.top+10, 70, 28)];
            statusLab.textAlignment = NSTextAlignmentRight;
            statusLab.textColor = [UIColor systemColor];
            statusLab.font = [UIFont regularFontWithSize:16];
            if (model.status == 1) {
                statusLab.text = @"未接收";
            } else if (model.status == 2) {
                statusLab.text = @"已接收";
            } else {
                statusLab.text = @"已执行";
            }
            [cell.contentView addSubview:statusLab];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return self.instrucation.employees.count * 68;
    } else {
        return 68;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
       NSString *defaultValue =  [[FeimaManager sharedFeimaManager] timeWithTimeInterval:self.instrucation.endTime format:@"yyyy.MM.dd"];
        [BRDatePickerView showDatePickerWithTitle:@"截止期限" dateType:UIDatePickerModeDate defaultSelValue:defaultValue minDateStr:nil maxDateStr:nil isAutoSelect:NO resultBlock:^(NSString *selectValue) {
            MyLog(@"selectValue:%@",selectValue);
            self.selDate = selectValue;
            [self.myTableView reloadData];
        }];
    }
}

#pragma mark -- Private methods
#pragma mark setup label
- (UILabel *)setupLabelWithFrame:(CGRect)frame title:(NSString *)title {
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.font = [UIFont mediumFontWithSize:16];
    lab.text = title;
    lab.textColor = [UIColor textBlackColor];
    return lab;
}

#pragma mark tableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBar_Height, kScreen_Width, kScreen_Height-kNavBar_Height) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.tableFooterView = [[UIView alloc] init];
    }
    return _myTableView;
}

@end
