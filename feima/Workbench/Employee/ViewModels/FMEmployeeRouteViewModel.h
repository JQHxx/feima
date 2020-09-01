//
//  FMEmployeeRouteViewModel.h
//  feima
//
//  Created by fei on 2020/8/31.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"


@interface FMEmployeeRouteViewModel : BaseViewModel

/**
 *  员工工作路线列表
 *
 *  @param action  类型
 *  @param complete  请求成功
*/

- (void)loadEmployeeWorkRouteListWithAction:(NSString *)action complete:(AdpaterComplete)complete;

@end

