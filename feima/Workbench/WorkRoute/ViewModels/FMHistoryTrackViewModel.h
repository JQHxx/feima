//
//  FMHistoryTrackViewModel.h
//  feima
//
//  Created by fei on 2020/8/21.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"
#import "FMHistoryTrackModel.h"

typedef void (^HistoryQueryCompletionHandler) (NSArray *points);

@interface FMHistoryTrackViewModel : BaseViewModel

@property (nonatomic, copy) HistoryQueryCompletionHandler completionHandler;

- (void)queryHistoryWithTrack:(FMHistoryTrackModel *)track;

@end

