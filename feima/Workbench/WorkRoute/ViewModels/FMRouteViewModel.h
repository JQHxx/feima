//
//  FMRouteViewModel.h
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"

@interface FMRouteViewModel : BaseViewModel


/**
 *    获取拜访记录
 *
 *  @param pageModel 分页
 *  @param latitude      纬度
 *  @param longitude      经度
 *  @param contactName      联系人
 *  @param visitCode      1 未拜访 2 已拜访
 *  @param complete  请求成功
*/
- (void)loadCustomerListWithPage:(FMPageModel *)pageModel
                        latitude:(double)latitude
                       longitude:(double)longitude
                     contactName:(NSString *)contactName
                       visitCode:(NSInteger)visitCode
                        complete:(AdpaterComplete)complete;




@end

