//
//  FMClockInViewModel.h
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMPunchTimeModel.h"
#import "FMPunchRecordModel.h"

typedef enum : NSUInteger {
    FMClockInTypeToWork, //上班
    FMClockInTypeOffWork, //下班
} FMClockInType;

@interface FMClockInViewModel : BaseViewModel

@property (nonatomic, copy ) NSString *punchStartTime;
@property (nonatomic, copy ) NSString *punchEndTime;
@property (nonatomic, copy ) NSString *punchAfterStartTime;
@property (nonatomic, copy ) NSString *punchAfterEndTime;
@property (nonatomic,strong) NSArray  *statusArray; //打卡状态

/**
 * 获取打卡时间
 */
- (void)loadPunchTimeDataComplete:(AdpaterComplete)complete;


/**
 * 重复打卡验证
 *  @param type  上班或下班
 *  @param complete  请求成功
 */
- (void)verifyRepeatedPunchWithType:(FMClockInType)type complete:(AdpaterComplete)complete;

/**
 * 打卡
 *  @param type  上班或下班
 *  @param address  地址
 *  @param images  图片地址
 *  @param longtude  经度
 *  @param latitude  纬度
 *  @param complete  请求成功
 */
- (void)addPunchRequetWithType:(FMClockInType)type
                       address:(NSString *)address
                         images:(NSArray *)images
                      longtude:(double)longtude
                      latitude:(double)latitude
                      complete:(AdpaterComplete)complete;

/**
 * 打卡记录   
 *  @param month  按月查询
 *  @param status 打卡状态
 *
 */
- (void)loadPunchRecordsDataWithMonth:(NSString *)month
                              status:(NSString *)status
                            complete:(AdpaterComplete)complete;

/**
 * 返回打卡记录数量
*/
- (NSInteger)numberOfPunchRecordsData;

/**
 * 返回打卡记录
*/
- (FMPunchRecordModel *)getRecordModelWithIndex:(NSInteger)index;


@end

