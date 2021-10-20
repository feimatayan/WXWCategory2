//
//  AVAsset+VDCompress.h
//  VDCompress
//
//  Created by 杨鑫 on 2021/8/13.
//  Copyright © 2021 yangxin02. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>


/// 视频压缩
@interface AVAsset (VDCompress)

+ (void)vdIM_exportTo:(NSString *)exportPath
            fromAsset:(AVAsset *)asset
             complete:(void(^)(BOOL success, NSString *innerPath, NSString *message))complete;

/// 压缩视频
/// exportPath请使用[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]目录
/// asset可以是相册地址和NSDocumentDirectory地址
///
/// 如果不传exportPath参数，会创建前缀compress_同目录文件
/// 如果asset是系统相册地址，必须传exportPath
///
/// exportPath是参数，最后地址以complete的innerPath为准
///
/// @param exportPath 导出的地址，可以为空
/// @param asset 可以相册的地址，也可以是自己拷贝的，最好用自己拷贝的
/// @param quality 1的话，如果asset有地址直接返回地址，否者用最高质量导出
/// @param progress 压缩进度
/// @param complete 回调
+ (void)vd_exportTo:(NSString *)exportPath
          fromAsset:(AVAsset *)asset
            quality:(CGFloat)quality
           progress:(void(^)(float progress))progress
           complete:(void(^)(BOOL success, NSString *innerPath, NSString *message))complete;


+ (BOOL)vd_deleteAtPath:(NSString *)path;

/// 拷贝文件，先删除toPath，再拷贝，拷贝成功会删除fromPath
/// 0, 拷贝成功
/// 1, 拷贝失败，没有变化
/// 2, 拷贝失败，toPath被删除
/// 3, 拷贝成功，fromPath没有删除，fromPath和toPath是同一文件
/// @param fromPath 待拷贝文件
/// @param toPath   目录
/// @param needClear 是否清理，删除原视频
+ (NSUInteger)vd_copyFromPath:(NSString *)fromPath toPath:(NSString *)toPath needClear:(BOOL)needClear;

+ (BOOL)vd_compareLeftFilePath:(NSString *)leftPath rightFilePath:(NSString *)rightPath;


+ (AVAssetTrack *)vd_assetTrackFromAsset:(AVAsset *)asset;

+ (NSString *)vd_mediaUrlFromAsset:(AVAsset *)asset;

/// iPhone12 的 蓝屏
/// @param asset AVAsset
+ (BOOL)vd_shouldExportVideo:(AVAsset *)asset;

@end
