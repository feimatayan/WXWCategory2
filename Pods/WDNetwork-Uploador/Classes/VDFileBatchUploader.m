//
//  VDFileBatchUploader.m
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/9/7.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDFileBatchUploader.h"
#import "VDFileUploader.h"
#import "VDUploadResultDO.h"

#import <WDNetwork-Base/WDNetworkConstant.h>
#import <WDNetwork-Base/WDNErrorDO.h>


@interface VDFileBatchUploader ()

@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) VDFileUploader *currentLoader;

@property (nonatomic, copy) void(^callback)(NSArray *results, WDNErrorDO *error);
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) WDNErrorDO *error;

@end

@implementation VDFileBatchUploader

+ (instancetype)UploadFiles:(NSArray *)files
                      scope:(NSString *)scope
                       type:(VDUploadType)type
                    quality:(CGFloat)quality
                        prv:(BOOL)prv
                   unadjust:(BOOL)unadjust
                   callback:(void(^)(NSArray *results, WDNErrorDO *error))callback
{
    if (!files || ![files isKindOfClass:[NSArray class]] || files.count == 0) {
        if (callback) {
            callback(nil, [WDNErrorDO errorWithCode:WDNClientParamError msg:@"参数错误"]);
        }
        return nil;
    }
    
    VDFileBatchUploader *uploader = [VDFileBatchUploader new];
    uploader.type = type;
    uploader.scope = scope;
    uploader.prv = prv;
    uploader.unadjust = unadjust;
    uploader.quality = quality;
    uploader.files = [files mutableCopy];
    uploader.callback = callback;
    
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
    @synchronized (self) {
        [VDFileUploader holdUploader:self];
        
        self.index = 0;
        self.results = [NSMutableArray array];
        
        [self uploadOne];
    }
}

- (void)uploadOne {
    @synchronized (self) {
        if (self.files.count == 0) {
            [self completeAll];
            
            return;
        }
        
        id file = self.files[0];
        [self.files removeObjectAtIndex:0];
        
        __weak typeof(self) weakself = self;
        VDFileUploader *fileUploader = [VDFileUploader UploadFile:file scope:self.scope type:self.type quality:self.quality prv:self.prv unadjust:self.unadjust progress:nil complete:^(VDUploadResultDO *result, WDNErrorDO *error) {
            if (result && !error) {
                [weakself.results addObject:result];
                
                [weakself uploadOne];
            } else {
                weakself.error = error;
                
                [weakself completeAll];
            }
        }];
        fileUploader.index = self.index++;
        
        self.currentLoader = fileUploader;
    }
}

- (void)completeAll {
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.callback ?: self.callback(self.results, self.error);
        
        self.progress = nil;
        self.callback = nil;
        
        [VDFileUploader removeUploader:self];
    });
}

- (void)cancel:(WDNErrorDO *)error {
    self.files = nil;
    if (self.callback) {
        self.callback(nil, error);
        self.callback = nil;
    }
    
    if (self.currentLoader) {
        [self.currentLoader cancel];
    }
    
    [VDFileUploader removeUploader:self];
}

@end
