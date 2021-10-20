//
//  VDFilePartsUploader.m
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/9/3.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDFilePartsUploader.h"
#import "VDInitUploadMisson.h"
#import "VDPartUploadMission.h"
#import "VDPartUploadFinishMission.h"
#import "VDQueryVideoMission.h"
#import "VDFileUploador.h"
#import "VDUploadResultDO.h"
#import "VDFileUploadConstant.h"
#import "VDFileUploadQueue.h"
#import "VDFileDirectUploader.h"
#import "VDUploadStreamReader.h"

#import <WDNetwork-Base/WDNetworkConstant.h>
#import <WDNetwork-Base/WDNDeviceInfoUtil.h>
#import <WDNetwork-Base/WDNErrorDO.h>


@interface VDFilePartsUploader ()

@property (nonatomic, strong) NSData    *fileData;
@property (nonatomic, copy  ) NSString  *filePath;
@property (nonatomic, strong) UIImage   *image;

@property (nonatomic, assign) BOOL isOriginPath;

@property (nonatomic, copy  ) NSDictionary *param;

@property (nonatomic) dispatch_group_t group;

// 任务，用于cancel
@property (nonatomic, strong) VDInitUploadMisson *prepareMisson;
@property (nonatomic, strong) NSArray *partMissonArray;
@property (nonatomic, strong) VDPartUploadFinishMission *finishMisson;
@property (nonatomic, strong) VDQueryVideoMission *queryMission;

// 分片信息
@property (nonatomic, assign) long long totalSize;
@property (nonatomic, assign) NSUInteger partCount;
@property (nonatomic, assign) NSUInteger partSize;

@property (nonatomic, assign) NSUInteger completeCount;

// 返回值
@property (nonatomic, copy) NSString *uploadInitId;
@property (nonatomic, copy) NSString *key;

// rt
@property (nonatomic, assign) CFAbsoluteTime startTime;

@end

@implementation VDFilePartsUploader

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
    if ([VDFileUploador isForceUseDirect]) {
        return [VDFileDirectUploader UploadVIDEO:video scope:scope param:param progress:progress complete:complete sessionId:sessionId];
    }
    
    VDFilePartsUploader *uploader = [VDFilePartsUploader new];
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
        complete:(void(^)(VDUploadResultDO *result, WDNErrorDO *error))complete
{
    if (type == VDUpload_DOC) {
        return [VDFileDirectUploader UploadFile:data
                                          scope:scope
                                           type:type
                                        quality:quality
                                            prv:prv
                                       unadjust:unadjust
                                       progress:progress
                                       complete:complete];
    }
    
    if ([VDFileUploador isForceUseDirect]) {
        return [VDFileDirectUploader UploadFile:data
                                          scope:scope
                                           type:type
                                        quality:quality
                                            prv:prv
                                       unadjust:unadjust
                                       progress:progress
                                       complete:complete];
    }
    
    VDFilePartsUploader *uploader = [VDFilePartsUploader new];
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
    
    //upload
    [uploader upload];
    
    return uploader;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.uploadId = [NSString stringWithFormat:@"%.0f", [NSDate.date timeIntervalSince1970] * 1000 * 1000];
        
        _completeCount = 0;
    }
    return self;
}

- (void)upload {
    [VDFileUploader holdUploader:self];
    
    self.startTime = CFAbsoluteTimeGetCurrent();
    
    WDNErrorDO *error = nil;
    VDFileUploaderProcessDO *processData = [VDFileUploador processType:self.type
                                                              filePath:self.filePath
                                                              fileData:self.fileData
                                                                 image:self.image
                                                               quality:self.quality
                                                                 error:&error
                                                              uploadId:self.uploadId
                                                               isParts:YES];
    
    self.image = nil;
    self.fileData = nil;
    
    [self initMissionStart:processData error:error];
}

#pragma mark - init mission的逻辑

