//
//  BaseViewModel.m
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

+ (NSInteger)pageSize{
    return 15;
}

- (BOOL)hasMoreData{
    return NO;
}

- (BOOL)isEmpty{
    return YES;
}




@end
