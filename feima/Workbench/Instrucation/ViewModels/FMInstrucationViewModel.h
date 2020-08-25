//
//  FMInstrucationViewModel.h
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMInstrucationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMInstrucationViewModel : BaseViewModel

/**
 *  接收指令列表
 *
 *  @param pageModel 分页
 *  @param type 0接收 1发送
 *  @param complete  请求成功
*/
- (void)loadInstrucationListWithPage:(FMPageModel *)pageModel
                                type:(NSInteger)type
                            complete:(AdpaterComplete)complete;

/**
 *  指令完成（去总结）
 *
 *  @param instructionRecordId 指令记录id
 *  @param summary 总结
 *  @param images  图片
 *  @param complete  请求成功
*/
- (void)instrucationCompleteWithInstructionRecordId:(NSInteger)instructionRecordId
                                            summary:(NSString *)summary
                                             images:(NSString *)images
                                           complete:(AdpaterComplete)complete;

/**
 * 指令总数
 */
- (NSInteger)numberOfInstrucationList;

/**
 *  返回指令对象
*/
- (FMInstrucationModel *)getInstrucationModelWithIndex:(NSInteger)index;




@end

NS_ASSUME_NONNULL_END
