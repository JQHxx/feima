//
//  FMVisitRecordHeadView.m
//  feima
//
//  Created by fei on 2020/9/1.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMVisitRecordHeadView.h"
#import "FMCustomerHeadView.h"
#import "XYPieChart.h"

@interface FMVisitRecordHeadView ()

@property (nonatomic,strong) FMCustomerHeadView *customerHeadView;
@property (nonatomic,strong) XYPieChart          *salesChart;
@property (nonatomic,strong) XYPieChart          *visitChart;

@end

@implementation FMVisitRecordHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark 客户信息
- (FMCustomerHeadView *)customerHeadView {
    if (!_customerHeadView) {
        _customerHeadView = [[FMCustomerHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 140)];
    }
    return _customerHeadView;
}

@end
