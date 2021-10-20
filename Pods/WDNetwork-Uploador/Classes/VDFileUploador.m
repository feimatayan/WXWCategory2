//
//  VDFileUploador.m
//  WDNetworkingDemo
//
//  Created by yangxin02 on 2018/8/28.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDFileUploador.h"
#import "VDFileUploadConstant.h"
#import "VDFileUploadQueue.h"
#import "VDUploadLibsConfig.h"

#import "UIImage+VDUpload.h"

#import <WDNetwork-Base/WDNErrorDO.h>
#import <WDNetwork-Base/WDNetworkMacro.h>
#import <VDCompress/VDCompress.h>
#import <VDCompress/UIImage+VDCompress.h>
#import <VDCompress/UIImage+VDCFormat.h>
#import <VDCompress/NSData+VDCFormat.h>


static WDNetworkEnvType kEnvType = WDN_Env_Release;
static NSString *kHost = WDN_Media_ReleaseHost;
static NSString *kUA = @"";
static NSUInteger kDefaultRetryTimes = 3;
static BOOL kForceDirect = NO;
static NSInteger kCompressLevel = VDCompressLevel_Original;
static long long kForcePartUploadImageSize = 0;
static long long kForcePartUploadVideoSize = 0;

@implementation VDFileUploador

#pragma mark - Getter

+ (NSString *)host {
    return kHost;
}

+ (NSString *)UA {
    return kUA;
}

+ (NSUInteger)retryTimes {
    return kDefaultRetryTimes;
}

+ (BOOL)isForceUseDirect {
    return kForceDirect;
}

+ (long long)sizeForPartUploadImage {
    return kForcePartUploadImageSize;
}

+ (long long)sizeForPartUploadVideo {
    return kForcePartUploadVideoSize;
}

#pragma mark - Setter

+ (void)startWithRetryTimes:(NSUInteger)retryTimes {
    kDefaultRetryTimes = retryTimes;
}

+ (void)forceUseDirectUpload:(BOOL)force {
    kForceDirect = force;
}

+ (void)setCompressLevel:(NSInteger)level {
    kCompressLevel = level;
}

+ (void)partUploadImageSize:(long long)imageSize {
    kForcePartUploadImageSize = imageSize;
}

+ (void)partUploadVideoSize:(long long)videoSize {
    kForcePartUploadVideoSize = videoSize;
}

#pragma mark - Init

+ (void)startWithEnv:(WDNetworkEnvType)env appName:(NSString *)appName {
    kEnvType = env;
    
    kUA = [NSString stringWithFormat:@"iOS/%@ WDAPP(%@/%@) WDUpload/%@",
           [[UIDevice currentDevice] systemVersion],
           appName,
           [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"],
           VDUploadVersion];
    
    switch (env) {
        case WDN_Env_Daily:         kHost = WDN_Media_DailyHost; break;
        case WDN_Env_PreRelease:    kHost = WDN_Media_PreHost; break;
        default:                    kHost = WDN_Media_ReleaseHost; break;
    }
    
    [VDUploadLibsConfig sharedInstance];
}

#pragma mark - File

+ (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

+ (NSString *)fileTypeName:(VDUploadType)fileType {
    switch (fileType) {
        case VDUpload_IMG:return @"图片";
        case VDUpload_VIDEO:return @"视频";
        case VDUpload_AUDIO:return @"音频";
        default:return @"文件";
    }
}

+ (VDFileUploaderProcessDO *)processType:(VDUploadType)type
                                filePath:(NSString *)filePath
                                fileData:(NSData *)fileData
                                   image:(UIImage *)image
                                 quality:(CGFloat)quality
                                   error:(WDNErrorDO **)error
                                uploadId:(NSString *)uploadId
                                 isParts:(BOOL)isParts
{
    if (type == VDUpload_IMG) {
        if (image) {
            // 返回NSData对象
            return [self processImage:image quality:quality error:error uploadId:uploadId];
        } else if (fileData && fileData.length > 0) {
            // 返回NSData对象
            return [self processImageData:fileData quality:quality error:error uploadId:uploadId];
        } else if (filePath.length > 0) {
            // 返回NSData对象 或者 文件path
            return [self processImagePath:filePath quality:quality error:error uploadId:uploadId];
        }
        
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"上传的图片不存在"];
    } else if (type == VDUpload_AUDIO) {
        if (fileData && fileData.length > 0) {
            // 返回NSData对象
            return [self processAudioData:fileData quality:quality error:error uploadId:uploadId];
        } else if (filePath.length > 0) {
            // 返回文件path
            return [self processAudioPath:filePath quality:quality error:error uploadId:uploadId];
        }
        
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"上传的音频不存在"];
    } else {
        if (fileData && fileData.length > 0) {
            // 返回NSData对象
            return [self processFileData:fileData type:type error:error uploadId:uploadId isParts:isParts];
        } else if (filePath.length > 0) {
            // 返回文件path
            return [self processFilePath:filePath type:type error:error uploadId:uploadId isParts:isParts];
        }
        
        NSString *msg = [NSString stringWithFormat:@"上传的%@不存在", [self fileTypeName:type]];
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:msg];
    }
    
    return nil;
}