- (void)initMissionStart:(VDFileUploaderProcessDO *)processData error:(WDNErrorDO *)error {
    self.fileData = processData.fileData;
    self.filePath = processData.filePath;
    self.isOriginPath = processData.isOriginPath;
    self.totalSize = processData.fileSize;
    
    VDInitUploadMisson *prepareMisson = [VDInitUploadMisson new];
    prepareMisson.sessionId = self.sessionId;
    prepareMisson.scope = self.scope;
    prepareMisson.type = self.type;
    prepareMisson.retryTimes = [VDFileUploador retryTimes];
    prepareMisson.postParam = self.param;
    
    // 埋点用
    prepareMisson.filePath = processData.filePath;
    prepareMisson.isOriginPath = processData.isOriginPath;
    prepareMisson.originPath = self.filePath;
    prepareMisson.utUploadFileSize = processData.fileSize;
    
    self.prepareMisson = prepareMisson;
    
    if (error) {
        [self.prepareMisson sendUT:nil error:error];
        
        [self initMissionError:error];
    } else {
        __weak typeof(self) weakSelf = self;
        prepareMisson.completeBlock = ^(VDUploadResultDO *result, WDNErrorDO *innerError) {
            if (result && !innerError) {
                if (result.uploadId.length > 0) {
                    weakSelf.uploadInitId = result.uploadId;
                    
                    if (weakSelf.type == VDUpload_VIDEO) {
                        if (result.key.length > 0) {
                            weakSelf.key = result.key;
                            
                            [weakSelf initMissionSuccess];
                        } else {
                            innerError = [WDNErrorDO errorWithCode:WDNServerReturnCode msg:@"key为空"];
                            
                            [weakSelf initMissionError:innerError];
                        }
                    } else {
                        [weakSelf initMissionSuccess];
                    }
                } else {
                    innerError = [WDNErrorDO errorWithCode:WDNServerReturnCode msg:@"uploadId为空"];
                    
                    [weakSelf initMissionError:innerError];
                }
            } else {
                [weakSelf initMissionError:innerError];
            }
        };
        
        [prepareMisson query];
    }
}

- (void)initMissionError:(WDNErrorDO *)error {
    error.index = self.index;
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.complete ?: self.complete(nil, error);
        
        self.progress = nil;
        self.complete = nil;
    });
    
    [VDFileUploader removeUploader:self];
    [VDFileUploadQueue removeFileByMission:self.prepareMisson];
    
    self.prepareMisson = nil;
    self.image =  nil;
    self.fileData = nil;
}

- (void)initMissionSuccess {
    [self updatePartSize];
    if (self.fileData) {
        [self preparePartsFromNSData];
    } else {
        [self preparePartsFromPath];
    }
    
    [VDFileUploadQueue removeFileByMission:self.prepareMisson];
    
    self.prepareMisson = nil;
    self.image =  nil;
    self.fileData = nil;
}

#pragma mark - 分片的处理

- (void)updatePartSize {
    WDNDeviceInfoUtil *deviceInfoUtil = [WDNDeviceInfoUtil shareUtil];
    WDNStatus currentNetStatus = deviceInfoUtil.currentNetStatus;
    
    if (self.type == VDUpload_VIDEO) {
        switch (currentNetStatus) {
            case WDNStatusWIFI: {
                self.partSize = kVideoWIFIPartSize;
            } break;
            case WDNStatus4G: {
                self.partSize = kVideo4GPartSize;
            } break;
            default: {
                self.partSize = kVideo3GPartSize;
            } break;
        }
    } else {
        switch (currentNetStatus) {
            case WDNStatusWIFI: {
                self.partSize = kImgWIFIPartSize;
            } break;
            case WDNStatus4G: {
                self.partSize = kImg4GPartSize;
            } break;
            case WDNStatus3G: {
                self.partSize = kImg3GPartSize;
            } break;
            default: {
                self.partSize = kImg2GPartSize;
            } break;
        }
    }
}

- (void)preparePartsFromPath {
    dispatch_group_t group = dispatch_group_create();
    self.group = group;
    self.completeCount = 0;
    self.partCount = 0;
    
    VDUploadStreamReader *fileReader = [[VDUploadStreamReader alloc] initWithPath:self.filePath partSize:self.partSize];
    if (fileReader == nil) {
        [self preparePartsError:[WDNErrorDO errorWithCode:WDNClientParamError msg:@"文件读取失败"] partMissons:nil];
        return;
    }
    
    WDNErrorDO *error = [fileReader updateFileSize];
    if (error) {
        [self preparePartsError:error partMissons:nil];
        return;
    }

    self.partSize = fileReader.partSize;
    
    NSMutableArray *partMissonArray = [NSMutableArray array];
    NSUInteger partId = 1;
    
    BOOL readEnd = NO;
    while (!readEnd) {
        WDNErrorDO *indexError;
        NSData *partData = [fileReader readNextIfEnd:&readEnd error:&indexError];
        if (indexError) {
            [self preparePartsError:indexError partMissons:partMissonArray.copy];
            return;
        }
        if (!partData|| partData.length == 0) {
            break;
        }
        
        self.partCount++;
        
        VDPartUploadMission *partMission = [self createMissionByData:partData gcdGroup:group partId:partId++];
        partMission.utChunkCount = fileReader.partCount;
        
        [partMissonArray addObject:partMission];
    }
    [fileReader closeFile];
    
    if (partMissonArray.count == 0) {
        [self preparePartsError:[WDNErrorDO errorWithCode:WDNClientParamError msg:@"上传视频分片为空"] partMissons:nil];
        return;
    }
    
    [self preparePartsSuccess:partMissonArray.copy];
}

