//
//  FMInstrucationTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMInstrucationModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface FMInstrucationTableViewCell : BaseTableViewCell

- (void)fillContentWithData:(FMInstrucationModel *)model type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
