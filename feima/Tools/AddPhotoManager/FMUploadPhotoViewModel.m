//
//  FMUploadPhotoViewModel.m
//  feima
//
//  Created by fei on 2020/8/17.
//  Copyright © 2020 hegui. All rights reserved.
//

#import "FMUploadPhotoViewModel.h"

@interface FMUploadPhotoViewModel ()

@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation FMUploadPhotoViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.photosArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark 上传图片
- (void)uploadPhotoRequestWithImage:(UIImage *)image complete:(AdpaterComplete)complete {
    [[HttpRequest sharedInstance] uploadFileRequestWithUrl:api_file_upload image:image parameters:nil complete:^(BOOL isSuccess, id json, NSError *error) {
        [self handlerError:error];
        if (isSuccess) {
            NSString *data = [json safe_objectForKey:@"data"];
            [self.photosArray addObject:data];
            if (complete) complete(YES);
        } else {
            if (complete) complete(NO);
        }
    }];
}

#pragma mark 获取图片数量
- (NSInteger)numberOfImages {
    return self.photosArray.count;
}

#pragma mark 获取某一个图片
- (NSString *)getImageUrlWithIndex:(NSInteger)index {
    NSString *imageUrl = [self.photosArray safe_objectAtIndex:index];
    return imageUrl;
}

#pragma mark 删除图片
- (void)deleteImage:(NSString *)imageUrl {
    [self.photosArray removeObject:imageUrl];
}

#pragma mark 添加图片
- (void)insertImages:(NSArray *)images {
    [self.photosArray removeAllObjects];
    [self.photosArray addObjectsFromArray:images];
}

#pragma mark 所有图片
- (NSArray *)allImages {
    return self.photosArray;
}

@end