#pragma mark - 图片处理

+ (BOOL)unSuportFormat:(VDCompressImageType)imageType {
    return imageType == VDCompress_Img_UNKNOW ||
    imageType == VDCompress_Img_Default ||
    imageType == VDCompress_Img_PDF ||
    imageType == VDCompress_Img_SVG;
}

/// image，代表图片是解压之后，
/// 动图或者原图，会保留原有图片编码格式
/// quality小于1，默认都会去压缩，图片格式会变成PNG或者Jpeg
/// @param image UIImage
/// @param quality 图片质量，1是原图
/// @param error 错误
/// @param uploadId 唯一id
+ (VDFileUploaderProcessDO *)processImage:(UIImage *)image
                                  quality:(CGFloat)quality
                                    error:(WDNErrorDO **)error
                                 uploadId:(NSString *)uploadId
{
    /// 最大压缩限制，不经过压缩是24m，经过压缩6m
    long long maxSize = kImageMaxSize;
    
    NSData *imageData;
    
    // 读取图片类型
    VDCompressImageType imgType = [image vd_imageFormat];
    
    /// 第一步，如果是动态图片或者是原图，或者是无法识别的格式
    if (image.images || quality >= 1 || [self unSuportFormat:imgType]) {
        maxSize = kOriginImageMaxSize;
        
        imageData = VDUIImageDefaultRepresentation(image);
        
        if (!imageData || imageData.length == 0) {
            *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"UIImage无法编码"];
            return nil;
        }
    } else {
        quality = (quality <= 1 && quality > 0) ? quality : kDefaultQuality;
        
        /// 压缩方法，透明通道需要注意，经过压缩之后的会变成JPEG或者PNG
        imageData = [image vd_compressWithLevel:kCompressLevel quality:quality maxFileSize:kImageMaxSize];
    }
    
    // 用临时文件的方式读取准确的文件大小
    long long imageSize = 0;
    NSString *tmpPath = [VDFileUploadQueue saveTmpFileData:imageData uploadId:uploadId];
    if (tmpPath.length > 0) {
        imageSize = [VDFileUploador fileSizeAtPath:tmpPath];
        
        [VDFileUploadQueue removeTmpFile:tmpPath];
    }
    
    if (imageSize == 0) {
        imageSize = imageData.length;
    }
    
    if (imageSize > maxSize) {
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"上传的图片太大，超过了指定大小"];
        /// 错误也返回，埋点使用
        return [VDFileUploaderProcessDO createWithData:nil size:imageSize];
    }
    
    return [VDFileUploaderProcessDO createWithData:imageData size:imageSize];
}


