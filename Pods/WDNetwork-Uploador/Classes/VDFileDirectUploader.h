//
//  VDFileDirectUploader.h
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/8/29.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDFileUploader.h"
#import "VDFileUploadConstant.h"
#import "VDUploaderProtocol.h"


@interface VDFileDirectUploader : VDFileUploader <VDUploaderProtocol>

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
 直接上传方法

 @param data 内容，可能是NSData、UIImage、NSString-路径, NSData标示已经压缩好了
 @param scope scope
 @param type 类型
 @param quality 图片压缩质量
 @param prv 是否私有, YES表示是私有图片
 @param unadjust 是否服务器端调整, YES表示不需要调整
 @param progress 上传进度
 @param complete 回调
 
 @return VDFileDirectUploader
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
