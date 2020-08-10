//
//  BaseModel.h
//  feima
//
//  Created by fei on 2020/8/3.
//  Copyright © 2020 hegui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject<NSCoding, NSCopying>

@property (nonatomic,  copy ) NSString  *createAccount;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic,  copy ) NSString  *updateAccount;
@property (nonatomic, assign) NSInteger updateTime;

@end

NS_ASSUME_NONNULL_END
