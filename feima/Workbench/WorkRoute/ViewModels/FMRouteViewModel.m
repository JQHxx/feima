//
//  FMRouteViewModel.m
//  feima
//
//  Created by fei on 2020/8/20.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMRouteViewModel.h"

@interface FMRouteViewModel ()

@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) dispatch_group_t historyDispatchGroup;
@property (nonatomic, assign) NSUInteger firstResponseSize;
@property (nonatomic, assign) NSUInteger total;

@end

@implementation FMRouteViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
