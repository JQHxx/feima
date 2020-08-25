//
//  FMAddGoodsViewController.h
//  feima
//
//  Created by fei on 2020/8/6.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewController.h"
#import "FMGoodsModel.h"

typedef void(^UpdateGoodsSuccess)(FMGoodsModel *goods);
typedef void(^AddGoodsSuccess)(FMGoodsModel *goods);

@interface FMAddGoodsViewController : BaseViewController

@property (nonatomic ,strong) FMGoodsModel *goods;
@property (nonatomic,  copy ) UpdateGoodsSuccess updateSuccess;
@property (nonatomic,  copy ) AddGoodsSuccess addSuccess;

@end

