//
//  VDFileUploader.m
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/9/7.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDFileUploader.h"
#import "VDFileUploador.h"
#import "VDQueryVideoMission.h"
#import "VDUploadResultDO.h"
#import "VDFileDirectUploader.h"
#import "VDFilePartsUploader.h"

#import <WDNetwork-Base/WDNetworkConstant.h>
#import <WDNetwork-Base/WDNDeviceInfoUtil.h>
#import <WDNetwork-Base/WDNErrorDO.h>


static NSMutableDictionary *kVDFileUploader_MAP = nil;

@interface VDFileUploader ()

@property (nonatomic, strong) NSData    *fileData;
@property (nonatomic, copy  ) NSString  *filePath;
@property (nonatomic, strong) UIImage   *image;

@property (nonatomic, assign) NSInteger partMaxSize;

@property (nonatomic, strong) VDQueryVideoMission *queryMission;

@end

@implementation VDFileUploader

+ (void)holdUploader:(VDFileUploader *)uploader {
    @synchronized ([VDFileUploader class]) {
        if (!kVDFileUploader_MAP) {
            kVDFileUploader_MAP = [NSMutableDictionary dictionary];
        }
        
        if (uploader.uploadId.length) {
            kVDFileUploader_MAP[uploader.uploadId] = uploader;
        }
    }
}

+ (void)removeUploader:(VDFileUploader *)uploader {
    @synchronized ([VDFileUploader class]) {
        if (!kVDFileUploader_MAP) {
            return;
        }
        
        if (uploader.uploadId.length) {
            kVDFileUploader_MAP[uploader.uploadId] = nil;
        }
    }
}

+ (void)cancelAllUploader:(WDNErrorDO *)error {
    @synchronized ([VDFileUploader class]) {
        if (!kVDFileUploader_MAP) {
            return;
        }
        
        [kVDFileUploader_MAP enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            VDFileUploader *uploader = obj;
            [uploader cancel:error];
            
//            修改循环调用造成的crash
//            https://bugly.qq.com/v2/crash-reporting/crashes/900015401/347200/report?pid=2&crashDataType=unSystemExit
//            if (uploader.complete) {
//                uploader.complete(nil, error);
//                uploader.complete = nil;
//            }
//            [uploader.queryMission cancel];
            
        }];
        
        [kVDFileUploader_MAP removeAllObjects];
    }
}

+ (id)UploadFile:(id)data
           scope:(NSString *)scope
            type:(VDUploadType)type
         quality:(CGFloat)quality
             prv:(BOOL)prv
        unadjust:(BOOL)unadjust
        progress:(void(^)(NSProgress *progress))progress
        complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete
{
    long long partMaxSize = 0;
    if ((type == VDUpload_VIDEO && [VDFileUploador sizeForPartUploadVideo] > 0) ||
        (type != VDUpload_VIDEO && [VDFileUploador sizeForPartUploadImage] > 0)) {
        partMaxSize = (type == VDUpload_VIDEO ? [VDFileUploador sizeForPartUploadVideo] : [VDFileUploador sizeForPartUploadImage]);
    } else {
        switch ([WDNDeviceInfoUtil shareUtil].currentNetStatus) {
            case WDNStatusWIFI: {
                partMaxSize = (type == VDUpload_VIDEO ? kVideoWIFIPartSize : kImgWIFIPartSize);
            } break;
            case WDNStatus4G: {
                partMaxSize = (type == VDUpload_VIDEO ? kVideo4GPartSize : kImg4GPartSize);
            } break;
            case WDNStatus3G: {
                partMaxSize = (type == VDUpload_VIDEO ? kVideo3GPartSize : kImg3GPartSize);
            } break;
            default: {
                partMaxSize = (type == VDUpload_VIDEO ? kVideo3GPartSize : kImg2GPartSize);
            } break;
        }
        
        partMaxSize *= 2;
    }
    
    long long fileSize = 0;
    if ([data isKindOfClass:[NSString class]]) {
        NSString *filePath = data;
        
        fileSize = [VDFileUploador fileSizeAtPath:filePath];
    } else if ([data isKindOfClass:[NSURL class]]) {
        NSString *filePath = [(NSURL *)data absoluteString];
        
        fileSize = [VDFileUploador fileSizeAtPath:filePath];
    } else if ([data isKindOfClass:[UIImage class]]) {
        fileSize = 0;
    } else if ([data isKindOfClass:[NSData class]]) {
        NSData *fileData = data;
        
        fileSize = fileData.length;
    }
    
    if (fileSize <= partMaxSize || type == VDUpload_DOC) {
        return [VDFileDirectUploader UploadFile:data
                                          scope:scope
                                           type:type
                                        quality:quality
                                            prv:prv
                                       unadjust:unadjust
                                       progress:progress
                                       complete:complete];
    } else {
        return [VDFilePartsUploader UploadFile:data
                                         scope:scope
                                          type:type
                                       quality:quality
                                           prv:prv
                                      unadjust:unadjust
                                      progress:progress
                                      complete:complete];
    }
}

+ (instancetype)QueryVideo:(NSString *)videoId
                     scope:(NSString *)scope
                  callback:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))callback
{
    VDFileUploader *uploader = [VDFileUploader new];
    uploader.scope = scope;
    uploader.complete = callback;
    
    VDUploadResultDO *param = [VDUploadResultDO new];
    param.videoId = videoId;
    uploader.result = param;
    
    [uploader queryVideo];
    
    return uploader;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.uploadId = [NSString stringWithFormat:@"%.0f", [NSDate.date timeIntervalSince1970] * 1000 * 1000];
    }
    return self;
}

- (void)queryVideo {
    [VDFileUploader holdUploader:self];
    
    if (self.result.videoId.length == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.complete) {
                self.complete(nil, [WDNErrorDO errorWithCode:WDNClientParamError
                                                         msg:@"id为空"]);
                
                self.complete = nil;
            }
        });
        
        return;
    }
    
    VDQueryVideoMission *queryMission = [VDQueryVideoMission new];
    self.queryMission = queryMission;
    
    queryMission.scope = self.scope;
    queryMission.videoId = self.result.videoId;
    
    __weak typeof(self) weakSelf = self;
    [queryMission setCompleteBlock:^(VDUploadResultDO *result, WDNErrorDO *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.complete) {
                weakSelf.complete(result, error);
                
                weakSelf.complete = nil;
            }
        });
        
        [VDFileUploader removeUploader:weakSelf];
    }];
    
    [queryMission query];
}

- (void)cancel {
    [self cancel:[WDNErrorDO errorWithCode:WDNetworkCancel msg:@""]];
}

- (void)cancel:(WDNErrorDO *)error {
    if (self.complete) {
        self.complete(nil, error);
        self.complete = nil;
    }
    
    [self.queryMission cancel];
    
    [VDFileUploader removeUploader:self];
}

@end
