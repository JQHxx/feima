//
//  FMUploadPhotoViewModel.h
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "BaseViewModel.h"


@interface FMUploadPhotoViewModel : BaseViewModel

/**
 *  上传图片
 *
 *  @param image 图片
 *  @param complete  请求成功
*/
- (void)uploadPhotoRequestWithImage:(UIImage *)image
                           complete:(AdpaterComplete)complete;

/**
 *  获取图片数量
 *
*/
- (NSInteger)numberOfImages;

/**
 *  获取某一个图片
 *
 *  @param index 图片
*/
- (NSString *)getImageUrlWithIndex:(NSInteger)index;

/**
 *  删除某一个图片
 *
 *  @param imageUrl 图片
*/
- (void)deleteImage:(NSString *)imageUrl;

- (NSArray *)allImages;

@end

