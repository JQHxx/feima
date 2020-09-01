//
//  FMCompetitorTableViewCell.h
//  feima
//
//  Created by fei on 2020/8/13.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMGoodsModel.h"

@protocol FMCompetitorTableViewCellDelegate <NSObject>

//跟新商品
- (void)competitorTableViewCellDidUpdateGoods:(FMGoodsModel *)model;

//上传图片
- (void)competitorTableViewCellDidUploadImages:(NSArray *)images;

//说明
- (void)competitorTableViewCellDidEndEditWithText:(NSString *)text;

@end


@interface FMCompetitorTableViewCell : BaseTableViewCell

@property (nonatomic, weak ) id<FMCompetitorTableViewCellDelegate>cellDelegate;
@property (nonatomic, copy ) NSArray <FMGoodsModel *> *goodsArray;



@end

