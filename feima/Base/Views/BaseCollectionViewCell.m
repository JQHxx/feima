//
//  BaseCollectionViewCell.m
//  feima
//
//  Created by fei on 2020/8/18.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
    }
    return self;
}

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (void)fillContentWithData:(id)obj {
    //TO DO: override
}



@end
