//
//  AVAsset+VDCompress.m
//  VDCompress
//
//  Created by 杨鑫 on 2021/8/13.
//  Copyright © 2021 yangxin02. All rights reserved.
//

#import "AVAsset+VDCompress.h"

#include <sys/sysctl.h>

@implementation AVAsset (VDCompress)

+ (void)vdIM_exportTo:(NSString *)exportPath
            fromAsset:(AVAsset *)asset
             complete:(void(^)(BOOL success, NSString *innerPath, NSString *message))complete
{
    if (!complete) {
        return;
    }
    
    NSString *mediaPath = [AVAsset vd_mediaUrlFromAsset:asset];
    if (mediaPath.length == 0) {
        complete(NO, nil, @"asset参数为空!");
        return;
    }
    
    // 如果导出地址和原地址相同，就是覆盖原地址
    if ([mediaPath isEqual:exportPath]) {
        exportPath = nil;
    }
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    BOOL mediaIsInDoc = NO;
    NSRange index = [mediaPath rangeOfString:docPath];
    if (index.location != NSNotFound) {
        mediaIsInDoc = YES;
    }
    
    // 导出后是否覆盖原视频地址
    BOOL needCopy = NO;
    
    if (exportPath.length == 0) {
        // 判断一下是否是NSDocumentDirectory地址，如果不是，无法知道导出到哪里
        // /var/mobile/Media/DCIM/100APPLE/IMG_0038.MP4
        // /var/mobile/Containers/Data/Application/1EE4315D-5A16-43AE-A4FB-9F47A0A25F9C/Documents/wdb_picker_local_video/550-20210803210329.mp4
        if (!mediaIsInDoc) {
            complete(NO, nil, @"exportPath参数为空!");
            return;
        }
        
        // 导出后覆盖原视频地址
        needCopy = YES;
        
        // 在mediaPath的同文件夹下，临时导出视频，在覆盖回去
        NSArray<NSString *> *pathComponents = mediaPath.pathComponents;
        NSString *mediaName = pathComponents.lastObject;
        NSString *cMediaName = [@"compress_" stringByAppendingString:mediaName];
        
        NSMutableArray<NSString *> *newPathComponents = pathComponents.mutableCopy;
        [newPathComponents removeLastObject];
        [newPathComponents addObject:cMediaName];
        
        exportPath = [NSString pathWithComponents:newPathComponents.copy];
    }
    
    [AVAsset vd_exportTo:exportPath fromAsset:asset quality:0 progress:nil complete:^(BOOL success, NSString *innerPath, NSString *message) {
        if (success) {
            if (needCopy) {
                // 压缩后的视频覆盖到原视频
                NSUInteger copyStatus = [AVAsset vd_copyFromPath:innerPath toPath:mediaPath needClear:YES];
                if (copyStatus == 0) {
                    // 覆盖成功
                    complete(YES, mediaPath, nil);
                } else if (copyStatus == 1) {
                    // 覆盖失败，innerPath和mediaPath都还存在
                    [AVAsset vd_deleteAtPath:mediaPath];
                    
                    complete(YES, innerPath, nil);
                } else if (copyStatus == 2) {
                    // 覆盖失败，innerPath存在，mediaPath不存在了
                    complete(YES, innerPath, nil);
                } else {
                    // 3
                    // 覆盖成功, innerPath删除失败
                    [AVAsset vd_deleteAtPath:innerPath];
                    
                    complete(YES, mediaPath, nil);
                }
            } else {
                // 删除原视频
                if (mediaIsInDoc) {
                    [AVAsset vd_deleteAtPath:mediaPath];
                }
                
                complete(YES, innerPath, nil);
            }
        } else {
            complete(NO, nil, message);
        }
    }];
}