/// imageData是编码后的图片
/// @param imageData NSData
/// @param quality 图片质量，1是原图
/// @param error 错误
/// @param uploadId 唯一id
+ (VDFileUploaderProcessDO *)processImageData:(NSData *)imageData
                                      quality:(CGFloat)quality
                                        error:(WDNErrorDO **)error
                                     uploadId:(NSString *)uploadId
{
    /// 最大压缩限制，不经过压缩是24m，经过压缩6m
    long long maxSize = kImageMaxSize;
    
    // 读取图片类型
    VDCompressImageType imgType = [NSData vd_imageFormatForImageData:imageData];
    if (imgType == VDCompress_Img_GIF || quality >= 1 || [self unSuportFormat:imgType]) {
        maxSize = kOriginImageMaxSize;
    } else {
        UIImage *image = [UIImage vd_imageWithData:imageData];
        // 动图或者是无法解码，直接上传，不压缩
        if (image.images || (!image || !image.CGImage)) {
            maxSize = kOriginImageMaxSize;
        } else {
            quality = (quality <= 1 && quality > 0) ? quality : kDefaultQuality;
            
            imageData = [image vd_compressWithLevel:kCompressLevel quality:quality maxFileSize:kImageMaxSize];
        }
    }
    
    // 用临时文件的方式读取准确的文件大小
    long long imageSize = 0;
    NSString *tmpPath = [VDFileUploadQueue saveTmpFileData:imageData uploadId:uploadId];
    if (tmpPath.length > 0) {
        imageSize = [VDFileUploador fileSizeAtPath:tmpPath];
        
        [VDFileUploadQueue removeTmpFile:tmpPath];
    }
    
    if (imageSize == 0) {
        imageSize = imageData.length;
    }
    
    if (imageSize > maxSize) {
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"上传的图片太大，超过了指定大小"];
        /// 错误也返回，埋点使用
        return [VDFileUploaderProcessDO createWithData:nil size:imageSize];
    }
    
    return [VDFileUploaderProcessDO createWithData:imageData size:imageSize];
}


/// 参数是图片路径
/// @param imagePath 图片路径
/// @param quality 压缩系数
/// @param error 错误
/// @param uploadId 唯一id
+ (VDFileUploaderProcessDO *)processImagePath:(NSString *)imagePath
                                      quality:(CGFloat)quality
                                        error:(WDNErrorDO **)error
                                     uploadId:(NSString *)uploadId
{
    long long imageSize = [VDFileUploador fileSizeAtPath:imagePath];
    if (imageSize == 0) {
        // 文件大小读取为0，但是NSData不是空
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        if (imageData && imageData.length > 0) {
            return [self processImageData:imageData quality:quality error:error uploadId:uploadId];
        }
        
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"上传的图片不存在"];
        /// 错误也返回，埋点使用
        return [VDFileUploaderProcessDO createWithPath:imagePath isOrigin:YES size:0];
    }
    
    /// 原图上传，直接不用读取文件
    if (quality >= 1) {
        if (imageSize > kOriginImageMaxSize) {
            *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"上传的图片太大，超过了指定大小"];
            /// 错误也返回，埋点使用
            return [VDFileUploaderProcessDO createWithData:nil size:imageSize];
        }
        
        return [VDFileUploaderProcessDO createWithPath:imagePath isOrigin:YES size:imageSize];
    } else {
        // 不知道能不能用UIImage读取，这里读取NSData安全一点
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        if (!imageData || imageData.length == 0) {
            *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"上传的图片不存在"];
            /// 错误也返回，埋点使用
            return [VDFileUploaderProcessDO createWithPath:imagePath isOrigin:YES size:0];
        }
        
        return [self processImageData:imageData quality:quality error:error uploadId:uploadId];
    }
}

#pragma mark - 音频处理

+ (VDFileUploaderProcessDO *)processAudioData:(NSData *)audioData
                                      quality:(CGFloat)quality
                                        error:(WDNErrorDO **)error
                                     uploadId:(NSString *)uploadId
{
    long long audioSize = 0;
    NSString *tmpPath = [VDFileUploadQueue saveTmpFileData:audioData uploadId:uploadId];
    if (tmpPath.length > 0) {
        audioSize = [VDFileUploador fileSizeAtPath:tmpPath];
        
        if (audioSize == 0) {
            [VDFileUploadQueue removeTmpFile:tmpPath];
            
            audioSize = audioData.length;
            tmpPath = nil;
        }
    } else {
        audioSize = audioData.length;
    }
    
    if (audioSize > (quality >= 1 ? kVideoMaxSize : kOriginImageMaxSize)) {
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"上传的音频太大，超过了指定大小"];
        /// 错误也返回，埋点使用
        return [VDFileUploaderProcessDO createWithData:nil size:audioSize];
    }
    
    if (tmpPath.length > 0) {
        return [VDFileUploaderProcessDO createWithPath:tmpPath isOrigin:NO size:audioSize];
    }
    
    return [VDFileUploaderProcessDO createWithData:audioData size:audioSize];
}

