//
//  VDFileUploador.h
//  WDNetworkingDemo
//
//  Created by yangxin02 on 2018/8/28.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WDNetwork-Base/WDNetworkEnum.h>

#import "VDFileUploadConstant.h"
#import "VDFileUploaderProcessDO.h"


#define VDUploadVersion @"3.0.0"


@class WDNErrorDO;

@interface VDFileUploador : NSObject

+ (NSString *)host;
+ (NSString *)UA;


/**
 初始化

 @param env 环境
 @param appName ''
 */
+ (void)startWithEnv:(WDNetworkEnvType)env appName:(NSString *)appName;


/**
 默认重试次数, optional, default to 1

 @param retryTimes ''
 */
+ (void)startWithRetryTimes:(NSUInteger)retryTimes;
+ (NSUInteger)retryTimes;

+ (void)setCompressLevel:(NSInteger)level;

+ (void)forceUseDirectUpload:(BOOL)force;
+ (BOOL)isForceUseDirect;

+ (void)partUploadImageSize:(long long)imageSize;
+ (void)partUploadVideoSize:(long long)videoSize;
+ (long long)sizeForPartUploadImage;
+ (long long)sizeForPartUploadVideo;


#pragma mark - File

+ (long long)fileSizeAtPath:(NSString *)filePath;


/// 根据处理情况，可能返还的是NSData和NSString
///
/// @param type 文件类型
/// @param filePath 文件路径
/// @param fileData 文件数据
/// @param image 图片解码后的数据
/// @param quality 保留的质量系数
/// @param error 错误
/// @param uploadId 唯一id
/// @param isParts 是否分片
+ (VDFileUploaderProcessDO *)processType:(VDUploadType)type
                                filePath:(NSString *)filePath
                                fileData:(NSData *)fileData
                                   image:(UIImage *)image
                                 quality:(CGFloat)quality
                                   error:(WDNErrorDO **)error
                                uploadId:(NSString *)uploadId
                                 isParts:(BOOL)isParts;

@end
