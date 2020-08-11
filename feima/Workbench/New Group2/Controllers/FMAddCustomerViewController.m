//
//  FMAddCustomerViewController.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAddCustomerViewController.h"

@interface FMAddCustomerViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titlesArr;
}

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) UITextField    *nameTextField;   //名称
@property (nonatomic, strong) UITextField    *shortNameTextField; //简称
@property (nonatomic, strong) UITextField    *contactTextField; //联系人
@property (nonatomic, strong) UITextField    *phoneTextField;  //手机号
@property (nonatomic, strong) UILabel        *addressLabel;   //位置
@property (nonatomic, strong) UILabel        *photoTitleLab;  //
@property (nonatomic, strong) UILabel        *industryLab;   //行业类型
@property (nonatomic, strong) UILabel        *levelLab;      //客户等级
@property (nonatomic, strong) UITextField    *areaTextField; //陈列面积
@property (nonatomic, strong) UILabel        *followPressLab; //跟进进度
@property (nonatomic, strong) UILabel        *followLab;    //跟进人
@property (nonatomic, strong) UIButton       *submitBtn; //保存

@end

@implementation FMAddCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"新增客户";
    
    titlesArr = @[@{@"title":@"基本信息",@"subtitles":@[@"名称*",@"简称",@"联系人*",@"手机号*",@"位置*",@"门头照(0/5)"]},@{@"title":@"详细信息",@"subtitles":@[@"行业类型*",@"客户等级*",@"陈列面积*",@"跟进进度*",@"跟进人"]}];
    
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
    UILabel *lab = [self setupTitlelabelWithTitleStr:titleStr];
    [cell.contentView addSubview:lab];
    
    if (indexPath.section == 0 ) {
        if (indexPath.row < 4) {
            UITextField *textField = [self setupTextFieldWithPlaceholder:titleStr];
            [cell.contentView addSubview:textField];
            if (indexPath.row==0) { //名称
                self.nameTextField = textField;
            } else if (indexPath.row == 1) { //简称
                self.shortNameTextField = textField;
            } else if (indexPath.row == 2) { //联系人
                self.contactTextField = textField;
            } else { //手机号
                self.phoneTextField = textField;
            }
        } else if (indexPath.row == 4) { //位置
            [cell.contentView addSubview:self.addressLabel];
        } else if (indexPath.row == 5) { //门头照
            self.photoTitleLab = lab;
            //门头照描述
            UILabel *descLab = [[UILabel alloc] initWithFrame:CGRectMake(lab.right, 15, 180, 30)];
            descLab.font = [UIFont regularFontWithSize:12];
            descLab.textColor = [UIColor colorWithHexString:@"#F34F1F"];
            descLab.text = @"*必须为现场拍照";
            [cell.contentView addSubview:descLab];
        }
    } else {
        if (indexPath.row == 2) { //陈列面积
            [cell.contentView addSubview:self.areaTextField];
        } else {
            UILabel *valueLab = [self setupLabelWithTitleStr:titleStr];
            [cell.contentView addSubview:valueLab];
            if (indexPath.row == 0) { //行业类型
                self.industryLab = valueLab;
            } else if (indexPath.row == 1) { //客户等级
                self.levelLab = valueLab;
            } else if (indexPath.row == 3) { //跟进进度
                self.followPressLab = valueLab;
            } else { //跟进人
                self.followLab = valueLab;
            }
        }
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
    if (indexPath.section == 0 && indexPath.row == 4) {
        return 80;
    } else if (indexPath.section == 0 && indexPath.row == 5) {
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

#pragma mark -- Event response
#pragma mark 保存
- (void)submitCustomerAction:(UIButton *)sender {
    
}

#pragma mark
- (void)selectedInfoAction:(UITapGestureRecognizer *)gesture {
    
}

#pragma mark -- Private methods
#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
    
    /*
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myTableView.mas_bottom).offset(30);
        make.left.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-36, 46));
    }];
     */
}

#pragma mark setup title label
- (UILabel *)setupTitlelabelWithTitleStr:(NSString *)titleStr {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 30)];
    lab.font = [UIFont mediumFontWithSize:14];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    //必填*处理
    if ([titleStr containsString:@"*"]) {
        NSRange aRange = [titleStr rangeOfString:@"*"];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F34F1F"] range:aRange];
        lab.attributedText = attributedStr;
    } else {
        lab.text = titleStr;
    }
    return lab;
}

#pragma mark setup Label
- (UILabel *)setupLabelWithTitleStr:(NSString *)titleStr {
    UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 15,kScreen_Width-115, 30)];
    valueLab.font = [UIFont regularFontWithSize:14];
    valueLab.textColor = [UIColor colorWithHexString:@"#999999"];
    NSString *placeholder = titleStr;
    if ([titleStr containsString:@"*"]) {
        placeholder = [titleStr substringToIndex:titleStr.length-1];
    }
    valueLab.text = [NSString stringWithFormat:@"请填写%@",placeholder];
    return valueLab;
}

#pragma mark setup textfield
- (UITextField *)setupTextFieldWithPlaceholder:(NSString *)titleStr {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(105, 15, kScreen_Width-115, 30)];
    textField.font = [UIFont regularFontWithSize:14];
    textField.textColor = [UIColor colorWithHexString:@"#666666"];
    NSString *placeholder = nil;
    if ([titleStr containsString:@"*"]) {
       placeholder = [NSString stringWithFormat:@"请填写%@",[titleStr substringToIndex:titleStr.length-1]];
    } else {
       placeholder = [NSString stringWithFormat:@"请填写%@",titleStr];
    }
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, placeholder.length)];
    textField.attributedPlaceholder = attributeStr;
    return textField;
}

#pragma mark -- Getters
#pragma mark tableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
//        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = [UIColor whiteColor];
    }
    return _myTableView;
}

#pragma mark 位置
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 15,kScreen_Width-115, 50)];
        _addressLabel.font = [UIFont regularFontWithSize:14];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _addressLabel.numberOfLines = 0;
        _addressLabel.text = @"湖南省长沙市岳麓区枫林三路68号罗马商业广场附近";
    }
    return _addressLabel;
}

#pragma mark 陈列面积
- (UITextField *)areaTextField {
    if (!_areaTextField) {
        _areaTextField = [self setupTextFieldWithPlaceholder:@"陈列面积"];
    }
    return _areaTextField;
}

#pragma mark 提交
- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton submitButtonWithFrame:CGRectZero title:@"保存" target:self selector:@selector(submitCustomerAction:)];
    }
    return _submitBtn;
}


@end
