//
//  FMAddressModel.h
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMAddressModel : BaseModel

//维度
@property(nonatomic,assign) double latitude;
//经度
@property(nonatomic,assign) double longitude;
///省份名字属性
@property(nonatomic, copy ) NSString *province;

///城市名字属性
@property(nonatomic, copy ) NSString *city;

///区名字属性
@property(nonatomic, copy ) NSString *district;

///街道名字属性
@property(nonatomic, copy ) NSString *street;

///街道号码属性
@property(nonatomic, copy ) NSString *streetNumber;

///乡镇名字属性
@property(nonatomic, copy ) NSString *town;

///位置语义化结果的定位点在什么地方周围的描述信息
@property(nonatomic, copy ) NSString *locationDescribe;
   
@property(nonatomic, copy ) NSString *detailAddress;

@property(nonatomic, copy ) NSString *userName;

@end

NS_ASSUME_NONNULL_END