+ (void)vd_exportTo:(NSString *)exportPath
          fromAsset:(AVAsset *)asset
            quality:(CGFloat)quality
           progress:(void(^)(float progress))progress
           complete:(void(^)(BOOL success, NSString *innerPath, NSString *message))complete
{
    if (!complete) {
        return;
    }
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    if (exportPath.length == 0) {
        complete(NO, nil, @"exportPath参数为空!");
        return;
    }
    
    NSRange index = [exportPath rangeOfString:docPath];
    if (index.location == NSNotFound) {
        complete(NO, nil, @"请导出到Documents目录!");
        return;
    }
    
    NSString *mediaPath = [AVAsset vd_mediaUrlFromAsset:asset];
    if (mediaPath.length == 0) {
        complete(NO, nil, @"asset参数为空!");
        return;
    }
    
    if ([mediaPath isEqual:exportPath]) {
        complete(NO, nil, @"不能导出到原地址!");
        return;
    }
    
    if ([AVAsset vd_shouldExportVideo:asset]) {
        NSString *presetName = AVAssetExportPresetMediumQuality;
        // 压缩视频
        AVAssetTrack *videoTrack = [AVAsset vd_assetTrackFromAsset:asset];
        if (videoTrack) {
            // 分辨率
            CGSize size = videoTrack.naturalSize;
            CGFloat minP = MIN(size.width, size.height);
            
            if (minP > 1078) {
                presetName = AVAssetExportPreset1280x720;
            }
        }
        
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:presetName];
        if (!session) {
            complete(NO, nil, @"session创建失败！");
            return;
        }
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if (![supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            complete(NO, nil, @"不支持MPEG4");
            return;
        }
        
        // 开始导出前，删除exportPath，不然会导出失败
        [AVAsset vd_deleteAtPath:exportPath];
        
        session.outputURL = [NSURL fileURLWithPath:exportPath];
        session.shouldOptimizeForNetworkUse = YES;
        session.outputFileType = AVFileTypeMPEG4;
        
        __block NSTimer *timer;
        dispatch_async(dispatch_get_main_queue(), ^{
            timer = [NSTimer scheduledTimerWithTimeInterval:0.18 repeats:YES block:^(NSTimer *timer) {
                !progress ?: progress(session.progress);
            }];
        });
        [session exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (session.status == AVAssetExportSessionStatusWaiting || session.status == AVAssetExportSessionStatusExporting) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !progress ?: progress(session.progress);
                    });
                } else if (session.status == AVAssetExportSessionStatusCompleted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (timer.isValid) {
                            [timer invalidate];
                        }
                    });
                    
                    // 比较导出后的文件大小
                    if ([AVAsset vd_compareLeftFilePath:mediaPath rightFilePath:exportPath]) {
                        // 导出的视频小
                        complete(YES, exportPath, nil);
                    } else {
                        // 原视频更小
                        NSUInteger copyStatus = [AVAsset vd_copyFromPath:mediaPath toPath:exportPath needClear:NO];
                        if (copyStatus == 0 || copyStatus == 3) {
                            complete(YES, exportPath, nil);
                        } else {
                            // 用原视频
                            [AVAsset vd_deleteAtPath:exportPath];
                            
                            complete(NO, nil, @"视频导出失败");
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (timer.isValid) {
                            [timer invalidate];
                        }
                    });
                    
                    complete(NO, nil, @"视频导出失败！");
                }
            });
        }];
    } else {
        /// 可以在导出时候设置矫正方向，就可以导出
        
        NSUInteger copyStatus = [AVAsset vd_copyFromPath:mediaPath toPath:exportPath needClear:NO];
        if (copyStatus == 0 || copyStatus == 3) {
            complete(YES, exportPath, nil);
        } else {
            complete(NO, nil, @"视频导出失败！");
        }
    }
}

#pragma mark - Tools

+ (BOOL)vd_deleteAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error;
        [fileManager removeItemAtPath:path error:&error];
        if (error) {
            return NO;
        }
    }
    
    return YES;
}

