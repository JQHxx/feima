//
//  FMInvoicingTableView.h
//  feima
//
//  Created by fei on 2020/8/24.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMOrderModel.h"

@class FMInvoicingTableView;
@protocol FMInvoicingTableViewDelegate <NSObject>

- (void)invoicingTableView:(FMInvoicingTableView *)tableView didSelectedRowWithModel:(FMOrderModel *)model;

@end

@interface FMInvoicingTableView : UITableView

@property (nonatomic, weak )id<FMInvoicingTableViewDelegate>viewDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style type:(NSInteger)type;

- (void)loadInvoicingData ;

@end