- (void)preparePartsFromNSData {
    NSData *fileData = self.fileData;
    
    // 改变一下分片大小, 平均分片
    double fPartSize = (double)self.partSize;
    double fLength = (double)fileData.length;
    NSUInteger count = ceil( fLength / fPartSize );
    fPartSize = ceil( fLength / count );

    NSUInteger partSize = fPartSize;
    self.partSize = partSize;
    
    dispatch_group_t group = dispatch_group_create();
    self.group = group;
    self.completeCount = 0;
    self.partCount = 0;
    
    NSMutableArray *partMissonArray = [NSMutableArray array];
    NSUInteger partId = 1;
    
    NSUInteger length = fileData.length;
    NSUInteger index = 0;
    
    while (index < length) {
        NSUInteger currentLen = MIN(partSize, length - index);
        char *buffer = malloc(sizeof(char) * currentLen);
        if (!buffer) {
            break;
        }

        [fileData getBytes:buffer range:NSMakeRange(index, currentLen)];
        NSData *currentPart = [NSData dataWithBytes:buffer length:currentLen];
        free(buffer);
        
        self.partCount++;
        
        VDPartUploadMission *partMission = [self createMissionByData:currentPart gcdGroup:group partId:partId++];
        partMission.utChunkCount = count;
        
        [partMissonArray addObject:partMission];

        index += currentLen;
    }
    
    if (partMissonArray.count == 0) {
        [self preparePartsError:[WDNErrorDO errorWithCode:WDNClientParamError msg:@"上传视频分片为空"] partMissons:nil];
        return;
    }
    
    [self preparePartsSuccess:partMissonArray.copy];
}

- (VDPartUploadMission *)createMissionByData:(NSData *)partData
                                    gcdGroup:(dispatch_group_t)group
                                      partId:(NSUInteger)partId
{
    VDPartUploadMission *partMission = [VDPartUploadMission new];
    partMission.scope = self.scope;
    partMission.sessionId = self.sessionId;
    partMission.uploadId = [NSString stringWithFormat:@"%@-%lu", self.uploadInitId, (unsigned long)partId];
    partMission.uploadInitId = self.uploadInitId;
    partMission.key = self.key;
    partMission.partId = partId++;
    partMission.type = self.type;
    partMission.fileData = partData;
    partMission.retryTimes = [VDFileUploador retryTimes];
    partMission.partSize = self.partSize;
    
    partMission.utChunkFileSize = partData.length;
    
    __weak typeof(self) weakself = self;
    partMission.completeBlock = ^(VDUploadResultDO *result, WDNErrorDO *error) {
        [weakself updateUploadProgress];
        
        if (result && !error) {
            dispatch_group_leave(group);
        } else {
            [weakself partsUploadError:error];
        }
    };
    dispatch_group_enter(group);
    
    // 把NSData先切换成文件，释放内存
    [VDFileUploadQueue saveFile:partMission];
    
    return partMission;
}

#pragma mark - 分片的回调

- (void)preparePartsError:(WDNErrorDO *)error partMissons:(NSArray *)partMissonArray {
    self.prepareMisson.errorDO = error;
    
    error.index = self.index;
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.complete ?: self.complete(nil, error);
        
        self.progress = nil;
        self.complete = nil;
    });
    
    [VDFileUploader removeUploader:self];
    
    for (VDPartUploadMission *partMission in partMissonArray) {
        [VDFileUploadQueue removeFileByMission:partMission];
    }
    self.group = nil;
}

