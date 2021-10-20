//
//  GLIMImageProcesser.h
//  GLIMUI
//
//  Created by huangbiao on 2017/12/27.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>

/**
 图片处理
 */
@interface GLIMImageProcesser : NSObject

#pragma mark - 构造视频消息
/// 构造视频消息
/// @param videoInfos 视频信息{"videoUrl":"xxxx", "coverImage":xxxx, "coverUrl":"xxxxx", "duration":"xxxxx", "pathDirectory":xxxx}
/// @param videoIndex 视频索引
+ (GLIMMessage *)messageWithVideoInfos:(NSDictionary *)videoInfos
                               atIndex:(NSInteger)videoIndex;

#pragma mark - 构造图片消息
/**
 根据图片数据生成图片消息

 @param imageData 图片数据
 @param imageIndex 图片索引
 @return 图片消息
 */
+ (GLIMMessage *)messageWithImageData:(NSData *)imageData atIndex:(NSInteger)imageIndex;

/**
 根据图片生成图片消息

 @param image 图片
 @param imageIndex 图片索引
 @return 图片消息
 */
+ (GLIMMessage *)messageWithImage:(UIImage *)image atIndex:(NSInteger)imageIndex;

/// 根据图片生成图片消息
/// @param image 图片
/// @param imageIndex 图片索引
/// @param completion 消息数据
+ (void)processQRCodeWithImage:(UIImage *)image
                       atIndex:(NSInteger)imageIndex
                    completion:(void (^)(GLIMMessage *))completion;

/// 根据图片生成图片消息
/// @param image 图片
/// @param completion 消息数据
+ (void)onlyProcessQRCodeWithImage:(UIImage *)image completion:(void (^)(GLIMMessage *))completion;

/**
 对图片进行处理，返回处理后的图片数据

 @param image 原图片
 @param completion 回调函数，返回处理后的图片数据
 */
+ (void)processImage:(UIImage *)image completion:(void (^)(NSData *))completion;

/**
 对原图进行处理，返回处理后的图片

 @param originalImage 原图片
 @param completion 回调函数，返回处理后的图片
 */
+ (void)processImage:(UIImage *)originalImage
    returnImageBlock:(void (^)(UIImage *processedImage))completion;

@end
