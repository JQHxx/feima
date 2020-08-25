//
//  FMEmployeeTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMEmployeeModel.h"

typedef void(^MoreHandleBlock)(FMEmployeeModel *employee, NSInteger index);

@interface FMEmployeeTableViewCell : BaseTableViewCell

@property (nonatomic, copy ) MoreHandleBlock moreBlock;

- (void)fillContentWithData:(FMEmployeeModel *)model status:(NSInteger)status;

@end

