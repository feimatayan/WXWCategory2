//
// Created by 石恒智 on 2018/12/9.
// Copyright (c) 2018 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_uploadImage.h"
#import "NSObject+YYModel.h"
#import "UIImage+VDCompress.h"
#import "VDFileUploader.h"
#import "VDUploadResultDO.h"
#import "VDFileBatchUploader.h"
#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define UNLOCK(lock) dispatch_semaphore_signal(lock);

@implementation WDJSBridgeApiUploadImageCompressDO

@end

@implementation WDJSBridgeApiUploadImageControlDO
- (instancetype)init {
    self = [super init];
    if (self) {
        _fileType = @"image";
        _unadjust = NO;
        _isPrivate = NO;
    }
    
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"isPrivate": @"private"
    };
}
@end

@implementation WDJSBridgeApiUploadImagedataDO

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"localPathUrlArray": @"images",
            @"base64DataString": @"base64"
    };
}

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
            @"localPathUrlArray": [NSString class]
    };
}
@end

@interface WDJSBridgeApi_WDJSBridge_uploadImage ()
@property(strong, nonatomic, nonnull) dispatch_semaphore_t compressLock;
@property(strong, nonatomic, nonnull) dispatch_semaphore_t uploadLock;
@end

@implementation WDJSBridgeApi_WDJSBridge_uploadImage

- (instancetype)init {
    self = [super init];
    if (self) {
        _compressLock = dispatch_semaphore_create(1);
        _uploadLock = dispatch_semaphore_create(1);
    }

    return self;
}


- (void)callApiWithContextInfo:(NSDictionary<NSString *, id> *)info callback:(WDJSBridgeHandlerCallback)callback {
    WDJSBridgeApiUploadImageCompressDO *compressDO = [WDJSBridgeApiUploadImageCompressDO yy_modelWithDictionary:self.params[@"compress"]];
    WDJSBridgeApiUploadImageControlDO *controlDO = [WDJSBridgeApiUploadImageControlDO yy_modelWithDictionary:self.params[@"control"]];;
    WDJSBridgeApiUploadImagedataDO *dataDO = [WDJSBridgeApiUploadImagedataDO yy_modelWithDictionary:self.params[@"data"]];

    if (![controlDO.scope length]) {
        callback(WDJSBridgeHandlerResponseCodeFailure, [self errorResponseWithCode:@"-500001" message:@"scope can not be null"]);
        return;
    }

    if (![self hasImageData:dataDO]) {
        callback(WDJSBridgeHandlerResponseCodeFailure, [self errorResponseWithCode:@"-500005" message:@"take photo failed"]);
        return;
    }

    NSArray<NSData *> *imageArray;
    if (dataDO.base64DataString) {
        if ([dataDO.base64DataString hasPrefix:@"data:image"]) {
            dataDO.base64DataString = [dataDO.base64DataString componentsSeparatedByString:@","].lastObject;
        }
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:dataDO.base64DataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        if (!image) {
            callback(WDJSBridgeHandlerResponseCodeFailure, [self errorResponseWithCode:@"-500002" message:@"base64 decode failed"]);
            return;
        }
        imageArray = @[imageData];
    } else {
        __block NSMutableArray *imageArrayM = @[].mutableCopy;
        for (NSString *localUrl in dataDO.localPathUrlArray) {
            NSString *base64ImageString;
            if ([localUrl hasPrefix:@"data:image"]) {
                base64ImageString = [localUrl componentsSeparatedByString:@","].lastObject;
            }
            if (base64ImageString) {
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64ImageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *localImage = [UIImage imageWithData:imageData];
                if (localImage) {
                    [imageArrayM addObject:imageData];
                }
            } else {
                NSData *imageData = [[NSData alloc] initWithContentsOfFile:localUrl];
                if (imageData) {
                    [imageArrayM addObject:imageData];
                }
            }

        }
        imageArray = imageArrayM.copy;
    }

    [self compressImageArray:imageArray
                        size:CGSizeMake(compressDO.width, compressDO.height)
                 maxFileSize:compressDO.size * 1024
             completionBlock:^(NSArray<NSData *> *compressedArray) {
                 [self uploadImageArray:compressedArray
                                  scope:controlDO.scope
                              isPrivate:controlDO.isPrivate
                               unadjust:controlDO.unadjust
                               complete:^(NSArray<NSDictionary *> *resArray) {
                                   if (!resArray) {
                                       callback(WDJSBridgeHandlerResponseCodeSuccess, @{});
                                   } else {
                                       callback(WDJSBridgeHandlerResponseCodeSuccess, @{@"result": resArray});
                                   }
                               }];
             }];
}

