//
//  FMVisitViewModel.m
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMVisitViewModel.h"
#import "FMSelectGoodsModel.h"

@interface FMVisitViewModel ()

@property (nonatomic,strong) NSMutableArray<FMGoodsModel *> *goodsList; //销售
@property (nonatomic,strong) NSMutableArray<FMGoodsModel *> *stockGoodsList; //库存
@property (nonatomic,strong) NSMutableArray<FMGoodsModel *> *competeGoodsList; //竞品

@end

@implementation FMVisitViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.goodsList = [[NSMutableArray alloc] init];
        self.stockGoodsList = [[NSMutableArray alloc] init];
        self.competeGoodsList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark 销售 （商品列表）
- (void)loadEmployeeGoodsListWithComplete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] getRequestWithUrl:api_goods_employee_list parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSArray *data = [json safe_objectForKey:@"data"];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FMSelectGoodsModel class] json:data];
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for (FMSelectGoodsModel *model in arr) {
                model.goods.isInStock = YES;
               [tempArr addObject:model.goods];
            }
            self.goodsList = tempArr;
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 商品数
- (NSInteger)numberOfGoodsList {
    return self.goodsList.count;
}

#pragma mark 商品对象
- (FMGoodsModel *)getGoodsModelWithIndex:(NSInteger)index {
    FMGoodsModel *model = [self.goodsList safe_objectAtIndex:index];
    return model;
}

#pragma mark 库存 (本品在售商品列表)
- (void)loadSalesGoodsListWithComplete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] getRequestWithUrl:api_goods_own_list parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSArray *data = [json safe_objectForKey:@"data"];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FMGoodsModel class] json:data];
            self.stockGoodsList = [NSMutableArray arrayWithArray:arr];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 库存商品数
- (NSInteger)numberOfStockGoodsList {
    return self.stockGoodsList.count;
}

#pragma mark 库存商品对象
- (FMGoodsModel *)getStockGoodsModelWithIndex:(NSInteger)index {
    FMGoodsModel *model = [self.stockGoodsList safe_objectAtIndex:index];
    return model;
}

#pragma mark 更改商品信息
- (void)replaceGoodsModelWithNewGoods:(FMGoodsModel *)model {
    NSInteger index = -1;
    if (model.isInStock) {
        for (NSInteger i=0; i<self.goodsList.count; i++) {
            FMGoodsModel *aModel = self.goodsList[i];
            if (aModel.goodsId == model.goodsId) {
                index = i;
                break;
            }
        }
        if (index > -1) {
            [self.goodsList replaceObjectAtIndex:index withObject:model];
        }
    } else {
        for (NSInteger i=0; i<self.stockGoodsList.count; i++) {
            FMGoodsModel *aModel = self.stockGoodsList[i];
            if (aModel.goodsId == model.goodsId) {
                index = i;
                break;
            }
        }
        if (index > -1) {
            [self.stockGoodsList replaceObjectAtIndex:index withObject:model];
        }
    }
}

#pragma mark 竞品在售商品列表
- (void)loadCompeteGoodsListWithComplete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] getRequestWithUrl:api_goods_compete_list parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSArray *data = [json safe_objectForKey:@"data"];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FMGoodsModel class] json:data];
            self.competeGoodsList = [NSMutableArray arrayWithArray:arr];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 竞品在售商品列表
- (NSArray<FMGoodsModel *> *)getAllCompeteGoodsList {
    return self.competeGoodsList;
}

#pragma mark 更改竞品商品信息
- (void)replaceCompetitorGoodsModelWithNewGoods:(FMGoodsModel *)model {
    NSInteger index = -1;
    for (NSInteger i=0; i<self.stockGoodsList.count; i++) {
        FMGoodsModel *aModel = self.stockGoodsList[i];
        if (aModel.goodsId == model.goodsId) {
            index = i;
            break;
        }
    }
    if (index > -1) {
        [self.competeGoodsList replaceObjectAtIndex:index withObject:model];
    }
}

@end