+ (VDFileUploaderProcessDO *)processAudioPath:(NSString *)audioPath
                                      quality:(CGFloat)quality
                                        error:(WDNErrorDO **)error
                                     uploadId:(NSString *)uploadId
{
    long long audioSize = [VDFileUploador fileSizeAtPath:audioPath];
    if (audioSize == 0) {
        NSData *audioData = [NSData dataWithContentsOfFile:audioPath];
        if (audioData && audioData.length > 0) {
            return [self processAudioData:audioData quality:quality error:error uploadId:uploadId];
        }
        
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"上传的音频不存在"];
        /// 错误也返回，埋点使用
        return [VDFileUploaderProcessDO createWithPath:audioPath isOrigin:YES size:0];
    }
    
    if (audioSize > (quality >= 1 ? kVideoMaxSize : kOriginImageMaxSize)) {
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"上传的音频太大，超过了指定大小"];
        /// 错误也返回，埋点使用
        return [VDFileUploaderProcessDO createWithData:nil size:audioSize];
    }
    
    return [VDFileUploaderProcessDO createWithPath:audioPath isOrigin:YES size:audioSize];
}

#pragma mark - 视频处理

+ (VDFileUploaderProcessDO *)processFileData:(NSData *)fileData
                                        type:(VDUploadType)type
                                       error:(WDNErrorDO **)error
                                    uploadId:(NSString *)uploadId
                                     isParts:(BOOL)isParts
{
    long long fileSize = fileData.length;
    NSString *tmpPath = [VDFileUploadQueue saveTmpFileData:fileData uploadId:uploadId];
    if (tmpPath.length > 0) {
        fileSize = [VDFileUploador fileSizeAtPath:tmpPath];
        
        if (fileSize == 0) {
            [VDFileUploadQueue removeTmpFile:tmpPath];
            
            fileSize = fileData.length;
            tmpPath = nil;
        }
    } else {
        fileSize = fileData.length;
    }
    
    if (fileSize > (type == VDUpload_VIDEO ? (isParts ? kLongVideoMaxSize : kVideoMaxSize) : kUploadFileMaxSize)) {
        NSString *msg = [NSString stringWithFormat:@"上传的%@太大，超过了指定大小", [self fileTypeName:type]];
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:msg];
        /// 错误也返回，埋点使用
        return [VDFileUploaderProcessDO createWithData:nil size:fileSize];
    }
    
    if (tmpPath.length > 0) {
        return [VDFileUploaderProcessDO createWithPath:tmpPath isOrigin:NO size:fileSize];
    }
    
    return [VDFileUploaderProcessDO createWithData:fileData size:fileSize];
}

+ (VDFileUploaderProcessDO *)processFilePath:(NSString *)filePath
                                        type:(VDUploadType)type
                                       error:(WDNErrorDO **)error
                                    uploadId:(NSString *)uploadId
                                     isParts:(BOOL)isParts
{
    long long fileSize = [VDFileUploador fileSizeAtPath:filePath];
    if (fileSize == 0) {
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        if (fileData && fileData.length > 0) {
            return [self processFileData:fileData type:type error:error uploadId:uploadId isParts:isParts];
        }
        
        NSString *msg = [NSString stringWithFormat:@"上传的%@不存在", [self fileTypeName:type]];
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:msg];
        /// 错误也返回，埋点使用
        return [VDFileUploaderProcessDO createWithPath:filePath isOrigin:YES size:0];
    }
    
    if (fileSize > (type == VDUpload_VIDEO ? (isParts ? kLongVideoMaxSize : kVideoMaxSize) : kUploadFileMaxSize)) {
        NSString *msg = [NSString stringWithFormat:@"上传的%@太大，超过了指定大小", [self fileTypeName:type]];
        *error = [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:msg];
        /// 错误也返回，埋点使用
        return [VDFileUploaderProcessDO createWithData:nil size:fileSize];
    }
    
    return [VDFileUploaderProcessDO createWithPath:filePath isOrigin:YES size:fileSize];
}

@end
