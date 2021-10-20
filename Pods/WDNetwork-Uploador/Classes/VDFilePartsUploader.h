//
//  VDFilePartsUploader.h
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/9/3.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDFileUploader.h"
#import "VDFileUploadConstant.h"
#import "VDUploaderProtocol.h"


@interface VDFilePartsUploader : VDFileUploader <VDUploaderProtocol>

+ (id)UploadIMG:(id)img
          scope:(NSString *)scope
       progress:(void(^)(NSProgress *progress))progress
       complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete;

+ (id)UploadVIDEO:(id)video
            scope:(NSString *)scope
         progress:(void(^)(NSProgress *progress))progress
         complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete;

/// 视频需要GIF
/// @param video ''
/// @param scope ''
/// @param param {gifFps: 1~60, start:（0，视频时长], gifDuration:（0，视频时长]}
/// @param progress ''
/// @param complete ''
+ (id)UploadVIDEO:(id)video
            scope:(NSString *)scope
            param:(NSDictionary *)param
         progress:(void(^)(NSProgress *progress))progress
         complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete
        sessionId:(NSString *)sessionId;

/**
 分片上传
 
 @param data 文件
 @param scope ""
 @param type 文件类型
 @param quality 图片压缩质量
 @param prv 是否私有, YES表示是私有图片
 @param unadjust 是否服务器端调整, YES表示不需要调整
 @param progress 上传进度
 @param complete 回调

 @return VDFilePartsUploader
 */
+ (id)UploadFile:(id)data
           scope:(NSString *)scope
            type:(VDUploadType)type
         quality:(CGFloat)quality
             prv:(BOOL)prv
        unadjust:(BOOL)unadjust
        progress:(void(^)(NSProgress *progress))progress
        complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete;

@end
