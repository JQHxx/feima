//
//  FMGoodsViewModel.h
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMGoodsModel.h"


@interface FMGoodsViewModel : BaseViewModel

@property (nonatomic,assign) NSInteger goodsId;

/**
 *  商品列表
 *
 *  @param pageModel 分页
 *  @param name      商品名称
 *  @param complete  请求成功
*/
- (void)loadGoodsListWithPage:(FMPageModel *)pageModel
                           name:(NSString *)name
                       complete:(AdpaterComplete)complete;

/**
 *  添加或修改商品
 *
 *  @param type  0添加 1修改
 *  @param goodsId  商品id
 *  @param name   名称
 *  @param categoryName 品类
 *  @param companyId      公司id
 *  @param images      图片
 *  @param complete  请求成功
*/
- (void)addOrUpdateGoodsWithType:(NSInteger)type
                         goodsId:(NSInteger)goodsId
                            name:(NSString *)name
                    categoryName:(NSString *)categoryName
                       companyId:(NSInteger)companyId
                          images:(NSString *)images
                        complete:(AdpaterComplete)complete;

/**
 *  删除商品
 *
 *  @param goodsIds  商品 id集合
 *  @param complete  请求成功
*/
- (void)deleteGoodsWithGoodsIds:(NSString *)goodsIds
                          complete:(AdpaterComplete)complete;

/**
 *  商品上架或下架
 *
 *  @param goodsId  商品 id
 *  @param enable  是否上架
 *  @param complete  请求成功
*/
- (void)setGoodsEnableWithGoodsId:(NSInteger)goodsId
                           enable:(BOOL)enable
                         complete:(AdpaterComplete)complete;

/**
 * 商品总数
 */
- (NSInteger)numberOfGoodsList;

/**
 *  返回商品对象
*/
- (FMGoodsModel *)getGoodsModelWithIndex:(NSInteger)index;

/**
 *  修改商品对象
*/
- (void)replaceGoodsWithNewGoods:(FMGoodsModel *)model;


/**
 *  插入商品对象
*/
- (void)insertGoods:(FMGoodsModel *)model;

@end

