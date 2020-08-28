//
//  FMDateToolView.m
//  feima
//
//  Created by fei on 2020/8/11.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMDateToolView.h"
#import "BRPickerView.h"
#import "CustomDatePickerView.h"
#import "FMEmployeeViewModel.h"

@interface FMDateToolView ()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *valueBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel  *departmentLab;
@property (nonatomic, strong) UIButton *selectBtn; //选择部门

@property (nonatomic, assign) FMDateToolViewType type;
@property (nonatomic,  copy ) NSString  *selDate;
@property (nonatomic,  copy ) NSString  *currentDate;

@property (nonatomic,strong) FMEmployeeViewModel *adapter;
@property (nonatomic,strong) NSMutableArray  *organizationNamesArray;
@property (nonatomic, copy ) NSString  *defaultOrganization;
@property (nonatomic,assign) NSInteger selOrganizationId;

@end

@implementation FMDateToolView

- (instancetype)initWithFrame:(CGRect)frame type:(FMDateToolViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        
        self.selDate = [NSDate currentDateTimeWithFormat:self.type == FMDateToolViewTypeMonth ? @"yyyy-MM":@"yyyy.MM.dd"];
        self.currentDate = [NSDate currentDateTimeWithFormat:self.type == FMDateToolViewTypeMonth ? @"yyyy.MM":@"yyyy.MM.dd"];
        self.selOrganizationId = 0;
        
        [self setupUI];
        [self loadOrganizationsData];
    }
    return self;
}

#pragma mark -- Events
#pragma mark 设置时间
- (void)setDateAction:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self.type == FMDateToolViewTypeMonth ? @"yyyy-MM" : @"yyyy.MM.dd"];
    NSDate *currentDate = [formatter dateFromString:self.selDate];
        
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    if (sender.tag == 10) { //前一月
        if (self.type == FMDateToolViewTypeMonth) {
            [lastMonthComps setMonth:-1];
        } else {
            [lastMonthComps setDay:-1];
        }
    } else {
        if (self.type == FMDateToolViewTypeMonth) {
            [lastMonthComps setMonth:1];
        } else {
            [lastMonthComps setDay:1];
        }
    }
    NSDate *newDate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    self.selDate = [formatter stringFromDate:newDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:self.type == FMDateToolViewTypeMonth ? @"yyyy.MM" : @"yyyy.MM.dd"];
    NSString *dateTitle = [dateFormatter stringFromDate:newDate];
    [self.valueBtn setTitle:dateTitle forState:UIControlStateNormal];
    
    self.rightBtn.enabled = ![dateTitle isEqualToString:self.currentDate];
    
    
    if ([self.delegate respondsToSelector:@selector(dateToolViewDidSelectedDate:)]) {
        [self.delegate dateToolViewDidSelectedDate:dateTitle];
    }
}

#pragma mark 选择时间
- (void)selectedDateAction:(UIButton *)sender {
    kSelfWeak;
    if (self.type == FMDateToolViewTypeMonth) {
        [CustomDatePickerView showDatePickerWithTitle:@"选择月份" defauldValue:self.selDate minDateStr:kMinMonth maxDateStr:nil resultBlock:^(NSString *selectValue) {
            weakSelf.selDate = selectValue;
            NSString *dateTitle = [[FeimaManager sharedFeimaManager] convertToDate:selectValue formatter:@"yyyy-MM" newFormatter:@"yyyy.MM"];
            weakSelf.rightBtn.enabled = ![dateTitle isEqualToString:weakSelf.currentDate];
            [weakSelf.valueBtn setTitle:dateTitle forState:UIControlStateNormal];
            if ([weakSelf.delegate respondsToSelector:@selector(dateToolViewDidSelectedDate:)]) {
                [weakSelf.delegate dateToolViewDidSelectedDate:dateTitle];
            }
        }];
    } else {
        [BRDatePickerView showDatePickerWithTitle:@"选择时间" dateType:UIDatePickerModeDate defaultSelValue:self.selDate minDateStr:@"2019.08.01" maxDateStr:nil isAutoSelect:NO resultBlock:^(NSString *selectValue) {
            weakSelf.selDate = selectValue;
            [weakSelf.valueBtn setTitle:selectValue forState:UIControlStateNormal];
            weakSelf.rightBtn.enabled = ![selectValue isEqualToString:weakSelf.currentDate];
            if ([weakSelf.delegate respondsToSelector:@selector(dateToolViewDidSelectedDate:)]) {
                [weakSelf.delegate dateToolViewDidSelectedDate:selectValue];
            }
        }];
    }
}

