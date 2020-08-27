//
//  FMGoodsViewModel.m
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMGoodsViewModel.h"

@interface FMGoodsViewModel ()

@property (nonatomic,strong) NSMutableArray *goodsList;
@property (nonatomic,strong) FMPageModel    *goodsPage;

@end

@implementation FMGoodsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.goodsList = [[NSMutableArray alloc] init];
        self.goodsPage = [[FMPageModel alloc] init];
    }
    return self;
}

#pragma mark 商品列表
- (void)loadGoodsListWithPage:(FMPageModel *)pageModel
                         name:(NSString *)name
                     complete:(AdpaterComplete)complete {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    parameters[@"pageSize"] = @(pageModel.pageSize);
    if (!kIsEmptyString(name)) {
        parameters[@"name"] = name;
    }
    [[HttpRequest sharedInstance] getRequestWithUrl:api_goods_list parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            self.goodsPage.total = [json safe_integerForKey:@"total"];
            NSArray *data = [json safe_objectForKey:@"data"];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[FMGoodsModel class] json:data];
            if (pageModel.pageNum == 1) {
                [self.goodsList removeAllObjects];
            }
            [self.goodsList addObjectsFromArray:arr];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 添加或修改商品
- (void)addOrUpdateGoodsWithType:(NSInteger)type
                         goodsId:(NSInteger)goodsId
                            name:(NSString *)name
                    categoryName:(NSString *)categoryName
                       companyId:(NSInteger)companyId
                          images:(NSString *)images
                        complete:(AdpaterComplete)complete {
    NSString *url = type == 1 ? api_goods_update : api_goods_add;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (goodsId > 0) {
        parameters[@"goodsId"] = @(goodsId);
    }
    parameters[@"name"] = name;
    parameters[@"categoryName"] = categoryName;
    parameters[@"companyId"] = @(companyId);
    parameters[@"images"] = images;
    [[HttpRequest sharedInstance] postWithUrl:url parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            if (type == 0) {
                NSDictionary *data = [json safe_objectForKey:@"data"];
                self.goodsId = [data safe_integerForKey:@"id"];
            }
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 删除商品
- (void)deleteGoodsWithGoodsIds:(NSString *)goodsIds complete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] postWithUrl:api_goods_remove parameters:@{@"goodsIds":goodsIds} complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            FMGoodsModel *selModel;
            for (FMGoodsModel *model in self.goodsList) {
                if (model.goodsId == [goodsIds integerValue]) {
                    selModel = model;
                    break;
                }
            }
            [self.goodsList removeObject:selModel];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 商品上架或下架
- (void)setGoodsEnableWithGoodsId:(NSInteger)goodsId
                            enable:(BOOL)enable
                          complete:(AdpaterComplete)complete {
    NSString *url = enable ? api_goods_enable : api_goods_disable ;
    NSDictionary *paratemers = @{@"goodsId":@(goodsId)};
    [[HttpRequest sharedInstance] postWithUrl:url parameters:paratemers complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            for (FMGoodsModel *model in self.goodsList) {
                if (model.goodsId == goodsId) {
                    model.status = enable ? 1 : 0;
                }
            }
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
    
}

#pragma mark  本品在售商品列表
- (void)loadSalesGoodsListWithType:(NSInteger)type
                              page:(FMPageModel *)pageModel
                          complete:(AdpaterComplete)complete {
    NSString *url = type == 0 ? api_goods_own_list : api_goods_employee_list;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pageNum"] = @(pageModel.pageNum);
    parameters[@"pageSize"] = @(pageModel.pageSize);
    [[HttpRequest sharedInstance] getRequestWithUrl:url parameters:parameters complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            self.goodsPage.total = [json safe_integerForKey:@"total"];
            NSArray *data = [json safe_objectForKey:@"data"];
            if (type == 0) {
                NSArray *arr = [NSArray yy_modelArrayWithClass:[FMGoodsModel class] json:data];
                if (pageModel.pageNum == 1) {
                    [self.goodsList removeAllObjects];
                }
                [self.goodsList addObjectsFromArray:arr];
            } else {
                NSArray *arr = [NSArray yy_modelArrayWithClass:[FMSelectGoodsModel class] json:data];
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                for (FMSelectGoodsModel *model in arr) {
                    [tempArr addObject:model.goods];
                }
                if (pageModel.pageNum == 1) {
                    self.goodsList = tempArr;
                } else {
                    [self.goodsList addObjectsFromArray:tempArr];
                }
            }
            
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

#pragma mark   返回商品对象
- (FMGoodsModel *)getGoodsModelWithIndex:(NSInteger)index {
    FMGoodsModel *model = [self.goodsList safe_objectAtIndex:index];
    return model;
}

#pragma mark 是否还有更多
- (BOOL)hasMoreData {
    if(self.goodsPage && self.goodsList.count > 0) {
        return self.goodsPage.total > self.goodsList.count;
    }
    return NO;
}

#pragma mark 替换商品
- (void)replaceGoodsWithNewGoods:(FMGoodsModel *)model {
    NSInteger index = -1;
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
}

#pragma mark 插入商品
- (void)insertGoods:(FMGoodsModel *)model {
    [self.goodsList insertObject:model atIndex:0];
}

@end
