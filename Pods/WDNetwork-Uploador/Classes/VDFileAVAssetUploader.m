//
//  VDFileAVAssetUploader.m
//  WDNetwork-Uploador
//
//  Created by 杨鑫 on 2021/8/3.
//

#import "VDFileAVAssetUploader.h"
#import "VDFileUploader.h"
#import "VDFilePartsUploader.h"
#import "VDFileUploadQueue.h"

#import <VDCompress/AVAsset+VDCompress.h>

#import <WDNetwork-Base/WDNErrorDO.h>
#import <WDNetwork-Base/WDNDeviceInfoUtil.h>


@import AVFoundation;


@implementation VDFileAVAssetUploader

#pragma mark - AVAssetDelegate

static id<VDUploaderAVAssetProtocol> kIMDelegate;

+ (void)setIMAVAssetDelegate:(id<VDUploaderAVAssetProtocol>)imDelegate {
    kIMDelegate = imDelegate;
}

+ (BOOL)del_IMVideoPath:(NSString *)videoPath {
    if (videoPath.length == 0) {
        return NO;
    }
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSRange index = [videoPath rangeOfString:docPath];
    if (index.location != NSNotFound) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:videoPath]) {
            NSError *error;
            [fileManager removeItemAtPath:videoPath error:&error];
            if (error) {
                return NO;
            }
        }
    }
    
    return YES;
}

+ (void)UploadIMAVAssetBy:(NSString *)videoPath
                    scope:(NSString *)scope
                 progress:(void(^)(NSProgress *progress))progress
                 compress:(void(^)(NSString *exportPath))compress
                 complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (videoPath.length == 0) {
            !complete ?: complete(nil, [WDNErrorDO errorWithCode:WDNClientParamSerialError msg:@"文件路径为空"]);
            return;
        }
        
        if (kIMDelegate && [kIMDelegate respondsToSelector:@selector(UploadIMAVAssetBy:scope:progress:compress:complete:)]) {
            [kIMDelegate UploadIMAVAssetBy:videoPath
                                     scope:scope
                                  progress:progress
                                  compress:compress
                                  complete:^(VDUploadResultDO *result, WDNErrorDO *error) {
                [VDFileAVAssetUploader del_IMVideoPath:videoPath];
                
                if (result && !error) {
                    !complete ?: complete(result, nil);
                } else {
                    !complete ?: complete(nil, error);
                }
            }];
        } else {
            AVAsset *asset;
            if (videoPath.length > 0) {
                NSURL *assetURL = [NSURL fileURLWithPath:videoPath];
                if (assetURL) {
                    asset = [AVAsset assetWithURL:assetURL];
                }
            }
            
            if (asset) {
                [self UploadAVAsset:asset
                              scope:scope
                              param:nil
                           progress:progress
                           complete:^(VDUploadResultDO *result, WDNErrorDO *error) {
                    [VDFileAVAssetUploader del_IMVideoPath:videoPath];
                    
                    if (result && !error) {
                        !complete ?: complete(result, nil);
                    } else {
                        !complete ?: complete(nil, error);
                    }
                } sessionId:nil];
            } else {
                [VDFileUploader UploadFile:videoPath
                                     scope:scope
                                      type:VDUpload_VIDEO
                                   quality:0
                                       prv:NO
                                  unadjust:NO
                                  progress:progress
                                  complete:^(VDUploadResultDO *result, WDNErrorDO *error) {
                    [VDFileAVAssetUploader del_IMVideoPath:videoPath];
                    
                    if (result && !error) {
                        !complete ?: complete(result, nil);
                    } else {
                        !complete ?: complete(nil, error);
                    }
                }];
            }
        }
    });
}

+ (void)UploadAVAsset:(AVAsset *)asset
                scope:(NSString *)scope
                param:(NSDictionary *)param
             progress:(void(^)(NSProgress *progress))progress
             complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete
            sessionId:(NSString *)sessionId
{
    // 创建临时导出目录
    NSString *uploadId = [NSString stringWithFormat:@"%.0f", [NSDate.date timeIntervalSince1970] * 1000 * 1000];
    NSString *exportPath = [VDFileUploadQueue createTmpFilePath:uploadId];
    
    [AVAsset vd_exportTo:exportPath fromAsset:asset quality:0 progress:^(float progressValue) {
        NSProgress *aProgress = [NSProgress progressWithTotalUnitCount:100];
        aProgress.completedUnitCount = progressValue * 100 * 0.3;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !progress ?: progress(aProgress);
        });
    } complete:^(BOOL success, NSString *innerPath, NSString *message) {
        if (success) {
            [VDFilePartsUploader UploadVIDEO:innerPath
                                       scope:scope
                                       param:param
                                    progress:^(NSProgress *innerProgress) {
                NSProgress *aProgress = [NSProgress progressWithTotalUnitCount:100];
                aProgress.completedUnitCount = 30 + innerProgress.fractionCompleted * 70;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    !progress ?: progress(aProgress);
                });
            } complete:^(VDUploadResultDO *result, WDNErrorDO *error) {
                [VDFileUploadQueue removeTmpFile:innerPath];

                !complete ?: complete(result, error);
            } sessionId:sessionId];
        } else {
            /// 如果失败就原地址上传
            [VDFilePartsUploader UploadVIDEO:[AVAsset vd_mediaUrlFromAsset:asset]
                                       scope:scope
                                       param:param
                                    progress:^(NSProgress *innerProgress) {
                NSProgress *aProgress = [NSProgress progressWithTotalUnitCount:100];
                aProgress.completedUnitCount = 30 + innerProgress.fractionCompleted * 70;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    !progress ?: progress(aProgress);
                });
            } complete:^(VDUploadResultDO *result, WDNErrorDO *error) {
                !complete ?: complete(result, error);
            } sessionId:sessionId];
        }
    }];
}

@end