- (void)compressImageArray:(NSArray<NSData *> *)imageArray size:(CGSize)size maxFileSize:(NSInteger)maxFileSize completionBlock:(void (^)(NSArray<NSData *> *compressedArray))completionBlock {
    if (!completionBlock) {
        return;
    }
    if (![imageArray count]) {
        completionBlock(nil);
    }

    __block NSInteger count = imageArray.count;
    __block NSArray *res = @[];
    for (NSData *image in imageArray) {
        [UIImage vd_compressImageData:image
                                level:VDCompressLevel_1500
                              quality:1
                            imageSize:size
                          maxFileSize:maxFileSize
                             callback:^(NSData *data) {
                                 LOCK(self.compressLock)
                                 NSMutableArray *resM = res.mutableCopy;
                                 if (data) {
                                     [resM addObject:data];
                                 }
                                 res = resM.copy;
                                 UNLOCK(self.compressLock);
                                 count--;
                                 if (count <= 0) {
                                     completionBlock(res);
                                 }
                             }];
    }
}

- (void)uploadImageArray:(NSArray<NSData *> *)imageDataArray
                   scope:(NSString *)scope
               isPrivate:(BOOL)isPrivate
                unadjust:(BOOL)unadjust
                complete:(void (^)(NSArray<NSDictionary *> *resArray))complete {
    if (![imageDataArray count]) {
        if (complete) {
            complete(nil);
        }
    }
    __block NSInteger count = imageDataArray.count;
    __block NSArray<NSDictionary *> *resArray = @[];
    for (NSData *imageData in imageDataArray) {
        [VDFileUploader UploadFile:imageData
                             scope:scope
                              type:VDUpload_IMG
                           quality:1.0f
                               prv:isPrivate
                          unadjust:unadjust
                          progress:nil
                          complete:^(VDUploadResultDO *result, WDNErrorDO *error) {

                              NSMutableDictionary *res = @{}.mutableCopy;
                              if (error) {
                                  res[@"code"] = @(result.code);
                                  res[@"message"] = result.message ?: @"";
                                  res[@"traceid"] = @"";
                                  NSString *imageBase64Str = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                                  res[@"file"] = imageBase64Str ?: @"";
                              } else {
                                  res[@"code"] = @(result.code);
                                  res[@"message"] = result.message ?: @"";
                                  res[@"url"] = result.url ?: @"";
                                  res[@"innerUrl"] = result.innerUrl ?: @"";
                                  res[@"traceid"] = result.traceId ?: @"";
                              }
                              LOCK(self.uploadLock)
                              NSMutableArray *resM = resArray.mutableCopy;
                              if (res) {
                                  [resM addObject:res];
                              }
                              resArray = resM.copy;
                              UNLOCK(self.uploadLock)
                              count--;
                              if (count <= 0) {
                                  complete(resArray);
                              }
                          }];
    }


}

- (BOOL)hasImageData:(WDJSBridgeApiUploadImagedataDO *)dataDO {
    if ([dataDO.base64DataString length]) {
        return YES;
    }
    if ([dataDO.localPathUrlArray count]) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)errorResponseWithCode:(NSString *)code message:(NSString *)message {
    NSMutableDictionary *res = @{}.mutableCopy;
    if (code) {
        res[@"code"] = code;
    }
    if (message) {
        res[@"message"] = message;
    }
    return @{@"result": @[res.copy ?: @{}]};
}
@end