+ (NSUInteger)vd_copyFromPath:(NSString *)fromPath toPath:(NSString *)toPath needClear:(BOOL)needClear {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:toPath]) {
        NSError *error;
        [fileManager removeItemAtPath:toPath error:&error];
        if (error) {
            return 1;
        }
    }
    
    NSError *error;
    [fileManager copyItemAtURL:[NSURL fileURLWithPath:fromPath] toURL:[NSURL fileURLWithPath:toPath] error:&error];
    if (error) {
        return 2;
    }
    
    if (needClear && [fileManager fileExistsAtPath:fromPath]) {
        NSError *error;
        [fileManager removeItemAtPath:fromPath error:&error];
        if (error) {
            return 3;
        }
    }
    
    return 0;
}

+ (BOOL)vd_compareLeftFilePath:(NSString *)leftPath rightFilePath:(NSString *)rightPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    unsigned long long lSize = 0;
    if ([fileManager fileExistsAtPath:leftPath]) {
        lSize = [[fileManager attributesOfItemAtPath:leftPath error:nil] fileSize];
    }
    
    unsigned long long rSize = 0;
    if ([fileManager fileExistsAtPath:rightPath]) {
        rSize = [[fileManager attributesOfItemAtPath:rightPath error:nil] fileSize];
    }
    
    if (lSize <= 0 || rSize <= 0) {
        return YES;
    }
    
    return lSize > rSize;
}

+ (AVAssetTrack *)vd_assetTrackFromAsset:(AVAsset *)asset {
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if ([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        return videoTrack;
    }
    
    return nil;
}

+ (NSString *)vd_mediaUrlFromAsset:(AVAsset *)asset {
    NSURL *mediaUrl;
    if([asset isKindOfClass:[AVURLAsset class]]) {
        AVURLAsset *avurlAsset = (AVURLAsset *) asset;
        mediaUrl = avurlAsset.URL;
    } else if ([asset isKindOfClass:[AVComposition class]]) {
        __block NSURL *videoTrackURL = nil;
        AVComposition *composition = (AVComposition * )asset;
        [composition.tracks enumerateObjectsUsingBlock:^(AVCompositionTrack *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.mediaType isEqualToString:AVMediaTypeVideo]) {
                [obj.segments enumerateObjectsUsingBlock:^(AVCompositionTrackSegment *obj, NSUInteger idx, BOOL *stop) {
                    videoTrackURL = obj.sourceURL;
                    *stop = YES;
                }];
            }
        }];
        mediaUrl = videoTrackURL;
    }
    
    if (!mediaUrl) {
        return @"";
    }
    
    return [mediaUrl path];
}

+ (BOOL)vd_shouldExportVideo:(AVAsset *)asset {
    /**
     @"iPhone13,1" : @"iPhone 12 mini",
     @"iPhone13,2" : @"iPhone 12",
     @"iPhone13,3" : @"iPhone 12 Pro",
     @"iPhone13,4" : @"iPhone 12 Pro Max",
     */
    NSString *deviceName = @"unknow";
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    if (size > 0 ) {
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        deviceName = [NSString stringWithUTF8String:machine];
        free(machine);
    }
    
    NSArray *iPhone12 = @[@"iPhone13,1", @"iPhone13,2", @"iPhone13,3", @"iPhone13,4"];
    if (![iPhone12 containsObject:deviceName]) {
        return YES;
    }
    
    int degress = 0;
    AVAssetTrack *videoTrack = [AVAsset vd_assetTrackFromAsset:asset];
    if (videoTrack) {
        CGAffineTransform t = videoTrack.preferredTransform;
        if (t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) {
            // Portrait
            degress = 90;
        } else if (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0) {
            // PortraitUpsideDown
            degress = 270;
        } else if (t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0) {
            // LandscapeRight
            degress = 0;
        } else if (t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0) {
            // LandscapeLeft
            degress = 180;
        }
    }
    
    if (degress != 0) {
        return YES;
    }
    
    return NO;
}

@end
