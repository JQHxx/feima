//
//  FMVisitTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol FMVisitTableViewCellDelegate <NSObject>

//添加图片
- (void)visitTableViewCellDidUploadImages:(NSArray *)images;

//拜访总结
- (void)visitTableViewCellDidEndEditWithText:(NSString *)text;

@end

@interface FMVisitTableViewCell : BaseTableViewCell

@property (nonatomic, weak ) id<FMVisitTableViewCellDelegate>cellDelegate;

@end