#pragma mark 选择部门
- (void)selectDepartmentAction:(UIButton *)sender {
    kSelfWeak;
    [BRStringPickerView showStringPickerWithTitle:@"选择部门" dataSource:self.organizationNamesArray defaultSelValue:self.defaultOrganization isAutoSelect:NO resultBlock:^(id selectValue) {
        [weakSelf.selectBtn setTitle:selectValue forState:UIControlStateNormal];
        weakSelf.defaultOrganization = selectValue;
        if ([weakSelf.defaultOrganization isEqualToString:@"全部"]) {
            weakSelf.selOrganizationId = 0;
        }
        for (FMOrganizationModel *aModel in weakSelf.adapter.organizationArray) {
            if ([aModel.name isEqualToString:selectValue]) {
                weakSelf.selOrganizationId = aModel.organizationId;
                break;
            }
        }
        if ([weakSelf.delegate respondsToSelector:@selector(dateToolViewDidSelectedOrganizationWithOriganizationId:)]) {
            [weakSelf.delegate dateToolViewDidSelectedOrganizationWithOriganizationId:weakSelf.selOrganizationId];
        }
    }];
}

#pragma mark -- Private methods
#pragma mark 获取部门数据
- (void)loadOrganizationsData {
    kSelfWeak;
    [self.adapter loadOrganizationDataComplete:^(BOOL isSuccess) {
        if (isSuccess) {
            NSArray *data = weakSelf.adapter.organizationArray;
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for (FMOrganizationModel *model in data) {
                [tempArr addObject:model.name];
            }
            [tempArr insertObject:@"全部" atIndex:0];
            weakSelf.organizationNamesArray = tempArr;
            weakSelf.defaultOrganization = tempArr[0];
        }
    }];
}

#pragma mark UI
- (void)setupUI {
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self addSubview:self.valueBtn];
    [self.valueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(30);
    }];
    
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(30);
    }];
    
    [self addSubview:self.departmentLab];
    [self.departmentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.selectBtn.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(45, 30));
    }];
}

#pragma mark -- Getters
#pragma mark 上一页
- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setImage:[UIImage drawImageWithName:@"arrow_left" size:CGSizeMake(22, 22)] forState:UIControlStateNormal];
        _leftBtn.tag = 10;
        [_leftBtn addTarget:self action:@selector(setDateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

#pragma mark 日期
- (UIButton *)valueBtn {
    if (!_valueBtn) {
        _valueBtn = [[UIButton alloc] init];
        [_valueBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _valueBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        [_valueBtn setTitle:self.currentDate forState:UIControlStateNormal];
        [_valueBtn addTarget:self action:@selector(selectedDateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _valueBtn;
}

#pragma mark 下一页
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setImage:[UIImage drawImageWithName:@"arrow_right" size:CGSizeMake(22, 22)] forState:UIControlStateNormal];
        _rightBtn.tag = 11;
        [_rightBtn addTarget:self action:@selector(setDateAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.enabled = NO;
    }
    return _rightBtn;
}

#pragma mark 部门
- (UILabel *)departmentLab {
    if (!_departmentLab) {
        _departmentLab = [[UILabel alloc] init];
        _departmentLab.font = [UIFont regularFontWithSize:14];
        _departmentLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _departmentLab.text = @"部门：";
    }
    return _departmentLab;
}

#pragma mark 选择部门
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont regularFontWithSize:14];
        [_selectBtn addTarget:self action:@selector(selectDepartmentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (FMEmployeeViewModel *)adapter {
    if (!_adapter) {
        _adapter = [[FMEmployeeViewModel alloc] init];
    }
    return _adapter;
}

- (NSMutableArray *)organizationNamesArray {
    if (!_organizationNamesArray) {
        _organizationNamesArray = [[NSMutableArray alloc] init];
    }
    return _organizationNamesArray;
}


@end