- (void)preparePartsSuccess:(NSArray *)partMissonArray {
    self.partMissonArray = partMissonArray;
    
    [VDFileUploadQueue addUploadMissionList:self.partMissonArray];
    
    dispatch_group_notify(self.group, wdn_reponse_queue(), ^(){
        if (self.partMissonArray == nil || self.partMissonArray.count == 0) {
            /// 已经错误
            return;
        }
        self.partMissonArray = nil;
        
        [self finishMissonStart];
    });
}

/// 分片回调的进度
- (void)updateUploadProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.partCount <= 0) {
            return ;
        }
        
        self.completeCount += 1;
        if (self.completeCount > self.partCount) {
            self.completeCount = self.partCount;
        }
        
        NSProgress *progress = [NSProgress new];
        progress.completedUnitCount = self.completeCount;
        progress.totalUnitCount = self.partCount;
        
        self.aProgress = progress;
        if (self.progress) {
            self.progress(progress);
        }
    });
}

- (void)partsUploadError:(WDNErrorDO *)error {
    // 分片请求返回的同步处理，有可能同时返回错误，CallBack被执行多次
    @synchronized (self) {
        error.index = self.index;
        dispatch_async(dispatch_get_main_queue(), ^{
            !self.complete ?: self.complete(nil, error);
            
            self.progress = nil;
            self.complete = nil;
        });
        
        [VDFileUploader removeUploader:self];
        
        NSArray *partMissonArray = self.partMissonArray;
        self.partMissonArray = nil;
        for (VDPartUploadMission *mission in partMissonArray) {
            [mission cancel];
        }
        self.group = nil;
    }
}

#pragma mark - finish mission的逻辑

- (void)finishMissonStart {
    VDPartUploadFinishMission *finishMisson = [VDPartUploadFinishMission new];
    self.finishMisson = finishMisson;
    
    finishMisson.scope          = self.scope;
    finishMisson.sessionId      = self.sessionId;
    finishMisson.uploadInitId   = self.uploadInitId;
    finishMisson.key            = self.key;
    finishMisson.partStartTime  = self.startTime;
    finishMisson.prv            = self.prv;
    finishMisson.unadjust       = self.unadjust;
    finishMisson.retryTimes     = [VDFileUploador retryTimes];
    finishMisson.utChunkCount   = self.partCount;
    //ut
    finishMisson.utUploadFileSize = self.totalSize;
    finishMisson.postParam = self.param;
    
    NSString *partList = [NSString string];
    for (NSUInteger partId = 1; partId <= self.partCount; partId++) {
        partList = [partList stringByAppendingFormat:@",%ld", (long) partId];
    }
    
    // https://bugly.qq.com/v2/crash-reporting/crashes/900002343/27647964?pid=2
    if (partList.length > 0) {
        partList = [partList substringFromIndex:1];
    }
    
    finishMisson.partList = partList;
    finishMisson.type = self.type;
    
    __weak typeof(self) weakSelf = self;
    [finishMisson setCompleteBlock:^(VDUploadResultDO *result, WDNErrorDO *error) {
        weakSelf.result = result;
        
        if (result && !error) {
            [weakSelf finishMissonSuccess:result];
        } else {
            [weakSelf finishMissonError:error];
        }
    }];
    [finishMisson query];
}

- (void)finishMissonSuccess:(VDUploadResultDO *)result {
    result.index = self.index;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.complete ?: self.complete(result, nil);
        
        self.progress = nil;
        self.complete = nil;
    });
    
    [VDFileUploader removeUploader:self];
}

- (void)finishMissonError:(WDNErrorDO *)error {
    error.index = self.index;
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.complete ?: self.complete(nil, error);
        
        self.progress = nil;
        self.complete = nil;
    });
    
    [VDFileUploader removeUploader:self];
}

#pragma mark - 取消的逻辑

- (void)cancel:(WDNErrorDO *)error {
    self.progress = nil;
    self.complete = nil;
    
    if (self.prepareMisson) {
        [self.prepareMisson cancel];
    }
    
    NSArray *partMissonArray = self.partMissonArray;
    self.partMissonArray = nil;
    for (VDPartUploadMission *mission in partMissonArray) {
        [mission cancel];
    }
    
    if (self.finishMisson) {
        [self.finishMisson cancel];
    }
    
    [VDFileUploader removeUploader:self];
}

@end
