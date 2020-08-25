//
//  FMReceiveInfoViewController.m
//  feima
//
//  Created by fei on 2020/8/22.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMReceiveInfoViewController.h"
#import "FMSumUpViewController.h"
#import <YBImageBrowser/YBImageBrowser.h>

@interface FMReceiveInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titles;
}

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) UIView      *bottmView;

@end

@implementation FMReceiveInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"指令详情";
    
    titles = self.instrucation.status == 3 ? @[@"指令内容",@"截止时间",@"指派人",@"执行人",@"状态",@"完成时间",@"执行总结"] : @[@"指令内容",@"截止时间",@"指派人",@"执行人",@"状态",@"完成时间"];
    [self.view addSubview:self.myTableView];
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lab = [self setupLabelWithFrame:CGRectMake(15, 20, 80, 28) title:titles[indexPath.row]];
    [cell.contentView addSubview:lab];
    
    if (indexPath.row == 3) {
        FMEmployeeModel *selModel = nil;
        for (FMEmployeeModel *model in self.instrucation.employees) {
            if (model.employeeId == self.instrucation.toEmployeeId) {
                selModel = model;
                break;
            }
        }
        if (selModel) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(lab.right+10, 10, 48, 48)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:selModel.logo] placeholderImage:[UIImage ctPlaceholderImage]];
            [cell.contentView addSubview:imgView];
            
            UILabel *lab = [self setupValueLabelWithFrame:CGRectMake(imgView.right+10, 20, 100, 28)];
            lab.text = selModel.name;
            [cell.contentView addSubview:lab];
        }
    } else {
        UILabel *valueLab = [self setupValueLabelWithFrame:CGRectMake(105, 20, kScreen_Width-115, 28)];
        [cell.contentView addSubview:valueLab];
        if (indexPath.row == 0) {
            valueLab.text = self.instrucation.content;
        } else if (indexPath.row == 1) {
            valueLab.text = [[FeimaManager sharedFeimaManager] timeWithTimeInterval:self.instrucation.endTime format:@"yyyy.MM.dd HH:mm"];
        } else if (indexPath.row == 2) {
            valueLab.text = self.instrucation.fromEmployeeName;
        } else if (indexPath.row == 4) {
            valueLab.text = self.instrucation.statusName;
            valueLab.textColor = [UIColor systemColor];
        } else if (indexPath.row == 5) {
            valueLab.text = [[FeimaManager sharedFeimaManager] timeWithTimeInterval:self.instrucation.endTime format:@"yyyy.MM.dd HH:mm"];
        }
        if (self.instrucation.status == 3) {
            if (indexPath.row == 6) {
                valueLab.text = self.instrucation.summary;
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

#pragma mark -- Event response
#pragma mark 去总结
- (void)toSumUpAction:(UIButton *)sender {
    FMSumUpViewController *sumUpVC = [[FMSumUpViewController alloc] init];
    sumUpVC.instructionRecordId = self.instrucation.instructionRecordId;
    [self.navigationController pushViewController:sumUpVC animated:YES];
}

#pragma mark 显示大图
- (void)showLargePhotoAction {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
    YBIBImageData *data1 = [YBIBImageData new];
    data1.imageURL = [NSURL URLWithString:self.instrucation.images];
    [arr addObject:data1];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = arr;
    browser.currentPage = 0;
    [browser show];
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

#pragma mark setup label
- (UILabel *)setupValueLabelWithFrame:(CGRect)frame{
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.font = [UIFont regularFontWithSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#666666"];
    return lab;
}

#pragma mark -- Getters
- (UIView *)bottmView {
    if (!_bottmView) {
        _bottmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 120)];
        
        if (self.instrucation.status == 3 ) { //已执行
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width-15, 1)];
            line.backgroundColor = [UIColor lineColor];
            [_bottmView addSubview:line];
            
            UILabel *lab = [self setupLabelWithFrame:CGRectMake(15, 20, 100, 20) title:@"照片"];
            [_bottmView addSubview:lab];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, lab.bottom+15, 68, 68)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.instrucation.images] placeholderImage:[UIImage ctPlaceholderImage]];
            [imgView addTapPressed:@selector(showLargePhotoAction) target:self];
            [_bottmView addSubview:imgView];
        } else {
            UIButton *submitBtn = [UIButton submitButtonWithFrame:CGRectMake(18, 30, kScreen_Width-36, 46) title:@"去总结" target:self selector:@selector(toSumUpAction:)];
            [_bottmView addSubview:submitBtn];
        }
    }
    return _bottmView;
}

#pragma mark tableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBar_Height, kScreen_Width, kScreen_Height-kNavBar_Height) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.tableFooterView = self.bottmView;
    }
    return _myTableView;
}


@end
