//
//  VDFileDirectUploader.m
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/8/29.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDFileDirectUploader.h"
#import "VDFileUploador.h"
#import "VDDirectUploadMission.h"
#import "VDQueryVideoMission.h"
#import "VDFileUploadQueue.h"
#import "VDUploadResultDO.h"

#import <WDNetwork-Base/WDNetworkConstant.h>
#import <WDNetwork-Base/WDNErrorDO.h>


@interface VDFileDirectUploader ()

@property (nonatomic, strong) NSData    *fileData;
@property (nonatomic, copy  ) NSString  *filePath;
@property (nonatomic, strong) UIImage   *image;

@property (nonatomic, copy  ) NSDictionary *param;

@property (nonatomic, strong) VDDirectUploadMission *uploadMisson;

@end

@implementation VDFileDirectUploader

+ (id)UploadIMG:(id)img
          scope:(NSString *)scope
       progress:(void(^)(NSProgress *progress))progress
       complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete
{
    return [self UploadFile:img
                      scope:scope
                       type:VDUpload_IMG
                    quality:0
                        prv:NO
                   unadjust:NO
                   progress:progress
                   complete:complete];
}

+ (id)UploadVIDEO:(id)video
            scope:(NSString *)scope
         progress:(void(^)(NSProgress *progress))progress
         complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete
{
    return [self UploadFile:video
                      scope:scope
                       type:VDUpload_VIDEO
                    quality:0
                        prv:NO
                   unadjust:NO
                   progress:progress
                   complete:complete];
}

+ (id)UploadVIDEO:(id)video
            scope:(NSString *)scope
            param:(NSDictionary *)param
         progress:(void(^)(NSProgress *progress))progress
         complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete
        sessionId:(NSString *)sessionId
{
    VDFileDirectUploader *uploader = [VDFileDirectUploader new];
    uploader.sessionId = sessionId;
    uploader.scope = scope;
    uploader.quality = 0;
    uploader.prv = NO;
    uploader.unadjust = NO;
    uploader.type = VDUpload_VIDEO;
    if ([video isKindOfClass:[NSString class]]) {
        uploader.filePath = video;
    } else if ([video isKindOfClass:[NSData class]]) {
        uploader.fileData = video;
    } else if ([video isKindOfClass:[NSURL class]]) {
        uploader.filePath = [(NSURL *)video absoluteString];
    }
    
    uploader.param = param;
    uploader.progress = progress;
    uploader.complete = complete;
    
    //upload
    [uploader upload];
    
    return uploader;
}

+ (id)UploadFile:(id)data
           scope:(NSString *)scope
            type:(VDUploadType)type
         quality:(CGFloat)quality
             prv:(BOOL)prv
        unadjust:(BOOL)unadjust
        progress:(void(^)(NSProgress *progress))progress
        complete:(void(^)(VDUploadResultDO *response, WDNErrorDO *error))complete
{
    VDFileDirectUploader *uploader = [VDFileDirectUploader new];
    uploader.scope = scope;
    uploader.quality = quality;
    uploader.prv = prv;
    uploader.unadjust = unadjust;
    uploader.type = type;
    if ([data isKindOfClass:[NSString class]]) {
        uploader.filePath = data;
    } else if ([data isKindOfClass:[UIImage class]]) {
        uploader.image = data;
    } else if ([data isKindOfClass:[NSData class]]) {
        uploader.fileData = data;
    } else if ([data isKindOfClass:[NSURL class]]) {
        uploader.filePath = [(NSURL *)data absoluteString];
    }
    
    uploader.progress = progress;
    uploader.complete = complete;
    
    if (type == VDUpload_AUDIO) {
        if (unadjust) {
            uploader.quality = 1;
        } else {
            uploader.quality = 0;
        }
    }
    
    //upload
    [uploader upload];
    
    return uploader;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.uploadId = [NSString stringWithFormat:@"%.0f", [NSDate.date timeIntervalSince1970] * 1000 * 1000];
    }
    return self;
}

- (void)upload {
    [VDFileUploader holdUploader:self];
    
    WDNErrorDO *error = nil;
    VDFileUploaderProcessDO *processData = [VDFileUploador processType:self.type
                                                              filePath:self.filePath
                                                              fileData:self.fileData
                                                                 image:self.image
                                                               quality:self.quality
                                                                 error:&error
                                                              uploadId:self.uploadId
                                                               isParts:NO];
    
    VDDirectUploadMission *uploadMission = [VDDirectUploadMission new];
    uploadMission.sessionId = self.sessionId;
    uploadMission.uploadId  = self.uploadId;
    
    uploadMission.fileData = processData.fileData;
    uploadMission.filePath = processData.filePath;
    uploadMission.isOriginPath = processData.isOriginPath;
    
    // 埋点用
    uploadMission.originPath = self.filePath;
    uploadMission.utUploadFileSize = processData.fileSize;
    
    uploadMission.type      = self.type;
    uploadMission.prv       = self.prv;
    uploadMission.unadjust  = self.unadjust;
    uploadMission.scope     = self.scope;
    uploadMission.postParam = self.param;
    
    if (error) {
        [uploadMission sendUT:nil error:error];
        
        [VDFileUploadQueue removeFileByMission:uploadMission];
        
        [self complete:nil error:error];
    } else {
        self.uploadMisson = uploadMission;
        
        __weak typeof(self) weakSelf = self;
        [uploadMission setProgressBlock:^(NSProgress *progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.aProgress = progress;
                
                !weakSelf.progress ?: weakSelf.progress(progress);
            });
        }];
        [uploadMission setCompleteBlock:^(VDUploadResultDO *result, WDNErrorDO *error) {
            weakSelf.result = result;
            
            [weakSelf complete:result error:error];
        }];
        
        [VDFileUploadQueue addUploadMission:uploadMission];
    }
    
    self.image =  nil;
    self.fileData = nil;
}

- (void)cancel:(WDNErrorDO *)error {
    self.progress = nil;
    self.complete = nil;
    
    if (self.uploadMisson) {
        [self.uploadMisson cancel];
    }
    
    [VDFileUploader removeUploader:self];
}

- (void)complete:(VDUploadResultDO *)result error:(WDNErrorDO *)error {
    result.index = self.index;
    error.index = self.index;
    
    if (error) {
        result = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.complete ?: self.complete(result, error);
        
        self.progress = nil;
        self.complete = nil;
    });
    
    [VDFileUploader removeUploader:self];
}

@end
