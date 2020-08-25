//
//  FMInstrucationTableView.h
//  feima
//
//  Created by fei on 2020/8/22.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMInstrucationModel.h"

@class FMInstrucationTableView;
@protocol FMInstrucationTableViewDelegate <NSObject>

- (void)instrucationTableView:(FMInstrucationTableView *)tableView didSelectedRowWithModel:(FMInstrucationModel *)model;

@end

@interface FMInstrucationTableView : UITableView

@property (nonatomic, weak ) id<FMInstrucationTableViewDelegate>viewDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style type:(NSInteger)type;

@end

