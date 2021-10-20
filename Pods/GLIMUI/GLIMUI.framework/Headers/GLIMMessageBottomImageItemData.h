//
//  GLIMMessageBottomImageItemData.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/16.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMMessageBottomActionItemData.h"


@class GLFetchImageAsset;

@interface GLIMMessageImageProcesser : NSObject

+ (void)processImageAsset:(GLFetchImageAsset *)imageAsset
               completion:(void (^)(NSData *))completion;

+ (void)processImageAsset:(GLFetchImageAsset *)imageAsset
         returnImageBlock:(void (^)(UIImage *))completion;

@end



/**
 相册
 */
@interface GLIMMessageBottomAlbumItemData : GLIMMessageBottomActionItemData

@end

/**
 拍照
 */
@interface GLIMMessageBottomCaremaItemData : GLIMMessageBottomActionItemData

@end
