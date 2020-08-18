//
//  FMAddCustomerViewController.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMAddCustomerViewController.h"
#import "FMImageCollectionView.h"
#import "FMPublicViewModel.h"
#import "FMCustomerViewModel.h"
#import "BRStringPickerView.h"

@interface FMAddCustomerViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titlesArr;
}

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) UITextField    *nameTextField;   //名称
@property (nonatomic, strong) UITextField    *shortNameTextField; //简称
@property (nonatomic, strong) UITextField    *contactTextField; //联系人
@property (nonatomic, strong) UITextField    *phoneTextField;  //手机号
@property (nonatomic, strong) UILabel        *addressLabel;   //位置
@property (nonatomic, strong) FMImageCollectionView *photoView;
@property (nonatomic, strong) UILabel        *photoTitleLab;  //
@property (nonatomic, strong) UILabel        *industryLab;   //行业类型
@property (nonatomic, strong) UILabel        *levelLab;      //客户等级
@property (nonatomic, strong) UITextField    *areaTextField; //陈列面积
@property (nonatomic, strong) UILabel        *followPressLab; //跟进进度
@property (nonatomic, strong) UILabel        *followLab;    //跟进人
@property (nonatomic, strong) UIView         *bottomView;

@property (nonatomic, strong) FMPublicViewModel *publicAdapter;
@property (nonatomic, strong) FMCustomerViewModel *adapter;

@end

@implementation FMAddCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = self.customerModel ? @"修改客户信息" : @"新增客户";
    
    titlesArr = @[@{@"title":@"基本信息",@"subtitles":@[@"名称*",@"简称",@"联系人*",@"手机号*",@"位置*",@"门头照(0/5)"]},@{@"title":@"详细信息",@"subtitles":@[@"行业类型*",@"客户等级*",@"陈列面积*",@"跟进进度*",@"跟进人"]}];
    
    [self setupUI];
    [self loadPreGroupData];
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
        cell.accessoryType = UITableViewCellAccessoryNone;
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
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            FMImageCollectionView *photoView = [[FMImageCollectionView alloc] initWithFrame:CGRectMake(lab.left, lab.bottom+10, kScreen_Width-40, 68) collectionViewLayout:layout];
            [cell.contentView addSubview:photoView];
            self.photoView = photoView;
        }
    } else {
        if (indexPath.row == 2) { //陈列面积
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:self.areaTextField];
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *valueLab = [self setupLabelWithTitleStr:titleStr tag:indexPath.section*100+indexPath.row];
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
    if (self.customerModel) {
        self.nameTextField.text = self.customerModel.businessName;
        self.shortNameTextField.text = self.customerModel.nickName;
        self.contactTextField.text = self.customerModel.contactName;
        self.phoneTextField.text = self.customerModel.telephone;
        self.addressLabel.text = self.customerModel.address;
        if (!kIsEmptyString(self.customerModel.doorPhoto)) {
            self.photoView.images = [self.customerModel.doorPhoto componentsSeparatedByString:@","];
        }
        
        self.industryLab.textColor = [UIColor colorWithHexString:@"#666666"];
        self.industryLab.text = self.customerModel.industryName;
        self.levelLab.textColor = [UIColor colorWithHexString:@"#666666"];
        self.levelLab.text = self.customerModel.gradeName;
        self.areaTextField.text = [NSString stringWithFormat:@"%ld",self.customerModel.displayArea];
        self.followPressLab.textColor = [UIColor colorWithHexString:@"#666666"];
        self.followPressLab.text = self.customerModel.progressName;
        self.followLab.textColor = [UIColor colorWithHexString:@"#666666"];
        self.followLab.text = self.customerModel.employeeName;
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
        return 140;
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

#pragma mark 选择
- (void)selectedInfoAction:(UITapGestureRecognizer *)gesture {
    NSInteger tag = gesture.view.tag;
    MyLog(@"tag:%ld",tag);
    NSString *title = nil;
    NSArray *data;
    if (tag == 100) {
        title = @"行业类型";
        data = self.publicAdapter.industryTypesArray;
    } else if (tag == 101) {
        title = @"客户等级";
        data = self.publicAdapter.levelArray;
    } else if (tag == 103) {
        title = @"跟进进度";
        data = self.publicAdapter.progressArray;
    }
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (FMGroupModel *model in data) {
        [tempArr addObject:model.dictValue];
    }
    
    [BRStringPickerView showStringPickerWithTitle:title dataSource:tempArr defaultSelValue:nil isAutoSelect:NO resultBlock:^(id selectValue) {
        
    }];
}

#pragma mark -- Private methods
#pragma mark 预加载数据
- (void)loadPreGroupData {
    [self loadIndustryTypeData];
    [self loadCustomerLeveData];
    [self loadFollowUpProgressData];
}

#pragma mark 加载行业类型数据
- (void)loadIndustryTypeData {
    [self loadGroupDataWithGroupStr:kIndustryTypeKey];
}

#pragma mark 加载客户等级数据
- (void)loadCustomerLeveData {
    [self loadGroupDataWithGroupStr:kCustomerLevelKey];
}

#pragma mark 加载跟进进度数据
- (void)loadFollowUpProgressData {
    [self loadGroupDataWithGroupStr:kFollowUpProgressKey];
}

#pragma mark 加载下拉数据
- (void)loadGroupDataWithGroupStr:(NSString *)groupStr {
    [self.publicAdapter loadGroupDataWithGroupStr:groupStr complete:^(BOOL isSuccess) {
        
    }];
}

#pragma mark UI
- (void)setupUI {
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBar_Height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreen_Height-kNavBar_Height);
    }];
}

#pragma mark setup title label
- (UILabel *)setupTitlelabelWithTitleStr:(NSString *)titleStr {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 30)];
    lab.font = [UIFont mediumFontWithSize:16];
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
- (UILabel *)setupLabelWithTitleStr:(NSString *)titleStr tag:(NSInteger)tag{
    UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 15,kScreen_Width-115, 30)];
    valueLab.font = [UIFont regularFontWithSize:16];
    valueLab.textColor = [UIColor colorWithHexString:@"#999999"];
    NSString *placeholder = titleStr;
    if ([titleStr containsString:@"*"]) {
        placeholder = [titleStr substringToIndex:titleStr.length-1];
    }
    valueLab.text = [NSString stringWithFormat:@"请选择%@",placeholder];
    valueLab.tag = tag;
    [valueLab addTapPressed:@selector(selectedInfoAction:) target:self];
    return valueLab;
}

#pragma mark setup textfield
- (UITextField *)setupTextFieldWithPlaceholder:(NSString *)titleStr {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(105, 15, kScreen_Width-115, 30)];
    textField.font = [UIFont regularFontWithSize:16];
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
#pragma mark 提交
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 80)];
        UIButton *submitBtn = [UIButton submitButtonWithFrame:CGRectMake(18, 20, kScreen_Width-36, 46) title:@"保存" target:self selector:@selector(submitCustomerAction:)];
        [_bottomView addSubview:submitBtn];
    }
    return _bottomView;
}

#pragma mark tableView
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.tableFooterView = self.bottomView;
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

- (FMPublicViewModel *)publicAdapter {
    if (!_publicAdapter) {
        _publicAdapter = [[FMPublicViewModel alloc] init];
    }
    return _publicAdapter;
}

- (FMCustomerViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMCustomerViewModel alloc] init];
    }
    return _adapter;
}


@end
