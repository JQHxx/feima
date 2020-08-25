//
//  FMHistoryTrackViewModel.m
//  feima
//
//  Created by fei on 2020/8/21.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMHistoryTrackViewModel.h"
#import "FMHistoryTrackModel.h"
#import "FMHistoryTrackPoint.h"

@interface FMHistoryTrackViewModel ()<BTKTrackDelegate>

@property (nonatomic, strong) NSMutableArray   *points;
@property (nonatomic, strong) dispatch_group_t historyDispatchGroup;
@property (nonatomic, assign) NSUInteger       firstResponseSize;
@property (nonatomic, assign) NSUInteger       total;
@property (nonatomic, strong) FMHistoryTrackModel *trackModel;

@end

// 轨迹查询每页的上限为5000条，但是若请求纠偏甚至绑路后的轨迹，比较耗时。综合考虑，我们选取每页1000条
static NSUInteger const kHistoryTrackPageSize = 1000;

@implementation FMHistoryTrackViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _points = [NSMutableArray array];
        _historyDispatchGroup = dispatch_group_create();
    }
    return self;
}

#pragma mark 查询历史轨迹
- (void)queryHistoryWithTrack:(FMHistoryTrackModel *)track {
    MyLog(@"queryHistoryWithTrack");
    // 清空已有数据
    [self.points removeAllObjects];
    self.trackModel = track;
    
    // 发送第一次请求，确定size和total，以决定后续是否还需要发请求，以及发送请求的pageSize和pageIndex
    BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:track.entityName startTime:track.startTime endTime:track.endTime isProcessed:track.isProcessed processOption:track.processOption supplementMode:track.supplementMode outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_ASC pageIndex:1 pageSize:kHistoryTrackPageSize serviceID:key_baidu_service_id tag:1];
    [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
}

#pragma mark 实时位置查询的回调方法
- (void)onQueryHistoryTrack:(NSData *)response {
    MyLog(@"onQueryHistoryTrack");
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        MyLog(@"HISTORY TRACK查询格式转换出错");
        return;
    }
    if (0 != [dict[@"status"] intValue]) {
        MyLog(@"HISTORY TRACK查询返回错误");
        return;
    }
    
    // 每次回调得到的历史轨迹点，都加到数组中
    for (NSDictionary *point in dict[@"points"]) {
        FMHistoryTrackPoint *p = [[FMHistoryTrackPoint alloc] init];
        p.coordinate = CLLocationCoordinate2DMake([point[@"latitude"] doubleValue], [point[@"longitude"] doubleValue]);
        p.loctime = [point[@"loc_time"] unsignedIntValue];
        p.direction = [point[@"direction"] unsignedIntValue];
        [self.points addObject:p];
    }
    
    // 对于第一次回调结果，根据total和size，确认还需要发送几次请求，并行发送这些请求
    // 使用dispatch_group同步多次请求，当所有请求均收到响应后，points属性中存储的就是所有的轨迹点了
    // 根据请求的是否是纠偏后的结果，处理方式稍有不同：
    // 若是纠偏后的轨迹，直接使用direction字段即可，该方向是准确的；
    // 若是原始的轨迹，direction字段可能不准，我们自己根据相邻点计算出方向。
    // 最好都是请求纠偏后的轨迹，简化客户端处理步骤
    if ([dict[@"tag"] unsignedIntValue] == 1) {
           self.firstResponseSize = [dict[@"size"] unsignedIntValue];
           self.total = [dict[@"total"] unsignedIntValue];
           for (size_t i = 0; i < self.total / self.firstResponseSize; i++) {
               dispatch_group_enter(self.historyDispatchGroup);
               BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:self.trackModel.entityName startTime:self.trackModel.startTime endTime:self.trackModel.endTime isProcessed:self.trackModel.isProcessed processOption:self.trackModel.processOption supplementMode:self.trackModel.supplementMode outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_ASC pageIndex:(2 + i) pageSize:kHistoryTrackPageSize serviceID:key_baidu_service_id tag:(2 + i)];
               [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
           }
           dispatch_group_notify(self.historyDispatchGroup, GLOBAL_QUEUE, ^{
               // 将所有查询到的轨迹点，按照loc_time升序排列，注意是稳定排序。
               //因为绑路时会补充道路形状点，其loc_time与原始轨迹点一样，相同的loc_time在排序后必须保持原始的顺序，否则direction不准。
               [self.points sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(FMHistoryTrackPoint *  _Nonnull obj1, FMHistoryTrackPoint *  _Nonnull obj2) {
                   if (obj1.loctime < obj2.loctime) {
                       return NSOrderedAscending;
                   } else if (obj1.loctime > obj2.loctime) {
                       return NSOrderedDescending;
                   } else {
                       return NSOrderedSame;
                   }
               }];
               // 如果我们请求的是原始轨迹，最好自己计算每个轨迹点的方向，因为此时返回的direction字段可能不准确。
               if (FALSE == self.trackModel.isProcessed) {
                   // 根据相邻两点之间的坐标，计算方向
                   for (size_t i = 0; i < self.points.count - 1; i++) {
                       FMHistoryTrackPoint *point1 = (FMHistoryTrackPoint *)self.points[i];
                       FMHistoryTrackPoint *point2 = (FMHistoryTrackPoint *)self.points[i + 1];
                       double lat1 = [self getRadianFromDegree:point1.coordinate.latitude];
                       double lon1 = [self getRadianFromDegree:point1.coordinate.longitude];
                       double lat2 = [self getRadianFromDegree:point2.coordinate.latitude];
                       double lon2 = [self getRadianFromDegree:point2.coordinate.longitude];
                       double deltaOfLon = lon2 - lon1;
                       double y = sin(deltaOfLon) * cos(lat2);
                       double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaOfLon);
                       double radianDirection = atan2(y, x);
                       double degreeDirection = [self getDegreeFromRadian:radianDirection];
                       ((FMHistoryTrackPoint *)self.points[i]).direction = [self mapGeometryDirectionToGPSDirection:degreeDirection];
                   }
               }
               if (self.completionHandler) {
                   self.completionHandler(self.points);
               }
           });
       } else {
           dispatch_group_leave(self.historyDispatchGroup);
       }
}

- (double)getRadianFromDegree:(double)degree {
    return degree * M_PI / 180.0;
}

- (double)getDegreeFromRadian:(double)radian {
    return radian * 180.0 / M_PI;
}

- (double)mapGeometryDirectionToGPSDirection:(double)geometryDirection {
    double gpsDirection = geometryDirection;
    if (geometryDirection < 0) {
        gpsDirection = geometryDirection + 360.0;
    }
    return gpsDirection;
}

@end
