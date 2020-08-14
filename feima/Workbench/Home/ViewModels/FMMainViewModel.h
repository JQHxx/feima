//
//  FMMainViewModel.h
//  feima
//
//  Created by fei on 2020/8/14.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMWorkbenchModel.h"


@interface FMMainViewModel : BaseViewModel

/**
 * 获取菜单权限
 */
- (void)loadMenuListComplete:(AdpaterComplete)complete;

/**
 * 返回工作台信息数量
*/
- (NSInteger)numberOfWorkbenchList;

/**
 * 返回某一个工作台信息
*/
- (NSDictionary *)getWorkbenchInfoWithIndex:(NSInteger)index;

@end

