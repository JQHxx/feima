//
//  FMEmployeeContentView.h
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMEmployeeModel.h"

@class FMEmployeeContentView;
@protocol FMEmployeeContentViewDelegate <NSObject>

- (void)employeeContentView:(FMEmployeeContentView *)contentView didSlectedEmployee:(FMEmployeeModel *)employee index:(NSInteger)index;

@end

@interface FMEmployeeContentView : UIView

@property (nonatomic, weak ) id<FMEmployeeContentViewDelegate>viewDelegate;

- (instancetype)initWithFrame:(CGRect)frame status:(NSInteger)status;

//插入新的员工
- (void)insertEmployeeWithModel:(FMEmployeeModel *)model;

//修改员工信息
- (void)updateEmployeeInfoWithModel:(FMEmployeeModel *)model;

//刷新
- (void)loadNewEmployeeData;

@end



