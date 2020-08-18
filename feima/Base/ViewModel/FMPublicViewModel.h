//
//  FMPublicViewModel.h
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMPublicViewModel : BaseViewModel

@property (nonatomic, copy ) NSArray <FMGroupModel *> *industryTypesArray; //行业类型
@property (nonatomic, copy ) NSArray <FMGroupModel *> *levelArray;        //客户等级
@property (nonatomic, copy ) NSArray <FMGroupModel *> *progressArray;      //跟进进度

/**
 * 字典下拉框
 *
 *  @param groupStr  字典组
 *  @param complete    请求完成
 */
- (void)loadGroupDataWithGroupStr:(NSString *)groupStr
                         complete:(AdpaterComplete)complete;


@end

NS_ASSUME_NONNULL_END
